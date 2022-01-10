defmodule GroupsChatWeb.ChatLive.Index do
  import Phoenix.LiveView.Helpers

  use GroupsChatWeb, :live_view

  alias GroupsChat.Chats
  alias GroupsChat.Chats.Chat
  alias GroupsChatWeb.Presence

  defp topic(id), do: "room:#{id}"

  @impl true
  def mount(%{"id" => id}, session, socket) do
    socket = socket |> assign(%{"id" => id})

    socket =
      socket
      |> PhoenixLiveSession.maybe_subscribe(session)
      |> assign(session)

    messages = Chats.list_messages(id)
    username = Map.get(session, "username")

    case username do
      nil ->
        {:ok, socket |> redirect(to: "/")}

      _ ->
        GroupsChatWeb.Endpoint.subscribe(topic(id))

        Presence.track(
          self(),
          topic(id),
          username,
          %{
            username: username
          }
        )

        {:ok,
         socket
         |> assign(
           id: id,
           username: username,
           message: Chats.Chat.changeset_message(),
           messages: messages,
           connected_users: []
         )}
    end
  end

  @impl true
  def handle_event("message", session, socket) do
    params = Map.get(session, "message")

    id = Map.get(params, "key")

    with {:ok, %Chat{} = message} <-
           Chats.create_chat(params) do
      GroupsChatWeb.Endpoint.broadcast(topic(id), "message",
        messages:
          Enum.concat(socket.assigns.messages, [
            %{
              :username => message.username,
              :body => message.body,
              :inserted_at => message.inserted_at
            }
          ])
      )

      {:noreply,
       socket
       |> push_event("input", %{valid: true})
       |> assign(
         message: %{
           username: message.username,
           messages: message,
           message: Chats.Chat.changeset_message(),
           body: message.body
         }
       )}
    else
      _err -> {:noreply, socket |> put_flash(:error, "An unexpected error happened")}
    end
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    id = Map.get(socket.assigns, "id")

    connected_users =
      Presence.list(topic(id))
      |> Enum.map(fn {_user_id, data} -> data[:metas] |> List.first() end)

    {:noreply, assign(socket, connected_users: connected_users)}
  end

  def handle_info(%{event: "message", payload: state}, socket) do
    socket = socket |> assign(state)
    {:noreply, socket |> push_event("message", %{valid: true})}
  end
end

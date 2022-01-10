defmodule GroupsChatWeb.PageLive do
  use GroupsChatWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> PhoenixLiveSession.maybe_subscribe(session)
      |> put_session_assigns(session)

    username = Map.get(session, "username")

    case username do
      nil ->
        {:ok, socket}

      _ ->
        {:ok, socket |> redirect(to: "/groups")}
    end
  end

  @impl true
  def handle_info({:live_session_updated, session}, socket) do
    {:noreply, assign(socket, session)}
  end

  @impl true
  def handle_event("submit", %{"username" => username}, socket) do
    PhoenixLiveSession.put_session(socket, "username", username)

    {:noreply, socket |> redirect(to: "/groups")}
  end

  defp put_session_assigns(socket, session) do
    socket
    |> assign(:username, Map.get(session, "username", ""))
    |> assign(:latest_groups, Map.get(session, "latest_groups", []))
  end
end

defmodule GroupsChatWeb.GroupLive.Index do
  use GroupsChatWeb, :live_view

  alias GroupsChat.Groups
  alias GroupsChat.Groups.Group
  alias Ecto.UUID

  @impl true
  def mount(_params, session, socket) do
    username = Map.get(session, "username")

    case username do
      nil ->
        {:ok, socket |> redirect(to: "/")}

      _ ->
        {:ok, socket}
    end
  end

  @impl true
  def handle_event("create_group", %{"name" => name}, socket) do
    with {:ok, %Group{} = group} <-
           Groups.create_group(%{"key" => UUID.generate(), "name" => name}) do
      {:noreply, socket |> put_flash(:info, "Group key: #{group.key}") |> assign(result: name)}
    else
      _ -> {:noreply, socket}
    end
  end

  @impl true
  def handle_event("join_group", %{"key" => key}, socket) do
    re = ~r/^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$/

    case String.match?(key, re) do
      true ->
        case Groups.get_group(key) do
          nil ->
            {:noreply, socket |> put_flash(:error, "Invalid group key.") |> assign(result: nil)}

          _group ->
            {:noreply, socket |> redirect(to: "/groups/#{key}")}
        end

      false ->
        {:noreply, socket |> put_flash(:error, "Invalid group key.") |> assign(result: nil)}
    end
  end
end

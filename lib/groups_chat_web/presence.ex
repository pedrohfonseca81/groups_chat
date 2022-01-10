defmodule GroupsChatWeb.Presence do
  use Phoenix.Presence,
    otp_app: :groups_chat,
    pubsub_server: GroupsChat.PubSub
end

defmodule GroupsChat.Repo do
  use Ecto.Repo,
    otp_app: :groups_chat,
    adapter: Ecto.Adapters.Postgres
end

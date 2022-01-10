defmodule GroupsChat.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  @attrs [:key, :body, :username]

  schema "messages" do
    field :body, :string
    field :username, :string
    field :key, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(chat, attrs \\ %{}) do
    chat
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
  end

  @spec changeset_message :: Ecto.Changeset.t()
  def changeset_message do
    changeset(%__MODULE__{})
  end

  def changeset_message(changeset, changes) do
    changeset(changeset, changes)
  end
end

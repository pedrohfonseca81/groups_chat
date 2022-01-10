defmodule GroupsChat.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :key, Ecto.UUID
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:key, :name])
    |> validate_required([:key, :name])
  end
end

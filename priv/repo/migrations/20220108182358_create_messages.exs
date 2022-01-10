defmodule GroupsChat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :key, :uuid
      add :username, :string
      add :body, :string

      timestamps()
    end
  end
end

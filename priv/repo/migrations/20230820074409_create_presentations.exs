defmodule Feelis.Repo.Migrations.CreatePresentations do
  use Ecto.Migration

  def change do
    create table(:presentations) do
      add :title, :string, null: false

      timestamps()
    end
  end
end

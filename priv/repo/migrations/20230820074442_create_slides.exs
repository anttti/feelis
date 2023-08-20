defmodule Feelis.Repo.Migrations.CreateSlides do
  use Ecto.Migration

  def change do
    create table(:slides) do
      add :title, :string, null: false
      add :description, :string, null: false
      add :presentation_id, references(:presentations, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:slides, [:presentation_id])
  end
end

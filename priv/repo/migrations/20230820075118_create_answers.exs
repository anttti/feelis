defmodule Feelis.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :answer, :string, null: false
      add :user_id, :string, null: false
      add :slide_id, references(:slides, on_delete: :nothing)

      timestamps()
    end

    create index(:answers, [:slide_id])
  end
end

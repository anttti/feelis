defmodule Feelis.Presentations.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :answer, :string
    field :user_id, :string
    belongs_to :slide, Feelis.Presentations.Slide

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:answer, :user_id, :slide_id])
    |> validate_required([:answer, :user_id, :slide_id])
  end
end

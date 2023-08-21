defmodule Feelis.Presentations.Slide do
  use Ecto.Schema
  import Ecto.Changeset

  schema "slides" do
    field :description, :string
    field :title, :string
    belongs_to :presentation, Feelis.Presentations.Presentation
    has_many :answers, Feelis.Presentations.Answer

    timestamps()
  end

  @doc false
  def changeset(slide, attrs) do
    slide
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end

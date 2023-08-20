defmodule Feelis.Presentations.Presentation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "presentations" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(presentation, attrs) do
    presentation
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end

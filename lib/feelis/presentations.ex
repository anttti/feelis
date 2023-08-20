defmodule Feelis.Presentations do
  @moduledoc """
  The Presentations context.
  """

  import Ecto.Query, warn: false
  alias Feelis.Repo

  alias Feelis.Presentations.Presentation

  @doc """
  Returns the list of presentations.

  ## Examples

      iex> list_presentations()
      [%Presentation{}, ...]

  """
  def list_presentations do
    Repo.all(Presentation)
  end

  @doc """
  Gets a single presentation.

  Raises `Ecto.NoResultsError` if the Presentation does not exist.

  ## Examples

      iex> get_presentation!(123)
      %Presentation{}

      iex> get_presentation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_presentation!(id), do: Repo.get!(Presentation, id)

  @doc """
  Creates a presentation.

  ## Examples

      iex> create_presentation(%{field: value})
      {:ok, %Presentation{}}

      iex> create_presentation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_presentation(attrs \\ %{}) do
    %Presentation{}
    |> Presentation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a presentation.

  ## Examples

      iex> update_presentation(presentation, %{field: new_value})
      {:ok, %Presentation{}}

      iex> update_presentation(presentation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_presentation(%Presentation{} = presentation, attrs) do
    presentation
    |> Presentation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a presentation.

  ## Examples

      iex> delete_presentation(presentation)
      {:ok, %Presentation{}}

      iex> delete_presentation(presentation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_presentation(%Presentation{} = presentation) do
    Repo.delete(presentation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking presentation changes.

  ## Examples

      iex> change_presentation(presentation)
      %Ecto.Changeset{data: %Presentation{}}

  """
  def change_presentation(%Presentation{} = presentation, attrs \\ %{}) do
    Presentation.changeset(presentation, attrs)
  end

  alias Feelis.Presentations.Slide

  @doc """
  Returns the list of slides.

  ## Examples

      iex> list_slides()
      [%Slide{}, ...]

  """
  def list_slides(presentation) do
    from(s in Slide, where: [presentation_id: ^presentation.id], order_by: [asc: :id])
    |> Repo.all()
  end

  @doc """
  Gets a single slide.

  Raises `Ecto.NoResultsError` if the Slide does not exist.

  ## Examples

      iex> get_slide!(123)
      %Slide{}

      iex> get_slide!(456)
      ** (Ecto.NoResultsError)

  """
  def get_slide!(id), do: Repo.get!(Slide, id)

  @doc """
  Creates a slide.

  ## Examples

      iex> create_slide(%{field: value})
      {:ok, %Slide{}}

      iex> create_slide(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_slide(attrs \\ %{}) do
    %Slide{}
    |> Slide.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a slide.

  ## Examples

      iex> update_slide(slide, %{field: new_value})
      {:ok, %Slide{}}

      iex> update_slide(slide, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_slide(%Slide{} = slide, attrs) do
    slide
    |> Slide.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a slide.

  ## Examples

      iex> delete_slide(slide)
      {:ok, %Slide{}}

      iex> delete_slide(slide)
      {:error, %Ecto.Changeset{}}

  """
  def delete_slide(%Slide{} = slide) do
    Repo.delete(slide)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking slide changes.

  ## Examples

      iex> change_slide(slide)
      %Ecto.Changeset{data: %Slide{}}

  """
  def change_slide(%Slide{} = slide, attrs \\ %{}) do
    Slide.changeset(slide, attrs)
  end

  alias Feelis.Presentations.Answer

  @doc """
  Returns the list of answers.

  ## Examples

      iex> list_answers()
      [%Answer{}, ...]

  """
  def list_answers(slide) do
    from(a in Answer, where: [slide_id: ^slide.id], order_by: [asc: :id])
    |> Repo.all()
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{data: %Answer{}}

  """
  def change_answer(%Answer{} = answer, attrs \\ %{}) do
    Answer.changeset(answer, attrs)
  end
end

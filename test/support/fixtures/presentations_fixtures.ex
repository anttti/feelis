defmodule Feelis.PresentationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Feelis.Presentations` context.
  """

  @doc """
  Generate a presentation.
  """
  def presentation_fixture(attrs \\ %{}) do
    {:ok, presentation} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Feelis.Presentations.create_presentation()

    presentation
  end

  @doc """
  Generate a slide.
  """
  def slide_fixture(attrs \\ %{}) do
    {:ok, slide} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Feelis.Presentations.create_slide()

    slide
  end

  @doc """
  Generate a answer.
  """
  def answer_fixture(attrs \\ %{}) do
    {:ok, answer} =
      attrs
      |> Enum.into(%{
        answer: "some answer",
        user_id: "some user_id"
      })
      |> Feelis.Presentations.create_answer()

    answer
  end
end

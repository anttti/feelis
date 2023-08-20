defmodule Feelis.PresentationsTest do
  use Feelis.DataCase

  alias Feelis.Presentations

  describe "presentations" do
    alias Feelis.Presentations.Presentation

    import Feelis.PresentationsFixtures

    @invalid_attrs %{title: nil}

    test "list_presentations/0 returns all presentations" do
      presentation = presentation_fixture()
      assert Presentations.list_presentations() == [presentation]
    end

    test "get_presentation!/1 returns the presentation with given id" do
      presentation = presentation_fixture()
      assert Presentations.get_presentation!(presentation.id) == presentation
    end

    test "create_presentation/1 with valid data creates a presentation" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Presentation{} = presentation} = Presentations.create_presentation(valid_attrs)
      assert presentation.title == "some title"
    end

    test "create_presentation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Presentations.create_presentation(@invalid_attrs)
    end

    test "update_presentation/2 with valid data updates the presentation" do
      presentation = presentation_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Presentation{} = presentation} = Presentations.update_presentation(presentation, update_attrs)
      assert presentation.title == "some updated title"
    end

    test "update_presentation/2 with invalid data returns error changeset" do
      presentation = presentation_fixture()
      assert {:error, %Ecto.Changeset{}} = Presentations.update_presentation(presentation, @invalid_attrs)
      assert presentation == Presentations.get_presentation!(presentation.id)
    end

    test "delete_presentation/1 deletes the presentation" do
      presentation = presentation_fixture()
      assert {:ok, %Presentation{}} = Presentations.delete_presentation(presentation)
      assert_raise Ecto.NoResultsError, fn -> Presentations.get_presentation!(presentation.id) end
    end

    test "change_presentation/1 returns a presentation changeset" do
      presentation = presentation_fixture()
      assert %Ecto.Changeset{} = Presentations.change_presentation(presentation)
    end
  end

  describe "slides" do
    alias Feelis.Presentations.Slide

    import Feelis.PresentationsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_slides/0 returns all slides" do
      slide = slide_fixture()
      assert Presentations.list_slides() == [slide]
    end

    test "get_slide!/1 returns the slide with given id" do
      slide = slide_fixture()
      assert Presentations.get_slide!(slide.id) == slide
    end

    test "create_slide/1 with valid data creates a slide" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Slide{} = slide} = Presentations.create_slide(valid_attrs)
      assert slide.description == "some description"
      assert slide.title == "some title"
    end

    test "create_slide/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Presentations.create_slide(@invalid_attrs)
    end

    test "update_slide/2 with valid data updates the slide" do
      slide = slide_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Slide{} = slide} = Presentations.update_slide(slide, update_attrs)
      assert slide.description == "some updated description"
      assert slide.title == "some updated title"
    end

    test "update_slide/2 with invalid data returns error changeset" do
      slide = slide_fixture()
      assert {:error, %Ecto.Changeset{}} = Presentations.update_slide(slide, @invalid_attrs)
      assert slide == Presentations.get_slide!(slide.id)
    end

    test "delete_slide/1 deletes the slide" do
      slide = slide_fixture()
      assert {:ok, %Slide{}} = Presentations.delete_slide(slide)
      assert_raise Ecto.NoResultsError, fn -> Presentations.get_slide!(slide.id) end
    end

    test "change_slide/1 returns a slide changeset" do
      slide = slide_fixture()
      assert %Ecto.Changeset{} = Presentations.change_slide(slide)
    end
  end

  describe "answers" do
    alias Feelis.Presentations.Answer

    import Feelis.PresentationsFixtures

    @invalid_attrs %{answer: nil, user_id: nil}

    test "list_answers/0 returns all answers" do
      answer = answer_fixture()
      assert Presentations.list_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Presentations.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      valid_attrs = %{answer: "some answer", user_id: "some user_id"}

      assert {:ok, %Answer{} = answer} = Presentations.create_answer(valid_attrs)
      assert answer.answer == "some answer"
      assert answer.user_id == "some user_id"
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Presentations.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      update_attrs = %{answer: "some updated answer", user_id: "some updated user_id"}

      assert {:ok, %Answer{} = answer} = Presentations.update_answer(answer, update_attrs)
      assert answer.answer == "some updated answer"
      assert answer.user_id == "some updated user_id"
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Presentations.update_answer(answer, @invalid_attrs)
      assert answer == Presentations.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Presentations.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Presentations.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Presentations.change_answer(answer)
    end
  end
end

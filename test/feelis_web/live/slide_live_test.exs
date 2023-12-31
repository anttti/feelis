defmodule FeelisWeb.SlideLiveTest do
  use FeelisWeb.ConnCase

  import Phoenix.LiveViewTest
  import Feelis.PresentationsFixtures

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  defp create_slide(_) do
    slide = slide_fixture()
    %{slide: slide}
  end

  describe "Index" do
    setup [:create_slide]

    test "lists all slides", %{conn: conn, slide: slide} do
      {:ok, _index_live, html} = live(conn, ~p"/slides")

      assert html =~ "Listing Slides"
      assert html =~ slide.description
    end

    test "saves new slide", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/slides")

      assert index_live |> element("a", "New Slide") |> render_click() =~
               "New Slide"

      assert_patch(index_live, ~p"/slides/new")

      assert index_live
             |> form("#slide-form", slide: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#slide-form", slide: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/slides")

      html = render(index_live)
      assert html =~ "Slide created successfully"
      assert html =~ "some description"
    end

    test "updates slide in listing", %{conn: conn, slide: slide} do
      {:ok, index_live, _html} = live(conn, ~p"/slides")

      assert index_live |> element("#slides-#{slide.id} a", "Edit") |> render_click() =~
               "Edit Slide"

      assert_patch(index_live, ~p"/slides/#{slide}/edit")

      assert index_live
             |> form("#slide-form", slide: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#slide-form", slide: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/slides")

      html = render(index_live)
      assert html =~ "Slide updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes slide in listing", %{conn: conn, slide: slide} do
      {:ok, index_live, _html} = live(conn, ~p"/slides")

      assert index_live |> element("#slides-#{slide.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#slides-#{slide.id}")
    end
  end

  describe "Show" do
    setup [:create_slide]

    test "displays slide", %{conn: conn, slide: slide} do
      {:ok, _show_live, html} = live(conn, ~p"/slides/#{slide}")

      assert html =~ "Show Slide"
      assert html =~ slide.description
    end

    test "updates slide within modal", %{conn: conn, slide: slide} do
      {:ok, show_live, _html} = live(conn, ~p"/slides/#{slide}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Slide"

      assert_patch(show_live, ~p"/slides/#{slide}/show/edit")

      assert show_live
             |> form("#slide-form", slide: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#slide-form", slide: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/slides/#{slide}")

      html = render(show_live)
      assert html =~ "Slide updated successfully"
      assert html =~ "some updated description"
    end
  end
end

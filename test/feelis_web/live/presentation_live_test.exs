defmodule FeelisWeb.PresentationLiveTest do
  use FeelisWeb.ConnCase

  import Phoenix.LiveViewTest
  import Feelis.PresentationsFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  defp create_presentation(_) do
    presentation = presentation_fixture()
    %{presentation: presentation}
  end

  describe "Index" do
    setup [:create_presentation]

    test "lists all presentations", %{conn: conn, presentation: presentation} do
      {:ok, _index_live, html} = live(conn, ~p"/presentations")

      assert html =~ "Listing Presentations"
      assert html =~ presentation.title
    end

    test "saves new presentation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/presentations")

      assert index_live |> element("a", "New Presentation") |> render_click() =~
               "New Presentation"

      assert_patch(index_live, ~p"/presentations/new")

      assert index_live
             |> form("#presentation-form", presentation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#presentation-form", presentation: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/presentations")

      html = render(index_live)
      assert html =~ "Presentation created successfully"
      assert html =~ "some title"
    end

    test "updates presentation in listing", %{conn: conn, presentation: presentation} do
      {:ok, index_live, _html} = live(conn, ~p"/presentations")

      assert index_live |> element("#presentations-#{presentation.id} a", "Edit") |> render_click() =~
               "Edit Presentation"

      assert_patch(index_live, ~p"/presentations/#{presentation}/edit")

      assert index_live
             |> form("#presentation-form", presentation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#presentation-form", presentation: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/presentations")

      html = render(index_live)
      assert html =~ "Presentation updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes presentation in listing", %{conn: conn, presentation: presentation} do
      {:ok, index_live, _html} = live(conn, ~p"/presentations")

      assert index_live |> element("#presentations-#{presentation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#presentations-#{presentation.id}")
    end
  end

  describe "Show" do
    setup [:create_presentation]

    test "displays presentation", %{conn: conn, presentation: presentation} do
      {:ok, _show_live, html} = live(conn, ~p"/presentations/#{presentation}")

      assert html =~ "Show Presentation"
      assert html =~ presentation.title
    end

    test "updates presentation within modal", %{conn: conn, presentation: presentation} do
      {:ok, show_live, _html} = live(conn, ~p"/presentations/#{presentation}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Presentation"

      assert_patch(show_live, ~p"/presentations/#{presentation}/show/edit")

      assert show_live
             |> form("#presentation-form", presentation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#presentation-form", presentation: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/presentations/#{presentation}")

      html = render(show_live)
      assert html =~ "Presentation updated successfully"
      assert html =~ "some updated title"
    end
  end
end

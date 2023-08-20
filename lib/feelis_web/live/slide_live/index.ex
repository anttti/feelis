defmodule FeelisWeb.SlideLive.Index do
  use FeelisWeb, :live_view

  alias Feelis.Presentations
  alias Feelis.Presentations.Slide

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :slides, Presentations.list_slides())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Slide")
    |> assign(:slide, Presentations.get_slide!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Slide")
    |> assign(:slide, %Slide{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Slides")
    |> assign(:slide, nil)
  end

  @impl true
  def handle_info({FeelisWeb.SlideLive.FormComponent, {:saved, slide}}, socket) do
    {:noreply, stream_insert(socket, :slides, slide)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    slide = Presentations.get_slide!(id)
    {:ok, _} = Presentations.delete_slide(slide)

    {:noreply, stream_delete(socket, :slides, slide)}
  end
end

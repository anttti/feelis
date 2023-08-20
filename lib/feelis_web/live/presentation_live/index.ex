defmodule FeelisWeb.PresentationLive.Index do
  use FeelisWeb, :live_view

  alias Feelis.Presentations
  alias Feelis.Presentations.Presentation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :presentations, Presentations.list_presentations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Presentation")
    |> assign(:presentation, Presentations.get_presentation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Presentation")
    |> assign(:presentation, %Presentation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Presentations")
    |> assign(:presentation, nil)
  end

  @impl true
  def handle_info({FeelisWeb.PresentationLive.FormComponent, {:saved, presentation}}, socket) do
    {:noreply, stream_insert(socket, :presentations, presentation)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    presentation = Presentations.get_presentation!(id)
    {:ok, _} = Presentations.delete_presentation(presentation)

    {:noreply, stream_delete(socket, :presentations, presentation)}
  end
end

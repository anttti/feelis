defmodule FeelisWeb.PresentLive.Index do
  use FeelisWeb, :live_view

  alias Feelis.Presentations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    presentation = Presentations.get_presentation!(id)
    slide = Enum.at(presentation.slides, 0)

    {:noreply,
     socket
     |> assign(:presentation, presentation)
     |> assign(:current_slide, slide)
     |> assign(:current_index, 0)}
  end

  @impl true
  def handle_event("next_slide", _params, socket) do
    next_index = socket.assigns.current_index + 1

    if Enum.count(socket.assigns.presentation.slides) > next_index do
      {:noreply,
       socket
       |> assign(:current_index, next_index)
       |> assign(:current_slide, Enum.at(socket.assigns.presentation.slides, next_index))}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("previous_slide", _params, socket) do
    next_index = socket.assigns.current_index - 1

    if next_index >= 0 do
      {:noreply,
       socket
       |> assign(:current_index, next_index)
       |> assign(:current_slide, Enum.at(socket.assigns.presentation.slides, next_index))}
    else
      {:noreply, socket}
    end
  end
end

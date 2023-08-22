defmodule FeelisWeb.ViewerLive.Index do
  use FeelisWeb, :live_view

  alias Feelis.Presentations

  @page_turn_topic "topic:page_turn"
  @join_topic "topic:join"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      FeelisWeb.Endpoint.subscribe(@page_turn_topic)

      # publish a message "I've joined, what's up? to get the current slide"
      FeelisWeb.Endpoint.broadcast_from(self(), @join_topic, "join", %{pid: self()})
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    presentation = Presentations.get_presentation!(id)

    {:noreply,
     socket
     |> assign(:presentation, presentation)
     |> assign(:current_slide, nil)}
  end

  @impl true
  def handle_info(%{topic: @page_turn_topic, payload: state}, socket) do
    {:noreply, socket |> assign(:current_slide, state.current_slide)}
  end

  @impl true
  def handle_cast({:sync, current_slide}, socket) do
    {:noreply, socket |> assign(:current_slide, current_slide)}
  end
end

defmodule FeelisWeb.PresentLive.Index do
  use FeelisWeb, :live_view

  alias Feelis.Presentations
  alias Feelis.Presence
  alias Feelis.PubSub

  @presence "poll:presence"
  @page_turn_topic "topic:page_turn"
  @join_topic "topic:join"

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      id = session["user_id"]

      if id do
        IO.puts("Got existing ID: #{id}")

        {:ok, _} =
          Presence.track(self(), @presence, id, %{
            name: "User #{id}",
            joined_at: :os.system_time(:seconds)
          })
      end

      Phoenix.PubSub.subscribe(PubSub, @presence)
      FeelisWeb.Endpoint.subscribe(@page_turn_topic)
      FeelisWeb.Endpoint.subscribe(@join_topic)
    end

    {:ok, socket |> assign(:users, %{}) |> handle_joins(Presence.list(@presence))}
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
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    {:noreply, socket |> handle_leaves(diff.leaves) |> handle_joins(diff.joins)}
  end

  @impl true
  def handle_info(%{topic: @join_topic, payload: state}, socket) do
    # Send current state to the requester
    GenServer.cast(state.pid, {:sync, socket.assigns.current_slide})
    {:noreply, socket}
  end

  @impl true
  def handle_event("new-user-id", %{"id" => id}, socket) do
    IO.puts("Got new ID: #{id}")

    {:ok, _} =
      Presence.track(self(), @presence, id, %{
        name: "User #{id}",
        joined_at: :os.system_time(:seconds)
      })

    {:noreply, socket}
  end

  @impl true
  def handle_event("next_slide", _params, socket) do
    next_index = socket.assigns.current_index + 1

    if Enum.count(socket.assigns.presentation.slides) > next_index do
      next_slide = Enum.at(socket.assigns.presentation.slides, next_index)

      # Broadcasts the event to ALL OTHER SUBSCRIBERS THAN THE ONE THAT SENDS IT
      FeelisWeb.Endpoint.broadcast_from(self(), @page_turn_topic, "set_slide", %{
        current_slide: next_slide
      })

      {:noreply,
       socket |> assign(:current_index, next_index) |> assign(:current_slide, next_slide)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("previous_slide", _params, socket) do
    next_index = socket.assigns.current_index - 1

    if next_index >= 0 do
      next_slide = Enum.at(socket.assigns.presentation.slides, next_index)

      # Broadcasts the event to ALL OTHER SUBSCRIBERS THAN THE ONE THAT SENDS IT
      FeelisWeb.Endpoint.broadcast_from(self(), @page_turn_topic, "set_slide", %{
        current_slide: next_slide
      })

      {:noreply,
       socket |> assign(:current_index, next_index) |> assign(:current_slide, next_slide)}
    else
      {:noreply, socket}
    end
  end

  defp handle_joins(socket, joins) do
    Enum.reduce(joins, socket, fn {user, %{metas: [meta | _]}}, socket ->
      assign(socket, :users, Map.put(socket.assigns.users, user, meta))
    end)
  end

  defp handle_leaves(socket, leaves) do
    Enum.reduce(leaves, socket, fn {user, _}, socket ->
      assign(socket, :users, Map.delete(socket.assigns.users, user))
    end)
  end
end

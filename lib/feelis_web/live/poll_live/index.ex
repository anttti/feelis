defmodule FeelisWeb.PollLive.Index do
  use FeelisWeb, :live_view

  alias Feelis.Presence
  alias Feelis.PubSub

  @presence "poll:presence"

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      id = session["user_id"]

      if id do
        IO.puts("Got existing ID: #{id}")

        {:ok, _} =
          Presence.track(self(), @presence, id, %{
            name: "Test #{id}",
            joined_at: :os.system_time(:seconds)
          })
      end

      Phoenix.PubSub.subscribe(PubSub, @presence)
    end

    {:ok, socket |> assign(:users, %{}) |> handle_joins(Presence.list(@presence))}
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    {
      :noreply,
      socket
      |> handle_leaves(diff.leaves)
      |> handle_joins(diff.joins)
    }
  end

  @impl true
  def handle_event("new-user-id", %{"id" => id}, socket) do
    IO.puts("Got new ID: #{id}")

    {:ok, _} =
      Presence.track(self(), @presence, id, %{
        name: "Test #{id}",
        joined_at: :os.system_time(:seconds)
      })

    {:noreply, socket}
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

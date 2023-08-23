defmodule FeelisWeb.ViewerLive.Index do
  use FeelisWeb, :live_view

  alias Feelis.Presentations
  alias Feelis.Presentations.Answer

  @page_turn_topic "topic:page_turn"
  @join_topic "topic:join"
  @answers_topic "topic:answers"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      FeelisWeb.Endpoint.subscribe(@page_turn_topic)

      # publish a message "I've joined, what's up? to get the current slide"
      FeelisWeb.Endpoint.broadcast_from(self(), @join_topic, "join", %{pid: self()})
    end

    changeset = Presentations.change_answer(%Answer{})

    {:ok, socket |> assign(:answer, %Answer{}) |> assign_form(changeset)}
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

  @impl true
  def handle_event("validate", %{"answer" => answer_params}, socket) do
    changeset =
      socket.assigns.answer
      |> Presentations.change_answer(answer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"answer" => answer_params}, socket) do
    case Presentations.create_answer(answer_params) do
      {:ok, answer} ->
        FeelisWeb.Endpoint.broadcast_from(self(), @answers_topic, "answer", %{answer: answer})

        {:noreply,
         socket
         |> put_flash(:info, "Answer created successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end

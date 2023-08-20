defmodule FeelisWeb.PresentationLive.FormComponent do
  use FeelisWeb, :live_component

  alias Feelis.Presentations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage presentation records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="presentation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Presentation</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{presentation: presentation} = assigns, socket) do
    changeset = Presentations.change_presentation(presentation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"presentation" => presentation_params}, socket) do
    changeset =
      socket.assigns.presentation
      |> Presentations.change_presentation(presentation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"presentation" => presentation_params}, socket) do
    save_presentation(socket, socket.assigns.action, presentation_params)
  end

  defp save_presentation(socket, :edit, presentation_params) do
    case Presentations.update_presentation(socket.assigns.presentation, presentation_params) do
      {:ok, presentation} ->
        notify_parent({:saved, presentation})

        {:noreply,
         socket
         |> put_flash(:info, "Presentation updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_presentation(socket, :new, presentation_params) do
    case Presentations.create_presentation(presentation_params) do
      {:ok, presentation} ->
        notify_parent({:saved, presentation})

        {:noreply,
         socket
         |> put_flash(:info, "Presentation created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

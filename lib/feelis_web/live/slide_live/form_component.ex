defmodule FeelisWeb.SlideLive.FormComponent do
  use FeelisWeb, :live_component

  alias Feelis.Presentations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage slide records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="slide-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Slide</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{slide: slide} = assigns, socket) do
    changeset = Presentations.change_slide(slide)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"slide" => slide_params}, socket) do
    changeset =
      socket.assigns.slide
      |> Presentations.change_slide(slide_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"slide" => slide_params}, socket) do
    save_slide(socket, socket.assigns.action, slide_params)
  end

  defp save_slide(socket, :edit, slide_params) do
    case Presentations.update_slide(socket.assigns.slide, slide_params) do
      {:ok, slide} ->
        notify_parent({:saved, slide})

        {:noreply,
         socket
         |> put_flash(:info, "Slide updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_slide(socket, :new, slide_params) do
    case Presentations.create_slide(slide_params) do
      {:ok, slide} ->
        notify_parent({:saved, slide})

        {:noreply,
         socket
         |> put_flash(:info, "Slide created successfully")
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

defmodule ConwayPhx.PageLive do
  use ConwayPhx, :live_view

  alias ConwayPhx.UserWorld
  alias Conway.DynamicWorlds

  @impl true
  def mount(_params, _session, socket) do
    changeset = UserWorld.changeset(%{})
    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"user_world" => params}, socket) do
    changeset =
      UserWorld.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("view_world", %{"user_world" =>  params = %{"world_name" => name, "world_size" => size}}, socket) do
    case DynamicWorlds.create_world(String.to_atom(name), String.to_integer(size)) do
      {:ok, _} ->
        {:noreply,
          socket
          |> put_flash(:info, "World Created")
          |> redirect(to: Routes.world_path(socket, :index, name))}
      {:error, message} ->
        changeset =
          UserWorld.changeset(params)
          |> Map.put(:action, :insert)

        socket =
          socket
          |> assign(:changeset, changeset)
          |> put_flash(:error, message)

        {:noreply, socket}
    end

  end

end

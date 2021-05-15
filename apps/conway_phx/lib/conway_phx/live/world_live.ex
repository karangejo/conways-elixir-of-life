defmodule ConwayPhx.WorldLive do
  use ConwayPhx, :live_view

  alias Conway.DynamicWorlds
  alias Conway.World

  @impl true
  def mount(%{"world_name" => world_name}, _session, socket) do
    name = String.to_atom(world_name)
    world = %World{size: world_size} = DynamicWorlds.view_world(name)
    {:ok,
      socket
      |> assign(:playing, false)
      |> assign(:update_interval, 1000)
      |> assign(:alive_color, "white")
      |> assign(:dead_color, "black")
      |> assign(:name, name)
      |> assign(:world, world)
      |> assign(:size, world_size)}
  end

  @impl true
  def handle_event("toggle_cell", %{"x" => x, "y" => y, "state" => state}, socket) do
    new_state =
      if state == "alive" do
        :dead
      else
        :alive
      end

    new_world = DynamicWorlds.change_world(socket.assigns.name, new_state, String.to_integer(x), String.to_integer(y))
    IO.inspect(new_world)
    {:noreply,
      socket
      |> assign(:world, new_world)}
  end

  @impl true
  def handle_event("play", _params, socket) do
    schedule_update(socket.assigns.update_interval)
    {:noreply,
      socket
      |> assign(:playing, true)}
  end

  @impl true
  def handle_event("pause", _params, socket) do
    {:noreply,
      socket
      |> assign(:playing, false)}
  end

  @impl true
  def handle_event("change_alive_color", %{"alive_color" => %{"color_input" => choosen_color}}, socket) do
    {:noreply,
      socket
      |> assign(:alive_color, choosen_color)}
  end

  @impl true
  def handle_event("change_dead_color", %{"dead_color" => %{"color_input" => choosen_color}}, socket) do
    {:noreply,
      socket
      |> assign(:dead_color, choosen_color)}
  end

  @impl true
  def handle_info(:transition, socket) do
    if socket.assigns.playing == true do
      schedule_update(socket.assigns.update_interval)
      world = DynamicWorlds.transition_world(socket.assigns.name)
      {:noreply,
        socket
        |> assign(world: world)}
    else
      {:noreply, socket}
    end
  end

  def schedule_update(interval), do: self() |> Process.send_after(:transition, interval)

end

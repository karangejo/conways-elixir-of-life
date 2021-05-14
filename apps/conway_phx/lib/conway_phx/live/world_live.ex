defmodule ConwayPhx.WorldLive do
  use ConwayPhx, :live_view

  alias Conway.DynamicWorlds
  alias Conway.World

  @impl true
  def mount(%{"world_name" => world_name}, _session, socket) do
    schedule_update(1000)
    name = String.to_atom(world_name)
    world = %World{size: world_size} = DynamicWorlds.view_world(name)
    {:ok,
      socket
      |> assign(:update_interval, 1000)
      |> assign(:name, name)
      |> assign(:world, world)
      |> assign(:size, world_size)}
  end

  @impl true
  def handle_info(:transition, socket) do
    schedule_update(socket.assigns.update_interval)
    world = DynamicWorlds.transition_world(socket.assigns.name)

    {:noreply,
      socket
      |> assign(world: world)}
  end

  def schedule_update(interval), do: self() |> Process.send_after(:transition, interval)

end

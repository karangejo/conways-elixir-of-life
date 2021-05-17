defmodule Conway.WorldServer do
  use GenServer, restart: :transient

  alias Conway.World


  # Client

  def start_link(%{name: name, size: size}) do
    GenServer.start_link(__MODULE__, size, name: name)
  end

  def stop(name, reason \\ :normal, timeout \\ :infinity) do
    GenServer.stop(name, reason, timeout)
  end

  def transition_world(name) do
    GenServer.call(name, {:transition_world})
  end

  def view_world(name) do
    GenServer.call(name, {:view_world})
  end

  def reset_world(name) do
    GenServer.call(name, {:reset_world})
  end

  def change_world(name, state, x, y) do
    GenServer.call(name, {:change_world, state, x, y})
  end


  # Server (callbacks)

  @impl true
  def init(size) do
    random_world = Conway.make_world(size)
    {:ok, random_world}
  end


  @impl true
  def handle_call({:transition_world}, _from, current_world = %World{}) do
    next_world = Conway.transition_world(current_world)
    {:reply, next_world, next_world}
  end

  @impl true
  def handle_call({:view_world}, _from, current_world = %World{}) do
    {:reply, current_world, current_world}
  end

  @impl true
  def handle_call({:reset_world}, _from, %World{size: size}) do
    reset_world = Conway.make_world(size)
    {:reply, reset_world, reset_world}
  end

  @impl true
  def handle_call({:change_world, state, x, y}, _from, current_world = %World{}) do
    case Conway.change_elem_at(current_world, state, x, y) do
      {:ok, next_world} ->
        {:reply, next_world, next_world}
      {:error, old_world} ->
        {:reply, old_world, old_world}
    end
  end

  @impl true
  def terminate(_reason, state) do
    IO.puts("terminating")
    state
  end

end

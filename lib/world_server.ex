defmodule Conway.WorldServer do
  use GenServer

  alias Conway.World


  # Client

  def start_link(%{name: name, size: size}) do
    GenServer.start_link(__MODULE__, size, name: name)
  end


  def transition_world(name) do
    GenServer.call(name, {:transition_world})
  end

  def view_world(name) do
    GenServer.call(name, {:view_world})
  end

  def kill_world(name) do
    GenServer.call(name, {:kill_world})
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
  def handle_call({:kill_world}, _from, state) do
    {:stop, :normal, state}
  end

end

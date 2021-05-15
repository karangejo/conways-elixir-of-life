defmodule Conway.DynamicWorlds do
  alias Conway.WorldServer

  def create_world(name, size) when is_integer(size) do
    case DynamicSupervisor.start_child(Conway.WorldSupervisor,
      {WorldServer,%{name: name, size: size}}) do
        {:ok, _pid} ->
          {:ok, %{name: name, size: size}}
        {:error, _} ->
          {:error, "could not create world"}
    end
  end

  defdelegate transition_world(name), to: WorldServer

  defdelegate view_world(name), to: WorldServer

  defdelegate stop(name), to: WorldServer

  defdelegate change_world(name, state, x, y), to: WorldServer

end

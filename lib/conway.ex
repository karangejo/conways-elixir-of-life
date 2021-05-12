defmodule Conway do
  @moduledoc """
  Documentation for `Conway`.
  """

  alias Conway.World

  def make_world(size) do
    world =
      Enum.map(1..size, fn _ ->
        Enum.map(1..size, fn _ ->
          Enum.random([:alive, :dead])
        end)
        |> List.to_tuple()
      end)
      |> List.to_tuple()
    %World{world: world, size: size}
  end

  def transition_world(world) do
    flat_world =
      for x <- 0..(world.size - 1), y <- 0..(world.size - 1) do
        transition_state_at(world, x, y)
      end

    transitioned_world =
      Enum.reduce(1..world.size, %{flat: flat_world, next_world: {}}, fn _, acc ->
        {head, tail} = Enum.split(acc.flat, world.size)
        %{flat: tail, next_world: Tuple.append(acc.next_world, List.to_tuple(head))}
      end)
    %World{world: transitioned_world.next_world, size: world.size}
  end

  def transition_state_at(world, x, y) do
    cell_state = get_elem_at(world, x, y)

    get_neighbor_indexes(x, y)
    |> cross_world(world)
    |> apply_rules_of_life(world, cell_state)

  end

  def apply_rules_of_life(list_of_coords, world, cell_state) do
    neighbors_count =
      list_of_coords
      |> alive_count(world)
    case neighbors_count do
      count when count < 2 and cell_state == :alive -> :dead
      count when count == 2 or count == 3 and cell_state == :alive -> :alive
      count when count > 3 and cell_state == :alive -> :dead
      count when count == 3 and cell_state == :dead -> :alive
      _ -> cell_state
    end
  end

  def alive_count(list_of_coords, world) do
    Enum.reduce(list_of_coords, 0, fn coords, acc ->
      if get_elem_at(world, coords.x, coords.y) == :alive do
        acc + 1
      else
        acc
      end
    end)
  end

  def cross_world(list_of_coords, world) do
    Enum.map(list_of_coords, fn neighbor ->
      maybe_cross_world(world, neighbor.x, neighbor.y)
    end)
  end

  # northwest to southeast
  def maybe_cross_world(world = %World{}, x, y) when x < 0 and y < 0 do
   %{x: world.size - 1 , y: world.size - 1}
  end
  # southeast to northwest
  def maybe_cross_world(world = %World{}, x, y) when x >= world.size and y >= world.size do
    %{x: 0, y: 0}
  end
  # southhwest to northeast
  def maybe_cross_world(world = %World{}, x, y) when x < 0 and y >= world.size do
    %{x: world.size - 1, y: 0}
  end
  # northeast to southwest
  def maybe_cross_world(world = %World{}, x, y) when x >= world.size and y < 0 do
    %{x: 0, y: world.size - 1}
  end
  # north to south
  def maybe_cross_world(world = %World{}, x, y) when y < 0 do
    %{x: x, y: world.size - 1}
  end
  # east to west
  def maybe_cross_world(world = %World{}, x, y) when x < 0 do
    %{x: world.size - 1, y: y}
  end
  # west to east
  def maybe_cross_world(world = %World{}, x, y) when x >= world.size do
    %{x: 0, y: y}
  end
  # south to north
  def maybe_cross_world(world = %World{}, x, y) when y >= world.size do
    %{x: x, y: 0}
  end
  # valid so do nothing
  def maybe_cross_world(_world = %World{}, x, y), do: %{x: x, y: y}


  def get_neighbor_indexes(x, y) do
    for g <- x-1..x+1, h <- y-1..y+1, not(h == y and g == x), do: %{x: g, y: h}
  end

  def get_elem_at(world = %World{}, x, y) do
    case valid_indexes(world.size, x, y) do
      true ->
        elem(world.world, x)
        |> elem(y)
      false ->
        nil
    end
  end

  def valid_indexes(size, x, y) do
    not(x >= size or x < 0 or y >= size or y < 0)
  end
end

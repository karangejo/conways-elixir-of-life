defmodule ConwayPhx.UserWorld do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :world_name, :string
    field :world_size, :integer
  end

  def changeset(user_world_params) do
    %__MODULE__{}
    |> cast(user_world_params, [:world_size, :world_name])
    |> validate_required([:world_size, :world_name])
    |> validate_number(:world_size, greater_than: 0, less_than: 100)
    |> validate_length(:world_name, min: 2, max: 20)
  end
end

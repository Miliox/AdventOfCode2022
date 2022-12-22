defmodule Utils do
    def find_start(open_tiles) do
        find_start(open_tiles, 0)
    end

    defp find_start(open_tiles, x) do
        case MapSet.member?(open_tiles, {x, 0}) do
            true  -> {x, 0}
            false -> find_start(open_tiles, x + 1)
        end
    end

    def traverse({x, y}, {dx, dy}, [], _, _) do
        {{x, y}, {dx, dy}}
    end
    def traverse({x, y}, {dx, dy}, [:left | directions], open_tiles, wall_tiles) do
        traverse({x, y}, {dy, -dx}, directions, open_tiles, wall_tiles)
    end
    def traverse({x, y}, {dx, dy}, [:right | directions], open_tiles, wall_tiles) do
        traverse({x, y}, {-dy, dx}, directions, open_tiles, wall_tiles)
    end
    def traverse({x, y}, {dx, dy}, [0 | directions], open_tiles, wall_tiles) do
        traverse({x, y}, {dx, dy}, directions, open_tiles, wall_tiles)
    end
    def traverse({x0, y0}, {dx, dy}, [steps | directions], open_tiles, wall_tiles) when steps > 0 do
        {x1, y1} = {x0 + dx, y0 + dy}

        cond do
            MapSet.member?(open_tiles, {x1, y1}) ->
                traverse({x1, y1}, {dx, dy}, [steps - 1 | directions], open_tiles, wall_tiles)
            MapSet.member?(wall_tiles, {x1, y1}) ->
                traverse({x0, y0}, {dx, dy}, directions, open_tiles, wall_tiles)
            true ->
                case wrap({x0, y0}, {dx, dy}, open_tiles, wall_tiles) do
                    {:open, {x2, y2}} ->
                        traverse({x2, y2}, {dx, dy}, [steps - 1 | directions], open_tiles, wall_tiles)
                    {:wall, _} ->
                        traverse({x0, y0}, {dx, dy}, directions, open_tiles, wall_tiles)
                end
        end
    end

    def wrap({x0, y0}, {dx, dy}, open_tiles, wall_tiles) do
        {x1, y1} = {x0 - dx, y0 - dy}
        cond do
            MapSet.member?(open_tiles, {x1, y1}) ->
                wrap({x1, y1}, {dx, dy}, open_tiles, wall_tiles)
            MapSet.member?(wall_tiles, {x1, y1}) ->
                wrap({x1, y1}, {dx, dy}, open_tiles, wall_tiles)
            true ->
                cond do
                    MapSet.member?(open_tiles, {x0, y0}) -> {:open, {x0, y0}}
                    MapSet.member?(wall_tiles, {x0, y0}) -> {:wall, {x0, y0}}
                end
        end
    end
end
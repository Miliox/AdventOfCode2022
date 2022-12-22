defmodule Parser do
    def parse(input) do
        {:ok, open_tiles, wall_tiles, [dirs]} = parse_map(input, [], [], 0)
        dirs = parse_dirs( dirs)
        {open_tiles, wall_tiles, dirs}
    end

    defp parse_map([[]  |input], all_open_tiles, all_wall_tiles, _), do: {:ok, MapSet.new(all_open_tiles), MapSet.new(all_wall_tiles), input}
    defp parse_map([line|input], all_open_tiles, all_wall_tiles, y) do
        {open_tiles, wall_tiles} =
            Enum.reduce(Enum.with_index(line), {[], []}, fn
            {?.,  x}, {open_tiles, wall_tiles} -> {[{x, y} | open_tiles], wall_tiles}
            {?#,  x}, {open_tiles, wall_tiles} -> {open_tiles, [{x, y} | wall_tiles]}
            {?\s, _}, tiles -> tiles
        end)

        parse_map(input, open_tiles ++ all_open_tiles, wall_tiles ++ all_wall_tiles, y + 1)
    end

    defp parse_dirs(line) when is_list(line) do
        parse_dirs(to_string(line))
    end
    defp parse_dirs(line) when is_binary(line) do
        {:ok, regex} = Regex.compile("(\\d+)|([L|R])")
        matches = Regex.scan(regex, line)
        Enum.map(matches, fn
            [_, "", "R"] -> :right
            [_, "", "L"] -> :left
            [_, steps] -> String.to_integer(steps)
        end)
    end
end
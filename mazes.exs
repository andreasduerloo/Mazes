######################
# Depth-first search #
######################

defmodule Maze.DFS do
  # Creation

  def create(dimension) do
    maze = for x <- 0..dimension - 1, y <- 0..dimension - 1, into: %{}, do: {{x, y}, false}
    origin = Map.keys(maze) |> Enum.random()
    maze = %{maze | origin => "Origin"}
    create(origin, maze)
  end

  defp create(point, maze) do
    neighbors = neighbors?(point, maze)
    if neighbors do
      next = Enum.random(neighbors)
      maze = %{maze | next => point}
      create(next, maze)
    else
      if maze[point] == "Origin" do # We're back at the start and there are no unvisited neighbors -> we're done!
        maze
      else # Step back to the previous point and continue from there
        create(maze[point], maze)
      end
    end
  end

  # Creation - helpers

  defp neighbors?({x, y}, maze) do # Return false if there are no unvisited neighbors, else return list of visitable neighbors
    unvisited = [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}] |> Enum.filter(&(maze[&1] != nil && !maze[&1]))
    if unvisited == [] do
      false
    else
      unvisited
    end
    # Enum.reduce(true, fn val, acc -> maze[val] && acc end)
  end

  # Drawing

  def draw(maze) when is_map(maze) do
    dimension = Map.keys(maze) |> length() |> :math.sqrt() |> trunc()
    canvas = List.duplicate(List.duplicate("##", 2 * dimension + 1), 2* dimension + 1)

    canvas = Map.keys(maze) |> draw_lines(canvas, maze)

    canvas |> Enum.map(&(&1 ++ ["\n"])) |> List.to_string() |> IO.puts()
  end

  # Drawing - helpers

  defp draw_line({x1, y1}, {x2, y2}, canvas) do
    cond do
      x1 == x2 -> # Horizontal
        line = canvas |> Enum.fetch!(2 * x1 + 1) |> List.replace_at(2 * y1 + 1, "  ") |> List.replace_at(2 * y2 + 1, "  ") |> List.replace_at(y1 + y2 + 1, "  ")
        List.replace_at(canvas, 2 * x1 + 1, line)
      y1 == y2 -> # Vertical
        line = canvas |> Enum.fetch!(2 * x1 + 1) |> List.replace_at(2 * y1 + 1, "  ")
        canvas = List.replace_at(canvas, 2 * x1 + 1, line)
        line = canvas |> Enum.fetch!(2 * x2 + 1) |> List.replace_at(2 * y1 + 1, "  ")
        canvas = List.replace_at(canvas, 2 * x2 + 1, line)
        line = canvas |> Enum.fetch!(x1 + x2 + 1) |> List.replace_at(2 * y1 + 1, "  ")
        List.replace_at(canvas, x1 + x2 + 1, line)
    end
  end

  defp draw_line({x1, y1}, _string, canvas) do
    line = canvas |> Enum.fetch!(2 * x1 + 1) |> List.replace_at(2 * y1 + 1, "  ")
    List.replace_at(canvas, 2 * x1 + 1, line)
  end

  defp draw_lines([], canvas, _maze), do: canvas

  defp draw_lines([head | tail], canvas, maze) do
    draw_lines(tail, draw_line(head, maze[head], canvas), maze)
  end
end

##################################
# Randomized Kruskal's Algorithm #
##################################

defmodule Maze.Kruskal do
  # Creation

  def create(dimension) do
    maze = for x <- 0..dimension - 1, y <- 0..dimension - 1, into: %{}, do: {{x, y}, false}
    create(maze, walls(maze, dimension), [], 0)
  end

  defp create(_maze, [], kept, _set_val), do: kept

  defp create(maze, wall_list, kept, set_val) do
    [a, b] = Enum.random(wall_list)

    if maze[a] == maze[b] && maze[a] do # These cells are in the same sector (and it isn't false)
      create(maze, wall_list -- [[a, b]], [[a, b] | kept], set_val) # We keep that wall and move on
    else
      maze = merge(maze, a, b, set_val) # We merge the sets
      create(maze, wall_list -- [[a, b]], kept, set_val + 1) # We don't keep that wall
    end
  end

  # Creation - helpers

  defp walls(maze, dimension) do # Build a list of walls. A wall is defined by two neighboring points.
    cells = Map.keys(maze)
    walls([], cells, dimension)
  end

  defp walls(wall_list, [], dimension) do
    wall_list
    |> Enum.map(&(Enum.sort(&1)))
    |> Enum.uniq
    |> Enum.filter(fn([{a, b}, {x, y}]) -> Enum.min([a, b, x, y]) >= 0 && Enum.max([a, b, x, y]) < dimension end)
  end

  defp walls(wall_list, [{x, y} | cells], dimension) do
    wall_list = [[{x, y}, {x - 1, y}] | wall_list]
    wall_list = [[{x, y}, {x + 1, y}] | wall_list]
    wall_list = [[{x, y}, {x, y - 1}] | wall_list]
    wall_list = [[{x, y}, {x, y + 1}] | wall_list]

    walls(wall_list, cells, dimension)
  end

  defp merge(maze, a, b, num) do
    cond do
      !maze[a] && !maze[b] -> # Neither cell belongs to a set yet
        maze = %{ maze | a => num }
        %{ maze | b => num }
      !maze[a] && maze[b] -> # One cell belongs to a set, the other one doesn't - yet
        %{ maze | a => maze[b] }
      maze[a] && !maze[b] -> # One cell belongs to a set, the other one doesn't - yet
        %{ maze | b => maze[a] }
      maze[a] && maze[b] -> # Both cells already belong to a set, point both to a new set 'num'
        join_sets(maze, maze[a], maze[b], num, Map.keys(maze))
    end
  end

  defp join_sets(maze, _a, _b, _new, []), do: maze

  defp join_sets(maze, a, b, new, [head | keys]) do
    if maze[head] == a || maze[head] == b do
      maze = %{ maze | head => new }
      join_sets(maze, a, b, new, keys)
    else
      join_sets(maze, a, b, new, keys)
    end
  end

  # Drawing

  def draw(walls, dimension) do
    canvas = [List.duplicate("##", 2 * dimension + 1)] ++ draw_nodes(dimension) ++ [List.duplicate("##", 2 * dimension + 1)]
    |> draw_walls(walls)
    |> Enum.map(&(&1 ++ ["\n"]))
    |> List.to_string()
    |> IO.puts()
  end

  # Drawing - helpers

  defp draw_nodes(dimension) do # Top line with nodes
    line = ["##"] ++ [List.duplicate(["  "], dimension * 2 - 1)] ++ ["##"]
    draw_nodes([line], dimension)
  end

  defp draw_nodes(lines, dimension) do
    if Enum.count(lines) == (2 * dimension - 1) do
      lines
    else
      line1 = List.duplicate(["##", "  "], dimension) ++ ["##"] |> List.flatten
      line2 = ["##"] ++ List.duplicate("  ", 2 * dimension - 1) ++ ["##"]
      newlines = [ line1, line2 ]

      draw_nodes(lines ++ newlines, dimension)
    end
  end

  defp draw_walls(canvas, []) do
    canvas
  end

  defp draw_walls(canvas, [[{x1, y1}, {x2, y2}] | walls]) do
    cond do
      x1 == x2 -> # Vertical wall
        line = canvas |> Enum.fetch!(2 * x1 + 1) |> List.replace_at(y1 + y2 + 1, "##")
        canvas = List.replace_at(canvas, 2 * x1 + 1, line)
        draw_walls(canvas, walls)
      y1 == y2 -> # Horizontal wall
        line = canvas |> Enum.fetch!(x1 + x2 + 1) |> List.replace_at(2 * y1 + 1, "##")
        canvas = List.replace_at(canvas, x1 + x2 + 1, line)
        draw_walls(canvas, walls)
    end
  end
end

IO.puts("Depth-first search:\n")
Maze.DFS.create(20) |> Maze.DFS.draw()

IO.puts("\nRandomized Kruskal:\n")
Maze.Kruskal.create(20) |> Maze.Kruskal.draw(20)

defmodule Maze.Create do
  def dfs(dimension) do
    maze = for x <- 0..dimension - 1, y <- 0..dimension - 1, into: %{}, do: {{x, y}, false}
    origin = Map.keys(maze) |> Enum.random()
    maze = %{maze | origin => "Origin"}
    dfs(origin, maze, origin)
  end

  defp dfs(point, maze, origin) do
    neighbors = neighbors?(point, maze)
    if neighbors do
      next = Enum.random(neighbors)
      maze = %{maze | next => point}
      dfs(next, maze, origin)
    else
      if point == origin do # We're back at the start and there are no unvisited neighbors -> we're done!
        maze
      else # Step back to the previous point and continue from there
        dfs(maze[point], maze, origin)
      end
    end
  end

  defp neighbors?({x, y}, maze) do # Return false if there are no unvisited neighbors, else return list of visitable neighbors
    unvisited = [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}] |> Enum.filter(&( maze[&1] != nil && !maze[&1]))
    if unvisited == [] do
      false
    else
      unvisited
    end
    # Enum.reduce(true, fn val, acc -> maze[val] && acc end)
  end
end

defmodule Maze.Draw do
  def draw(maze) when is_map(maze) do
    dimension = Map.keys(maze) |> length() |> :math.sqrt() |> trunc()
    canvas = List.duplicate(List.duplicate("##", 2 * dimension + 1), 2* dimension + 1)

    canvas = Map.keys(maze) |> draw_lines(canvas, maze)

    canvas |> Enum.map(&(&1 ++ ["\n"])) |> List.to_string() |> IO.puts()
  end

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

Maze.Create.dfs(20) |> Maze.Draw.draw()

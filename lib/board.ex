defmodule Chess.Board.Setup do
  @moduledoc """
    The part where this program spawns a nested list in the format of this:
    [[:piecename, :piececolor, 2, 2]]
  """

  def init() do
    list = spawn_pawn(:white, 2)
    list = list ++ spawn_pawn(:black, 7)
    list = list ++ spawn_bishop(:white, 1)
    list = list ++ spawn_bishop(:black, 8)
    list = list ++ spawn_knight(:white, 1)
    list = list ++ spawn_knight(:black, 8)
    list = list ++ spawn_rook(:white, 1)
    list = list ++ spawn_rook(:black, 8)
    list = list ++ spawn_royal(:white, 1)
    list = list ++ spawn_royal(:black, 8)
    list = Chess.Board.Render.reorder(list)
    list
  end

  def spawn_pawn(color, side, times \\ 8, acc \\ [])
  def spawn_pawn(_, _, 0, acc), do: acc

  def spawn_pawn(color, side, times, acc) do
    spawn_pawn(color, side, times - 1, acc ++ [[:pawn, color, times, side]])
  end

  def spawn_bishop(color, row) do
    list = []
    list = list ++ [[:bishop, color, 3, row]]
    list = list ++ [[:bishop, color, 6, row]]
    list
  end

  def spawn_knight(color, row) do
    list = []
    list = list ++ [[:knight, color, 2, row]]
    list = list ++ [[:knight, color, 7, row]]
    list
  end

  def spawn_rook(color, row) do
    list = []
    list = list ++ [[:rook, color, 1, row]]
    list = list ++ [[:rook, color, 8, row]]
    list
  end

  def spawn_royal(color, row) do
    list = []
    list = list ++ [[:queen, color, 4, row]]
    list = list ++ [[:king, color, 5, row]]
    list
  end
end

defmodule Chess.Board.Render do
  @moduledoc """
    contains all the junk code to perhaps stack overflow your system
    renders the chess board
  """

  @doc """
    this code is literally dumpster fire
  """
  @type render() :: :ok
  # init function
  def render(board, x \\ 1, y \\ 1, hint \\ 8)

  # case for the last piece
  def render(board, 8, 8, _) do
    target = search(board, 8, 8)
    print_piece(target)
    IO.write("\n")
    IO.write("  12345678")
    IO.write("\n")
    :ok
  end

  # case for the end of the row
  def render(board, 8, y, hint) do
    target = search(board, 8, y)
    print_piece(target)
    IO.write("\n")
    coordinates = hint - 1
    IO.write("#{coordinates} ")
    render(board, 1, y + 1, hint - 1)
  end

  # first time?
  def render(board, 1, 1, hint) do
    IO.write("8 ")
    target = search(board, 1, 1)
    print_piece(target)
    render(board, 2, 1, hint)
  end

  # case for any other cases
  def render(board, x, y, hint) do
    target = search(board, x, y)
    print_piece(target)
    render(board, x + 1, y, hint)
  end

  def print_piece(target) do
    case Enum.empty?(target) do
      true ->
        IO.write("#{IO.ANSI.magenta()}E#{IO.ANSI.reset()}")

      false ->
        [[atom, color, _, _]] = target

        output =
          atom
          |> first()
          |> String.upcase()

        case color do
          :white -> IO.write("#{IO.ANSI.green()}#{output}#{IO.ANSI.reset()}")
          :black -> IO.write("#{IO.ANSI.blue()}#{output}#{IO.ANSI.reset()}")
        end
    end
  end

  # perhaps this is useless?
  def search(board, x, y) do
    Enum.filter(board, fn [_, _, a, b] -> [a, b] == [x, y] end)
  end

  def first(atom) do
    atom
    |> Atom.to_string()
    |> String.at(0)
  end

  def reorder(board) do
    Enum.sort_by(board, fn [_, _, a, b] -> [b, a] end)
  end
end

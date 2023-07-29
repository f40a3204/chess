defmodule Chess.Player do
  @moduledoc """
    prompt the user to enter a move
  """
  def prompt_move(board) do
    move = IO.gets("select a piece (x y) >>")
    [target_x, target_y] = String.split(move, " ")
    # TODO deal with this stuff tmr
    {:ok, vmove} = validate_move(board, target_x, target_y)

    destination = IO.gets("move the piece (x, y) >>")

  end

  def validate_move(board, x, y) do
    selection = Enum.filter(board, fn [_, _, ox, oy] -> [ox, oy] == [x, y] end)
    case Enum.empty?(selection) do
      true -> {:ok, board}
      false -> {:error, "invalid move"}
    end
  end
end

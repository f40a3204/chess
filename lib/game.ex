defmodule Chess.Game do
  def start(_types, _args) do
    {:ok, self()}
  end
end

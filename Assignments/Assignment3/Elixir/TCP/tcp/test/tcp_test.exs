defmodule TcpTest do
  use ExUnit.Case
  doctest Tcp

  test "greets the world" do
    assert Tcp.hello() == :world
  end
end

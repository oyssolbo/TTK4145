# This module is hardcoded from https://elixir-lang.org/getting-started/mix-otp/task-and-gen-tcp.html
# Used to familarize with TCP in elixir

defmodule TCPServer do
  @moduledoc """
  The module TCPServer sets up a TCP-server used by
  other processes to communicate over
  """

  require Logger
  use GenServer


  # The options below mean:

  # `:binary` - receives data as binaries (instead of lists)
  # `packet: :line` - receives data line by line
  # `active: false` - blocks on `:gen_tcp.recv/2` until data is available
  # `reuseaddr: true` - allows us to reuse the address if the listener crashes

  # Init function to prevent the compiler from crapping itself
  def init(arg) do
    { :ok, arg }
  end

  # Accepts a connection on @p port
  # Checks if the port is already in use
  def accept(port) do
    { :port_state, socket } = :gen_tcp.listen(port,
            [:binary, packet: :line, active: false, reuseaddr: true])
    if :port_state == :ok do
      Logger.info("Accepting connections on port #{port}")
      loop_acceptor(socket)
    else
      Logger.info("There is already a connection on port #{port}")
      loop_acceptor(socket)
    end
  end

  # Continously accept the connection
  defp loop_acceptor(socket) do
    { :ok, client } = :gen_tcp.accept(socket)
    { :ok, pid } = Task.Supervisor.start_child(TCPServer.TaskSupervisor,
            fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  # Read data from the connection and send back
  defp serve(socket) do
    socket |> read_line() |> write_line(socket)
    serve(socket)
  end

  # Read a line from the connection
  defp read_line(socket) do
    { :ok, data } = :gen_tcp.recv(socket, 0)
    data
  end

  # Write a line to the connection
  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end


def start() do
  port = String.to_integer(System.get_env("PORT") || "2020")

  children = [{ Task.Supervisor, fn -> TCPServer.TaskSupervisor,
        Supervisor.child_spec(Task, fn -> TCPServer.accept(port) end },
        restart: :permanent)]
  opts = [stragegy: :one_for_one, name: TCPServer.Supervisor]

  Supervisor.start_link((children, opts))
end

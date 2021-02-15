defmodule Server do
  @default_server_port 1337
  @default_timeout 500
  @default_packet_size 1024
  @local_host {127,0,0,1}

  def initialize_server(number_connections, port) do
    case :gen_tcp.listen(port, [active: false, packet_size: @default_packet_size]) do
        {:ok, listen_socket} ->
            start_servers(number_connections, listen_socket)
            {ok, Port} = :inet.port(listen_socket)
            Port
        {:error, reason} ->
            {:error, reason}
    end
  end

  defp start_servers(0,_) do
      :ok
  end

  defp start_servers(number_connections, listen_socket) do
      spawn(fn -> server([listen_socket]) end)
      start_servers(number_connections - 1, listen_socket)
  end

  defp server(listen_socket) do
    case :gen_tcp.accept(listen_socket) do
        {:ok, socket} ->
            listen_socket(socket)
            server(listen_socket)
        other ->
            IO.puts("accept returned ~w - goodbye!~n")
            :ok
    end
  end

  defp listen_socket(socket) do
      :inet.setopts(socket, [active: :once])
      receive do
          {tcp, socket, data} ->
              answer = process(data)
              :gen_tcp.send(socket, answer)
              listen_socket(socket)
          {tcp_closed, socket} ->
              IO.puts("Socket ~w closed [~w]~n")
              :ok
    end
  end

  defp process(data) do
    IO.puts("Processing the data #{data}")
    data
  end

end



defmodule Client do

  @default_server_port 1337
  @default_timeout 500
  @default_packet_size 1024
  @local_host {127,0,0,1}

  def start_client(message) do
    {:ok, socket} = :gen_tcp.connect(@local_host, @default_server_port,
        [active: :false, packet_size: @default_packet_size])
    :gen_tcp.send(socket, message)
    received_data = :gen_tcp.recv(socket, 0)
    :gen_tcp.close(socket)
    received_data
  end

end

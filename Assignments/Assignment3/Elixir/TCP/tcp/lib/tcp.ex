# Required with both a server and a client
defmodule TCPServer do

  @default_server_port 1337
  @default_timeout 500
  @default_packet_size 1024
  @local_host {127,0,0,1}

  def init(stack) do
    {:ok, stack}
  end

  def accept_connection(port \\ @default_server_port) do
    case :gen_tcp.listen(port, [active: false, packet_size: @default_packet_size]) do

    {:ok, listen_socket} ->
      case :gen_tcp.accept(listen_socket, @default_timeout) do
        {:ok, socket} ->
          IO.puts("Accepted connection to #{socket}")
          listen_connection(socket)

        {:error, reason} ->
          IO.puts("Error due to #{reason}")
      end

    {:error, reason} ->
      IO.puts("Error due to #{reason}")
    end

    accept_connection()
  end

  def listen_connection(socket) do
    # :inet.port(socket) # gives local port-number
    case :gen_tcp.recv(socket, 0, @default_timeout) do
      {:ok, packet} ->
        IO.puts("Recieved #{packet} from #{socket}")
        :gen_tcp.send(socket, packet)

      {:error, reason} ->
        IO.puts("Error due to #{reason}")
    end

    listen_connection(socket)
  end

  def init_connection(ip_address, port) do

  end

  def close_connection(socket) do
    :gen_tcp.close(socket)
  end


  def send_data(ip_address, port, data) do

  end




end

defmodule TCPClient do

  @default_server_port 1337
  @default_timeout 500
  @default_packet_size 1024
  @local_host {127,0,0,1}

  def init(stack) do
    {:ok, stack}
  end

  def send_data() do
    case :gen_tcp.connect(@local_host, @default_server_port, [active: false, packet_size: @default_packet_size]) do
      {:ok, socket} ->
        :gen_tcp.send(socket, 10000111111111)
        :gen_tcp.recv(socket, 1024, 500) |> to_string |> IO.puts
      {:error, reason} ->
        IO.puts("fml")
    end
  end
end

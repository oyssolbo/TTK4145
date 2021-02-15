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


defmodule TcpServer do
  use GenServer

  def start_link() do
    ip = Application.get_env(:gen_tcp, :ip, {127,0,0,1})
    port = Application.get_env(:gen_tcp, :port, 20012)
    GenServer.start_link(__MODULE__, [ip,port], [])
  end

  def init [ip,port] do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, {:packet, 0}, {:active,true}, {:ip,ip}])
    {:ok, socket } = :gen_tcp.accept(listen_socket)
    {:ok, %{ip: ip, port: port, socket: socket}}
  end

  def handle_info({:tcp, socket, packet}, state) do
    IO.inspect(packet, label: "Incoming packet")
    :gen_tcp.send(socket, packet)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state) do
    IO.inspect("Socket has been closed")
    {:noreply, state}
  end

  def handle_info({:tcp_error, socket, reason}, state) do
    IO.inspect(socket, label: "Connection closed due to #{reason}")
    {:noreply,state}
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

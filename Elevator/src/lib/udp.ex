defmodule UDPServer do

  @default_network_mask {255, 255, 255, 255}
  @default_server_host 20012
  @default_timeout 500

  # Init connection
  # def start_link(port \\ default_server_host) do
  #   GenServer.start_link(__MODULE__, port)
  # end

  # Launch server
  def launch_server(port \\ @default_server_host) do
    #try do
    {:message, socket} = :gen_udp.open(port, [active: false])
    IO.puts("Setting up connection for socket #{socket}")
    :gen_udp.controlling_process(socket, self())
    {socket, :true}
      """
      if :message == :ok do
        IO.puts("Setting up connection for socket #{socket}")
        :gen_udp.controlling_process(socket, self())
        {socket, :true}
      else
        IO.puts("Connection already exists")
        {socket, :false}
      end
    rescue
      MatchError # need to raise an error first
      {@default_server_host, :false}
    end
    """
  end

  # Send data to destination
  def send_data(socket, destination, packet) do
    IO.puts("Sending data #{packet} to #{destination} at socket #{socket}")
    :gen_udp.send(socket, destination, packet)
  end

  # Listen for data
  def listen(socket, timeout \\ @default_timeout) do
    {:ok, {address, port, packet}} = :gen_udp.recv(socket, 0, timeout)
    IO.puts("Recieved data #{packet} from ip #{address} at port #{port}")
    packet
  end

  # Close socket
  def shut_down_server(socket) do
    :gen_udp.close(socket)
  end

  # Handle recieved UDP-packets
  # def handle_udp_packet({:udp, _socket, _address, _port, data}, socket) do
  #   if data == "quit\n" do
  #     IO.puts("Shutting down the UDP-server")
  #     :gen_udp.close(socket)
  #   else
  #     IO.puts("Recieved message: #{data}")
  #   end
  # end
end

defmodule Test_udp do
  #use UDPServer

  def test_udp() do
    {:ok, {socket, :bool}} = UDPServer.launch_server()
    if :bool == :true do
      UDPServer.send_data(socket, 20012, "0110011011")
      UDPServer.listen(socket)
      UDPServer.shut_down_server(socket)
    end
  end
end

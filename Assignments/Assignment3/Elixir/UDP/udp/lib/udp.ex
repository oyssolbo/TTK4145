defmodule UDPServer do

  use GenServer

  # Didn't get to use this afterall...
  @network_mask 255.255.255.255

  # Init connection
  def start_link(port \\ 30000) do
    GenServer.start_link(__MODULE__, port)
  end

  # Open the port
  def open_port(port) do
    :gen_udp.open(port, [:binary, active: true])
  end

  # Send data over port
  def send_data_over_port(port, data) do
    :gen_udp.send(port, data)
  end

  # Handle recieved UDP-packets
  def handle_udp_packet({:udp, _socket, _address, _port, data}, socket) do
    if data == "quit\n" do
      IO.puts("Shutting down the UDP-server")
      :gen_udp.close(socket)
    else
      IO.puts("Recieved message: #{data}")
    end
  end
end



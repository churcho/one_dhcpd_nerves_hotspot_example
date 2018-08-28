defmodule HelloHotspot.Hotspot do
  @subnet {192, 168, 24, 0}
  @ifname "wlan0"

  use GenServer

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(opts) do
    ifname = Keyword.get(opts, :ifname, @ifname)
    subnet = Keyword.get(opts, :subnet, @subnet)
    {:ok, hostname} = :inet.gethostname()
    {:ok, dhcp} = OneDHCPD.start_server(ifname, subnet: subnet)
    Process.link(dhcp)

    our_ip =
      OneDHCPD.IPCalculator.our_ip_address(subnet)
      |> :inet.ntoa()
      |> to_string()

    subnet_mask =
      OneDHCPD.default_subnet_mask()
      |> :inet.ntoa()
      |> to_string()

    network_opts =
      [ssid: to_string(hostname), key_mgmt: :NONE, mode: 2]
      |> Keyword.put(:ipv4_address_method, :static)
      |> Keyword.put(:ipv4_address, our_ip)
      |> Keyword.put(:ipv4_subnet_mask, subnet_mask)

    _ = Nerves.Network.setup(ifname, network_opts)
    {:ok, %{ifname: ifname, network_opts: network_opts}}
  end

  def terminate(_, state) do
    Nerves.Network.teardown(state.ifname)
    Nerves.Network.setup(state.ifname, [])
    _ = OneDHCPD.stop_server(state.ifname)
  end
end

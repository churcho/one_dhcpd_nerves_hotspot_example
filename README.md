# HelloHotspot
Example Nerves + Phoenix application that starts a wireless hotspot on
RPI0 (or any Nerves enabled device that supports softap).

## Usage

```bash
# Fetch dependencies.
MIX_TARGET=rpi0 mix deps.get
# Compile firmware image.
MIX_TARGET=rpi0 mix firmware
# Burn image to SD card.
MIX_TARGET=rpi0 mix firmware.burn
```

When booted you will see a wireless hotspot `nerves-ABCD` where `ABCD` is an
identifier for your device.

Point a web browser to `192.168.24.1` to be greeted with the Hello Phoenix
sample web page.

## What's next?
This is just an example. You don't _need_ phoenix. The important things to get
a hotspot running are:

```elixir
# mix.exs

# Add `nerves_init_gadget` and `nerves_network` to
# your target dependencies list.
defp deps(target) do
  [
    {:nerves_runtime, "~> 0.6"},
    {:nerves_init_gadget, "~> 0.4", github: "nerves-project/nerves_init_gadget", branch: "one_dhcp"},
    {:nerves_network, path: "../nerves_network", override: true}
  ] ++ system(target)
end
```

and the file `lib/hello_hotspot/hotspot.ex`

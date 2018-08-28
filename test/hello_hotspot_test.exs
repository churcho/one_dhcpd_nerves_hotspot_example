defmodule HelloHotspotTest do
  use ExUnit.Case
  doctest HelloHotspot

  test "greets the world" do
    assert HelloHotspot.hello() == :world
  end
end

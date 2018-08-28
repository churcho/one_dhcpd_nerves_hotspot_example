defmodule HelloHotspotWeb.PageController do
  use HelloHotspotWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

defmodule DiggaWeb.SitemapController do
  use DiggaWeb, :controller

  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/xml")
    |> render("index.xml", layout: false)
  end
end

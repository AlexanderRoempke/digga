defmodule DiggaWeb.SitemapXML do
  @moduledoc false
  use DiggaWeb, :html

  embed_templates "sitemap_xml/*"
end

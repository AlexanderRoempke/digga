defmodule DiggaWeb.Layouts do
  @moduledoc false
  use DiggaWeb, :html

  embed_templates "layouts/*"

  defp app_nav_items do
    [
      %{label: "Dashboard", icon: "hero-home", path: ~p"/"},
      ## Insert app nav items below ##
    ]
  end

  defp admin_nav_items do
    [
      %{label: "Admin", icon: "hero-presentation-chart-line", path: ~p"/admin"},
      %{label: "Users", icon: "hero-user", path: ~p"/admin/users"},
      %{label: "Accounts", icon: "hero-users", path: ~p"/admin/accounts"},
      %{label: "Admins", icon: "hero-identification", path: ~p"/admin/admins"},
      %{label: "Developers", icon: "hero-beaker", path: ~p"/admin/developers"},
      ## Insert admin nav items below ##
      %{label: "Chats", icon: "hero-chat-bubble-bottom-center-text", path: ~p"/admin/chats"},
    ]
  end
end

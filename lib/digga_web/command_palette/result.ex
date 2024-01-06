defmodule DiggaWeb.CommandPalette.Result do
 
  @moduledoc """
  Used to wrap command palette results and make it easier to iterate on.
  """
  defstruct [:record, :type, :first_type, :index]

  defimpl DiggaWeb.CommandPalette.Format, for: Digga.Users.User do
    use DiggaWeb, :verified_routes
    def header(_), do: "Users"
    def label(user), do: user.email
    def link(user), do: ~p"/admin/users/#{user.id}"
  end
end
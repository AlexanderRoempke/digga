defmodule DiggaWeb.ComponentLibrary do
  defmacro __using__(_) do
    quote do
      import DiggaWeb.ComponentLibrary
      # Import additional component modules below
      import DiggaWeb.Components.Admin
      import DiggaWeb.Components.Cards
      import DiggaWeb.Components.Tables
      import DiggaWeb.Components.Badges
      import DiggaWeb.Components.Cards
      import DiggaWeb.Components.Dropdowns

    end
  end
  @moduledoc """
  This module is added and used in DiggaWeb. The idea is
  different component modules can be added and imported in the macro section above.
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def show_sidebar(js \\ %JS{}, id) do
    js
    |> JS.show(to: id)
    |> JS.show(
      to: "#{id}-backdrop",
      transition: {"transition-opacity ease-linear duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "#{id}-menu",
      display: "flex",
      transition: {"transition ease-in-out duration-300 transform", "-translate-x-full", "translate-x-0"}
    )
  end

  def hide_sidebar(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "#{id}-menu",
      transition: {"transition ease-in-out duration-300 transform", "translate-x-0", "-translate-x-full"}
    )
    |> JS.hide(
      to: "#{id}-backdrop",
      transition: {"transition-opacity ease-linear duration-300", "opacity-100", "opacity-0"}
    )
    |> JS.hide(to: id, transition: "fade-out")
  end
end

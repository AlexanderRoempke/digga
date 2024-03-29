defmodule Digga.AdminsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Digga.Admins` context.
  """

  def unique_admin_email, do: "admin#{System.unique_integer()}@example.com"
  def valid_admin_password, do: "hello world!"

  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(%{
        name: "Mr Admin",
        email: unique_admin_email(),
        password: valid_admin_password(),
        password_confirmation: valid_admin_password()
      })
      |> Digga.Admins.create_admin()

    admin
  end
end

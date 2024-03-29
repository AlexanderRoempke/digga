defmodule Digga.Admins.AuthTest do
  use Digga.DataCase, async: true

  import Digga.AdminsFixtures

  alias Digga.Admins.Auth

  describe "authenticate_admin" do
    test "authenticate_admin/2 with valid credentials returns ok tuple" do
      admin = admin_fixture()
      assert Auth.authenticate_admin(admin.email, valid_admin_password()) == {:ok, admin}
    end

    test "authenticate_admin/2 with invalid password returns error tuple" do
      admin = admin_fixture()
      assert Auth.authenticate_admin(admin.email, "wrongpassword") == {:error, "Incorrect email or password"}
    end
  end
end

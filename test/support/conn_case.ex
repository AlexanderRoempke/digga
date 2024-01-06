defmodule DiggaWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use DiggaWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint DiggaWeb.Endpoint

      use DiggaWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import DiggaWeb.ConnCase
    end
  end

  setup tags do
    Digga.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in users.

      setup :register_and_log_in_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = Digga.UsersFixtures.user_fixture()
    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    token = Digga.Users.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end
  @doc """
  Switches the admin to use a spefic users account

  It returns an updated `conn`.
  """
  def switch_account(%{conn: conn, account: account}) do
    %{conn: Plug.Conn.put_session(conn, :admin_account_id, account.id)}
  end

  def switch_account(%{conn: conn, user: user}) do
    %{conn: Plug.Conn.put_session(conn, :admin_account_id, user.account_id)}
  end

  @doc """
  Setup helper that registers and logs in admins.

      setup :register_and_log_in_admin

  It stores an updated connection and a registered admin in the
  test context.
  """
  def register_and_log_in_admin(%{conn: conn}) do
    admin = Digga.AdminsFixtures.admin_fixture()
    %{conn: log_in_admin(conn, admin), admin: admin}
  end

  @doc """
  Logs the given `admin` into the `conn`.
  It returns an updated `conn`.
  """
  def log_in_admin(conn, admin) do
    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Digga.Admins.Guardian.Plug.sign_in(admin, %{}, key: :admin)
  end
end

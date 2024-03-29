defmodule Digga.GraphqlTestHelpers do
  @moduledoc """
  Helpers for generating valit and invalid JWT for a user and put it in the conn header.
  Used in the GraphQL request tests.
  """
  import Digga.UsersFixtures

  def user_with_valid_jwt(%{conn: conn}) do
    user = user_fixture()

    {:ok, jwt, _full_claims} = Digga.Users.Guardian.encode_and_sign(user)
    {:ok, conn: Plug.Conn.put_req_header(conn, "authorization", "Bearer #{jwt}"), jwt: jwt, user: user}
  end

  def user_with_invalid_jwt(%{conn: conn}) do
    user = user_fixture()

    {:ok, conn: conn, jwt: nil, user: user}
  end
end

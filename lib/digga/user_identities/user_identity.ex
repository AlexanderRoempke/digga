defmodule Digga.UserIdentities.UserIdentity do
  @moduledoc """
  The User Identity schema. A user identity represents an oauth
  solution for a user. The idea is that a user can have several oauth solutions
  but the email is unique.
  """
  use Digga.Schema
  import Ecto.Changeset

  alias Digga.EctoHelpers.Stringable

  schema "user_identities" do
    field :provider, Stringable
    field :uid, Stringable

    belongs_to :user, Digga.Users.User

    timestamps()
  end

  @doc false
  def changeset(user_identity, attrs) do
    user_identity
    |> cast(attrs, [:provider, :uid])
    |> validate_required([:provider, :uid])
    |> unique_constraint(:provider, name: :user_identities_uid_provider_index)
  end
end

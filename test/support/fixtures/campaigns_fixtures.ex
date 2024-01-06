defmodule Digga.CampaignsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Digga.Campaigns` context.
  """

  import Digga.UsersFixtures

  alias Digga.Campaigns
  alias Digga.Campaigns.Receipt
  alias Digga.Users.User

  @doc """
  Generate a membership.
  """
  def membership_fixture(), do: membership_fixture(%{})
  def membership_fixture(%User{} = user), do: membership_fixture(user, %{})

  def membership_fixture(attrs) do
    user = user_fixture()
    membership_fixture(user, attrs)
  end

  def membership_fixture(%User{} = user, attrs) do
    attrs =
      Enum.into(attrs, %{
        campaign: :onboarding,
        step: :one
      })

    {:ok, membership} = Campaigns.create_membership(user, attrs)

    Campaigns.get_membership!(user, membership.id)
  end

  @doc """
  Generate a receipt.
  """
  def receipt_fixture(), do: receipt_fixture(%{})
  def receipt_fixture(%User{} = user), do: receipt_fixture(user, %{})

  def receipt_fixture(attrs) do
    user = user_fixture()
    receipt_fixture(user, attrs)
  end

  def receipt_fixture(%User{} = user, attrs) do
    attrs =
      Enum.into(attrs, %{
        user_id: user.id,
        campaign: "some campaign",
        step: "some step"
      })

    {:ok, receipt} =
      %Receipt{}
      |> Map.merge(attrs)
      |> Digga.Repo.insert()

    receipt
  end
end

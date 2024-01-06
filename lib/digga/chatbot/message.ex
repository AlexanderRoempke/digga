defmodule Digga.Chatbot.Message do
  @moduledoc """
  The message schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chatbot_messages" do
    field :content, :string
    field :role, :string, default: "user"
    belongs_to :conversation, Digga.Chatbot.Conversation

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:role, :content])
    |> validate_required([:role, :content])
    |> validate_inclusion(:role, ~w(assistant system user))
  end
end

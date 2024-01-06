defmodule Digga.Chatbot.Conversation do
  @moduledoc """
  The conversation schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {
    Flop.Schema,
    default_limit: 20,
    filterable: [:user_email],
    sortable: [:user_email],
    adapter_opts: [
      join_fields: [
        user_email: [
          binding: :user,
          field: :email,
          ecto_type: :string
        ]
      ]
    ]
  }
  schema "chatbot_conversations" do
    field :type, Ecto.Enum, values: [:chat, :json] # Depending on what to use it for
    belongs_to :user, Digga.Users.User
    has_many :messages, Digga.Chatbot.Message, preload_order: [asc: :inserted_at]

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:type, :user_id])
    |> validate_required([:type])
  end
end

defmodule Digga.Chatbot do
  @moduledoc """
  The Chatbot context.
  """
  import Ecto.Query, warn: false
  alias Digga.Repo

  alias Digga.Chatbot.Conversation
  alias Digga.Chatbot.Message

  defp base_conversation_query(opts) do
    preload = Keyword.get(opts, :preload, [])
    where = Keyword.get(opts, :where, [])
    order_by = Keyword.get(opts, :order_by, [])

    from(m in Conversation,
      where: ^where,
      preload: ^preload,
      order_by: ^order_by
    )
  end

  def paginate_chats(params \\ %{}) do
    query = from c in Conversation,
            join: u in assoc(c, :user),
            preload: [user: u]

    query
    |> Flop.validate_and_run(params, for: Conversation)
  end

  def list_conversations(opts \\ []) do
    Repo.all(base_conversation_query(opts))
  end

  def list_conversations_for_user(user, params \\ %{}) do
    query = from c in Conversation,
    join: u in assoc(c, :user),
    join: m in assoc(c, :messages),
    preload: [user: u, messages: m],
    where: u.id == ^user.id,
    order_by: [desc: c.updated_at]

    query
    |> Flop.validate_and_run(params, for: Conversation)
  end

  def get_conversation!(id, opts \\ []) do
    base_conversation_query(opts)
    |> Repo.get!(id)
  end

  def create_conversation(user, attrs \\ %{}) do
    %Conversation{}
    |> Conversation.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def update_conversation(%Conversation{} = conversation, attrs) do
    conversation
    |> Conversation.changeset(attrs)
    |> Repo.update()
  end

  def delete_conversation(%Conversation{} = conversation) do
    Repo.delete(conversation)
  end

  def create_message(%Conversation{} = conversation, attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:conversation, conversation)
    |> Repo.insert()
  end

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end

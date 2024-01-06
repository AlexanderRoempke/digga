defmodule Digga.ChatbotFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Digga.Chatbot` context.
  """

  alias Digga.Chatbot
  alias Digga.Chatbot.Conversation

  @doc """
  Generate a conversation.
  """
  def conversation_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        type: :chat
      })

    {:ok, conversation} = Chatbot.create_conversation(attrs)

    Chatbot.get_conversation!(conversation.id)
  end

  @doc """
  Generate a message.
  """
  def message_fixture(), do: message_fixture(%{})
  def message_fixture(%Conversation{} = conversation), do: message_fixture(conversation, %{})

  def message_fixture(attrs) do
    conversation = conversation_fixture()
    message_fixture(conversation, attrs)
  end

  def message_fixture(%Conversation{} = conversation, attrs) do
    attrs =
      Enum.into(attrs, %{
        role: "user",
        content: "some content"
      })

    {:ok, message} = Chatbot.create_message(conversation, attrs)

    message
  end
end

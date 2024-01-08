defmodule Digga.Chatbot.Server do
  @moduledoc """
  This is responsible for receiving chat messages and
  go to the Openai api and fetching a reply and after that
  notify subscribers with Phoenix PubSub.
  """
  use GenServer

  alias Digga.Chatbot
  alias Digga.Chatbot.OpenaiService

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def subscribe(conversation) do
    Phoenix.PubSub.subscribe(Digga.PubSub, "chat-#{conversation.id}")
  end

  def generate_response(message) do
    IO.puts("i am in generate_response")
    GenServer.cast(__MODULE__, {:message, message})
  end

  #############################

  def handle_cast({:message, message}, state) do
    IO.puts("i am in handle_cast")
    conversation = Chatbot.get_conversation!(message.conversation_id, preload: [:messages])
    
    last_no_messages =
      get_last_no_messages(conversation)
      |> Enum.map(fn %{role: role, content: content} ->
        %{"role" => role, "content" => content}
      end)
    
    IO.puts("last_no_messages: #{inspect last_no_messages}")
    chat_response = OpenaiService.call(last_no_messages)

    conversation
    |> Chatbot.create_message(chat_response)
    |> notify_subscribers()

    {:noreply, state}
  end

  defp get_last_no_messages(%{type: :chat} = conversation) do
    Enum.slice(conversation.messages, -5..-1) # last 5 messages
  end

  defp get_last_no_messages(%{type: :json} = conversation) do
    Enum.slice(conversation.messages, -1..-1) # last message
  end

  defp get_last_no_messages(%{type: _} = conversation) do
    Enum.slice(conversation.messages, -1..-1) # last message
  end

  defp notify_subscribers({:ok, message}) do
    Phoenix.PubSub.broadcast(Digga.PubSub, "chat-#{message.conversation_id}", {:response_message, message})
  end

  defp notify_subscribers(_), do: nil

  defmodule Mock do
    @moduledoc "Just used for tests"
    use GenServer
    def start_link(_), do: GenServer.start_link(__MODULE__, nil)
    def init(state), do: {:ok, state}
    def subscribe(_conversation), do: nil
    def generate_response(_message), do: nil
  end
end

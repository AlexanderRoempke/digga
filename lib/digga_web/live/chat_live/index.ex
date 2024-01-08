defmodule DiggaWeb.ChatLive.Index do
  @moduledoc """
  The conversations index page.
  """
  use DiggaWeb, :live_view

  alias Digga.Chatbot
  alias Digga.Users
  # alias Digga.Chatbot.Conversation
  alias Digga.Chatbot.Message
  alias Digga.Chatbot.Server, as: ChatbotServer

   @impl true
   def mount(_params, _session, socket) do
    current_user =
      socket.assigns.current_user

    {:ok,
    socket
    |> get_conversations_for_user()
    |> assign(:current_user, current_user)}
   end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    IO.puts("in Apply Action => id: #{inspect(id)}")
    conversation = Chatbot.get_conversation!(id, preload: [:messages])
    IO.puts("in Apply Action => conversation: #{inspect(conversation)}")  
    ChatbotServer.subscribe(conversation)

    socket
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:conversation, conversation)
    |> stream(:messages, conversation.messages)
  end

  defp apply_action(socket, :index, _params) do
    IO.puts("in Apply Action => index")
    socket
    |> assign(:conversation, nil)
  end

  @impl true
  def handle_info({DiggaWeb.ChatLive.FormComponent, {:saved, message}}, socket) do
    {:noreply, stream_insert(socket, :messages, message)}
    ChatbotServer.generate_response(message)
    {:noreply, stream_insert(socket, :messages, message)}
  end

  def handle_info({:response_message, message}, socket) do
    {:noreply, stream_insert(socket, :messages, message)}
  end

  defp get_conversations_for_user(socket)do
    case Chatbot.list_conversations_for_user(socket.assigns.current_user) do
      {:ok, {conversations, meta}} ->
        assign(socket, %{conversations: conversations, meta: meta})
      _ ->
      socket
  end
  end
end

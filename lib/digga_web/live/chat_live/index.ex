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
   def mount(_params, session, socket) do
    current_user =
      socket.assigns.current_user
    {:ok, assign(socket, :current_user, current_user)}
   end

  @impl true
  def handle_params(params, _url, socket) do
    IO.puts("params: #{inspect(params)}")
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    conversation = Chatbot.get_conversation!(id, preload: [:messages])
    IO.puts("conversation: #{inspect(conversation)}")
    ChatbotServer.subscribe(conversation)

    socket
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:conversation, conversation)
    |> stream(:messages, conversation.messages)
  end

  defp apply_action(socket, :index, _params) do
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
end

defmodule DiggaWeb.Admin.ChatLive.Show do
    use DiggaWeb, :live_view

    alias Digga.Chatbot
    alias Digga.Chatbot.Message
    alias Digga.Chatbot.Server, as: ChatbotServer

    @impl true
    def mount(_params, _session, socket) do
        {:ok, socket}
    end
    @impl true
    def handle_params(params, _url, socket) do
         {:noreply, apply_action(socket, socket.assigns.live_action, params)}
    end
    defp page_title(:show), do: "Show Chat"
    defp page_title(:edit), do: "Edit Chat"

    defp apply_action(socket, :show, %{"id" => id}) do
    conversation = Chatbot.get_conversation!(id, preload: [:messages])
    IO.puts("conversation: #{inspect(conversation)}")
    ChatbotServer.subscribe(conversation)
    
    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:conversation, conversation)
    |> stream(:messages, conversation.messages)
    end
end



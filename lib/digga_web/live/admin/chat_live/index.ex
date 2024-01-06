defmodule DiggaWeb.Admin.ChatLive.Index do
    use DiggaWeb, :live_view

    alias Digga.Chatbot

    @impl true
    def mount(_params, _session, socket) do
        {:ok, socket}
    end

    @impl true
    def handle_params(params, _url, socket) do
    {
        :noreply,
        socket
        |> assign(:params, params)
        |> apply_action(socket.assigns.live_action, params)
    }
    end

    defp apply_action(socket, :index, params) do
        socket
        |> assign(:page_title, "Listing Chats")
        |> assign(:chat, nil)
        |> assing_chats(params)
        |> assign(:params, params)
    end

    @impl true
    def handle_event("update-filter", params, socket) do
        {:noreply, push_patch(socket, to: ~p"/admin/chats?#{params}")}
    end

    defp assing_chats(socket, params) do
        case Chatbot.paginate_chats(params) do
            {:ok, {conversations, meta}} ->
            assign(socket, %{conversations: conversations, meta: meta})
            _ ->
            push_navigate(socket, to: ~p"/admin/chats")
        end
    end
end




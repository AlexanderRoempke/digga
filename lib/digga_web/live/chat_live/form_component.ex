defmodule DiggaWeb.ChatLive.FormComponent do
  @moduledoc """
  The form for creating or editing a single message.
  """
  use DiggaWeb, :live_component

  alias Digga.Chatbot

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        for={@form}
        id="message-form"
        phx-target={@myself}
        phx-change="change"
        phx-submit="save"
      >
        <div class="relative">
          <.input field={@form[:content]} type="text" required="true" placeholder="Send a message.." autocomplete="off" label="" value={@content}/>
          <button type="submit" value={@content} class="absolute right-2 bottom-2 flex items-center">
            <.icon name="hero-paper-airplane" class="w-6 h-6 text-zinc-200/40" />
          </button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{message: message} = assigns, socket) do
    changeset = Chatbot.change_message(message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:content, "")
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("change", %{"message" => %{"content" => content}}, socket) do
    {:noreply, assign(socket, :content, content)}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    IO.puts("handle_event save")
    {:ok, conversation} = get_or_create_conversation(socket)
    
    case Chatbot.create_message(conversation, message_params) do
      {:ok, message} ->
        notify_parent({:saved, message})
        IO.puts("success in event save")
        {:noreply,
         socket
         |> assign(:content, "")
         |> maybe_push_patch(conversation)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("error in event save")
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp get_or_create_conversation(%{assigns: %{conversation: %{} = conversation}}), do: {:ok, conversation}
  defp get_or_create_conversation(socket) do
    user = socket.assigns.current_user
    Chatbot.create_conversation(user, %{type: :chat, user_id: user.id})
  end

  defp maybe_push_patch(%{assigns: %{action: :index}} = socket, conversation) do
    push_patch(socket, to: ~p"/chats/#{conversation}")
  end
  defp maybe_push_patch(socket, _conversation), do: socket

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

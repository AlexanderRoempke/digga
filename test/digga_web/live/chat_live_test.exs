defmodule DiggaWeb.ChatLiveTest do
  use DiggaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Digga.Chatbot

  @create_attrs %{content: "Initial question"}

  describe "Index" do
    test "saves new message", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/chats")

      assert index_live
             |> form("#message-form", message: @create_attrs)
             |> render_submit()

      [last_conversation] = Digga.Chatbot.list_conversations(preload: [:messages])

      assert_patch(index_live, ~p"/chats/#{last_conversation}")

      html = render(index_live)
      assert html =~ "Initial question"

      {:ok, message} = Chatbot.create_message(last_conversation, %{content: "This is a AI response", role: "assistant"})
      send(index_live.pid, {:response_message, message})

      html = render(index_live)
      assert html =~ "Initial question"
      assert html =~ "This is a AI response"
    end
  end
end

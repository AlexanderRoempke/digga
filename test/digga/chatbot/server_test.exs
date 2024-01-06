defmodule Digga.Chatbot.ServerTest do
  use Digga.DataCase

  import Digga.ChatbotFixtures

  alias Digga.Chatbot.Server

  describe "listen for and processing a stripe event" do
    test "processes incoming events after broadcasing it" do
      conversation = conversation_fixture()
      message = message_fixture(conversation)

      {:ok, _pid} = start_supervised(Server, [])

      Server.subscribe(conversation)
      Server.generate_response(message)

      assert_receive {:response_message, _message}
    end
  end
end

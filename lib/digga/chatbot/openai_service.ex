defmodule Digga.Chatbot.OpenaiService do
  @moduledoc """
  This service makes api requests to Open AI and extracts relevant response.
  It mocks the response in test.
  """
  @enabled_in [:dev, :prod]

  defp default_system_prompt do
    """
    You're a Miami club owner, a mix of Haitian and Cuban-American heritage. You've been through the mill but kept your integrity. Now you're giving advice to a newbie. Be straight-up, use your street smarts to guide, but never patronize. Share a slice of your life if they need a reality check, but always stay genuine and grounded.
    Only give short answers.
    """
  end

  def call(prompts, opts \\ []) do
    %{
      "model" => "gpt-3.5-turbo",
      "messages" => Enum.concat([
        %{"role" => "system", "content" => default_system_prompt()},
      ], prompts),
      "temperature" => 0.7
    }
    |> Jason.encode!()
    |> request(opts)
    |> parse_response()
  end

  defp parse_response({:ok, %Finch.Response{body: body}}) do
    messages =
      Jason.decode!(body)
      |> Map.get("choices", [])
      |> Enum.reverse()

    case messages do
      [%{"message" => message}|_] -> message
      _ -> "{}"
    end
  end

  defp parse_response(error) do
    # IO.inspect(error)
    error
  end

  defp request(body, _opts) do
    if Enum.member?(@enabled_in, Application.get_env(:digga, :env)) do
      Finch.build(:post, "https://api.openai.com/v1/chat/completions", headers(), body)
      |> Finch.request(Digga.Finch, receive_timeout: 40_000)
    else
      example = Jason.encode!(%{
        "choices" => [
          %{
            "finish_reason" => "stop",
            "index" => 0,
            "message" => %{
              "content" => "This is a test response",
              "role" => "assistant"
            }
          }
        ],
      })

      {:ok, %Finch.Response{body: example}}
    end
  end

  defp headers do
    [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{Application.get_env(:digga, :open_ai_api_key)}"},
    ]
  end
end

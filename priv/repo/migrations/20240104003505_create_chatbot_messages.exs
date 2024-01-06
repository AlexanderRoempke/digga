defmodule Digga.Repo.Migrations.CreateChatbotMessages do
  use Ecto.Migration

  def change do
    create table(:chatbot_messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role, :string
      add :content, :text
      add :conversation_id, references(:chatbot_conversations, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:chatbot_messages, [:conversation_id])
  end
end

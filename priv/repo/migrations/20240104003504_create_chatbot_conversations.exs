defmodule Digga.Repo.Migrations.CreateChatbotConversations do
  use Ecto.Migration

  def change do
    create table(:chatbot_conversations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :user_id, references(:users, on_delete: :nilify_all, type: :binary_id)

      timestamps()
    end

    create index(:chatbot_conversations, [:user_id])
  end
end

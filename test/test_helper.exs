ExUnit.configure(exclude: :feature)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Digga.Repo, :manual)

defmodule Digga.DailyReports.DailyReportWorker do
  @moduledoc """
  The worker should be scheduled for once a day. It
  performs all queries and loops through all admins to deliver
  the reports email.
  """
  use Oban.Worker, unique: [period: 60]

  alias Digga.Admins
  alias Digga.Mailer
  alias Digga.DailyReports
  alias Digga.DailyReports.DailyReportNotifier

  @impl Oban.Worker
  def perform(_) do
    metrics = DailyReports.perform_queries()

    Admins.list_admins()
    |> Enum.each(fn %{email: email} ->

      DailyReportNotifier.deliver_report(%{email: email, metrics: metrics})
      |> Mailer.deliver()

    end)
  end
end

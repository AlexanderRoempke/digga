defmodule DiggaWeb.EmailHTML do
  @moduledoc """
  This viewmodule is responsible for rendering the emails and the layouts.
  Can be used in the notifier by adding:

      Digga.Mailer

  Or:

      import Swoosh.Email
      import Digga.Mailer, only: [base_email: 0, premail: 1, render_body: 3]

  """
  use DiggaWeb, :html

  embed_templates "emails/*.html"
  embed_templates "emails/*.text", suffix: "_text"
end

defmodule Chronox.Clients.Google.Calendar do
  use HTTPoison.Base

  def get_busy_time(email, start_time, end_time, token) do
    post!(
      "freeBusy",
      %{
        timeMin: start_time,
        timeMax: end_time,
        timeZone: "UTC",
        items: [
          %{
            id: email
          }
        ]
      },
      [
        {"Authorization", "Bearer #{token}"},
        {"Content-Type", "application/json"}
      ]
    )
  end

  def process_request_url(endpoint), do: "https://www.googleapis.com/calendar/v3/" <> endpoint

  def process_request_body(body), do: Jason.encode!(body)

  def process_response_body(body) do
    body
    |> Jason.decode!()
  end
end

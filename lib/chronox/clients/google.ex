defmodule Chronox.Clients.Google do
  use HTTPoison.Base

  def get_busy_time(id, start_time, end_time, token) do
    %{body: %{"calendars" => %{^id => %{"busy" => busy}}}} =
      post!(
        "freeBusy",
        %{
          timeMin: start_time,
          timeMax: end_time,
          timeZone: "UTC",
          items: [
            %{
              id: id
            }
          ]
        }
        |> Jason.encode!(),
        request_headers(token)
      )

    busy
  end

  def get_calendars_list(token) do
    %{body: %{"items" => items}} = get!("users/me/calendarList", request_headers(token))

    items
    |> Enum.filter(&(&1["selected"] == true))
    |> Enum.map(& &1["id"])
  end

  defp request_headers(token) do
    [
      {"Authorization", "Bearer #{token}"}
    ]
  end

  def process_request_url(endpoint), do: "https://www.googleapis.com/calendar/v3/" <> endpoint

  def process_response_body(body) do
    body
    |> Jason.decode!()
  end
end

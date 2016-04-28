defmodule ExTumblr.Connector.HTTPConnector do
  use HTTPoison.Base

  @endpoint "https://api.tumblr.com/v2"

  defp process_url(url) do
    @endpoint <> url
  end

  defp process_response_body(body) do
    Poison.decode!(body)
  end
end

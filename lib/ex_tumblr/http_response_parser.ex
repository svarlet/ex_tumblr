defprotocol ExTumblr.HTTPResponseParser do
  @doc """
  Parses the http response to return the decoded results as a map.
  """
  @spec parse(any) :: {:ok, any} | {:error, any}
  def parse(http_response)
end

defimpl ExTumblr.HTTPResponseParser, for: HTTPoison.Response do
  def parse(%HTTPoison.Response{status_code: 200, body: body}) do
    parse_response_body body
  end

  def parse(%HTTPoison.Response{status_code: 301, body: body, headers: headers}) do
    if List.keymember? headers, "Location", 0 do
      parse_response_body body
    else
      fail_with_unexpected_status_code(301)
    end
  end

  def parse(%HTTPoison.Response{status_code: status_code}) do
    fail_with_unexpected_status_code(status_code)
  end

  defp parse_response_body(body) do
    body
    |> Poison.decode!
    |> Map.get("response")
  end

  defp fail_with_unexpected_status_code(status_code) do
    {:error, "Received a http response with a non 200 status (#{status_code})"}
  end
end

defimpl ExTumblr.HTTPResponseParser, for: HTTPoison.Error do
  def parse(%HTTPoison.Error{reason: reason}) do
    {:error, reason}
  end
end

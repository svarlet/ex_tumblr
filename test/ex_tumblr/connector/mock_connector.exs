defmodule ExTumblr.Connector.MockConnector do
  defp mock_http_response(headers, body), do: %{headers: headers, body: body}

  def get!("/blog/gunkatana.tumblr.com/info?api_key=api-key") do
    http_response_body = """
    {
      "meta": {
        "status":200,
        "msg":"OK"
      },
      "response": {
        "blog": {
          "title":"Gunkatana",
          "name":"gunkatana",
          "total_posts":13,
          "posts":13,
          "url":"http:\/\/gunkatana.tumblr.com\/",
          "updated":1455328457,
          "description":"a cool description",
          "is_nsfw":false,
          "ask":false,
          "ask_page_title":"Ask me anything",
          "ask_anon":false,
          "share_likes":false
        }
      }
    }
    """
    |> Poison.decode!
    mock_http_response(nil, http_response_body)
  end
end

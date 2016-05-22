defmodule ExTumblr do
  defmodule Credentials do
    defstruct consumer_key: nil, consumer_secret: nil, token: nil, token_secret: nil
  end

  alias ExTumblr.Blog

  def blog_info(blog_identifier, credentials, params) do
    Blog.info(blog_identifier, credentials, params)
    |> send_request
  end

  defp send_request({method, url, api_params, :oauth, creds}) do
    {headers, body} = sign_request(method, url, api_params, creds)
    HTTPoison.request method, url, {:form, body}, [headers]
  end

  defp send_request({method, url, api_params, :api_key_auth, creds}) do
    query =
      api_params
      |> Map.put("api_key", creds.consumer_key)
      |> URI.encode_query
    HTTPoison.request method, "#{url}?#{query}"
  end

  defp send_request({method, url, api_params, :no_auth, _creds}) do
    query = URI.encode_query(api_params)
    HTTPoison.request method, "#{url}?#{query}"
  end

  defp sign_request(method, url, params, credentials) do
    oauth_creds = OAuther.credentials(
      consumer_key: credentials.consumer_key,
      consumer_secret: credentials.consumer_secret,
      token: credentials.token,
      token_secret: credentials.token_secret
    )
    OAuther.sign(to_string(method), url, Keyword.new(params), oauth_creds)
    |> OAuther.header
  end
end

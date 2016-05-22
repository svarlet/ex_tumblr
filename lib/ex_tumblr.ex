defmodule ExTumblr do
  defmodule Credentials do
    defstruct consumer_key: nil, consumer_secret: nil, token: nil, token_secret: nil
  end

  alias ExTumblr.Blog

  def blog_info(blog_identifier, credentials, params) do
    {method, url, api_params, auth, creds} = Blog.info(blog_identifier, credentials, params)

    # si oauth ou post alors
    # genere body
    # genere headers
    # sinon si get
    # genere query
    # fin

    cond do
      :oauth == auth ->
        {headers, body} = sign_request(method, url, api_params, creds)
        HTTPoison.request method, url, {:form, body}, [headers]
      :api_key_auth == auth ->
        query =
          api_params
          |> Map.put("api_key", creds.consumer_key)
          |> URI.encode_query
        HTTPoison.request method, "#{url}?#{query}"
      :no_auth ->
        query = URI.encode_query(api_params)
        HTTPoison.request method, "#{url}?#{query}"
    end
  end

  defp sign_request(method, url, params, credentials) do
    oauth_creds = OAuther.credentials(
      consumer_key: credentials.consumer_key,
      consumer_secret: credentials.consumer_secret,
      token: credentials.token,
      token_secret: credentials.token_secret
    )
    {headers, body} =
      OAuther.sign(to_string(method), url, Keyword.new(params), oauth_creds)
      |> OAuther.header
  end
end

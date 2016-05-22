defmodule ExTumblr do
  defmodule Credentials do
    defstruct consumer_key: nil, consumer_secret: nil, token: nil, token_secret: nil
  end

  alias ExTumblr.Blog

  def blog_info(blog_identifier, credentials, params) do
    Blog.info(blog_identifier, credentials, params)
    |> send_request
  end

  def blog_avatar(blog_identifier, size \\ 64) do
    Blog.avatar(blog_identifier, size)
    |> send_request
  end

  def blog_followers(blog_identifier, credentials, params) do
    Blog.followers(blog_identifier, credentials, params)
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
    query = case api_params do
              nil -> ""
              _ -> URI.encode_query(api_params)
              end
    HTTPoison.request method, "#{url}?#{query}"
  end

  defp sign_request(method, url, params, credentials) do
    oauth_creds = OAuther.credentials(
      consumer_key: credentials.consumer_key,
      consumer_secret: credentials.consumer_secret,
      token: credentials.token,
      token_secret: credentials.token_secret
    )
    params_as_keyword = case params do
                          nil -> []
                          _ -> Keyword.new(params)
                        end
    OAuther.sign(to_string(method), url, params_as_keyword, oauth_creds)
    |> OAuther.header
  end
end

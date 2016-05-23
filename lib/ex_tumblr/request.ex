defmodule ExTumblr.Request do
  defstruct [:method, :url, :headers, :body]

  @type authorization_headers :: {String.t, String.t}

  @type method :: :get | :post
  @type url :: String.t
  @type body :: {:form, Keyword.t}
  @type headers :: {String.t, String.t}
  @type prepared_request :: {method, url, body, headers}

  defp prepare_request_auth({method, url, :oauth}, credentials, params) do
    {headers, body} = Request.sign_request_with_oauth(method, url, params, credentials)
    {method, url, {:form, body}, [headers]}
  end

  defp prepare_request_auth({method, url, :api_key_auth}, credentials, params) do
    query =
      params
      |> if_nil(Map.new)
      |> Map.put("api_key", credentials.consumer_key)
      |> URI.encode_query
    {method, "#{url}?#{query}", nil, nil}
  end

  defp prepare_request_auth({method, url, :no_auth}, _credentials, params) do
    query =
      params
      |> if_nil("")
      |> URI.encode_query
    {method, "#{url}?#{query}", nil, nil}
  end

  defp if_nil(value, new_value) do
    if is_nil(value) do
      new_value
    else
      value
    end
  end

  @spec sign_request_with_oauth(atom, String.t, Credentials.t, Keyword.t) :: {authorization_headers, Keyword.t}
  def sign_request_with_oauth(method, url, credentials, params) do
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

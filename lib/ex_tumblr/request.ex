defmodule ExTumblr.Request do
  alias ExTumblr.Credentials

  @type authorization_headers :: {String.t, String.t}

  @type method :: :get | :post
  @type url :: String.t
  @type body :: {:form, Keyword.t}
  @type headers :: {String.t, String.t}
  @type prepared_request :: {method, url, body, headers}

  def prepare_request_auth({method, url, :oauth}, credentials, params) do
    {headers, body} = sign_request_with_oauth(method, url, credentials, params)
    {method, url, {:form, body}, [headers]}
  end

  def prepare_request_auth({:get, url, :api_key_auth}, credentials, params) do
    query =
      params
      |> if_nil(Map.new)
      |> Map.put("api_key", credentials.consumer_key)
      |> URI.encode_query
    {:get, "#{url}?#{query}", nil, nil}
  end

  def prepare_request_auth({:get, url, :no_auth}, _credentials, params) do
    query =
      params
      |> if_nil(Map.new)
      |> URI.encode_query
    case query do
      "" -> {:get, url, nil, nil}
      _ -> {:get, "#{url}?#{query}", nil, nil}
    end
  end

  defp if_nil(value, new_value) do
    if is_nil(value) do
      new_value
    else
      value
    end
  end

  @spec sign_request_with_oauth(atom, String.t, Credentials.t, Keyword.t) :: {authorization_headers, Keyword.t}
  defp sign_request_with_oauth(method, url, credentials, params) do
    to_oauth_creds = fn %Credentials{} = creds ->
      OAuther.credentials(
        consumer_key: creds.consumer_key,
        consumer_secret: creds.consumer_secret,
        token: creds.token,
        token_secret: creds.token_secret
      )
    end

    to_string_tag = fn {key, value} when is_atom(key) -> {to_string(key), value} end

    to_keyword = fn list ->
      list
      |> if_nil(Keyword.new)
      |> Enum.map(to_string_tag)
    end

    OAuther.sign(to_string(method), url, to_keyword.(params), to_oauth_creds.(credentials))
    |> OAuther.header
  end
end

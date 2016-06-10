defmodule ExTumblr.Auth do
  @moduledoc false

  alias ExTumblr.Credentials

  @type authorization_headers :: {String.t, String.t}
  @type auth :: :oauth | :api_key_auth | :no_auth
  @type base_request :: {method, url, auth}
  @type method :: :get | :post
  @type url :: String.t
  @type body :: {:form, Keyword.t}
  @type headers :: {String.t, String.t}
  @type signed_request :: {method, url, body, headers}

  @spec sign(base_request, Credentials.t, map) :: signed_request
  def sign({method, url, :oauth}, credentials, params) do
    {headers, body} = sign_request_with_oauth(method, url, credentials, params)
    {method, url, {:form, body}, [headers]}
  end

  def sign({:get, url, :api_key_auth}, credentials, params) do
    query =
      (params || Map.new)
      |> Map.put("api_key", credentials.consumer_key)
      |> URI.encode_query
    {:get, "#{url}?#{query}", nil, nil}
  end

  def sign({:get, url, :no_auth}, _credentials, params) do
    query = URI.encode_query(params || Map.new)
    case query do
      "" -> {:get, url, nil, nil}
      _ -> {:get, "#{url}?#{query}", nil, nil}
    end
  end

  @spec sign_request_with_oauth(method, url, Credentials.t, map) :: {authorization_headers, [{String.t, any}]}
  defp sign_request_with_oauth(method, url, credentials, params) do
    oauther_creds =
      OAuther.credentials(
        consumer_key: credentials.consumer_key,
        consumer_secret: credentials.consumer_secret,
        token: credentials.token,
        token_secret: credentials.token_secret
      )

    stringify_tuple_tag =
      fn {key, value} when is_atom(key) ->
        {to_string(key), value}
      end

    map_to_tuples =
      fn map ->
        (map || Map.new)
        |> Map.to_list
        |> Enum.map(stringify_tuple_tag)
      end

    require Logger
    Logger.warn "OAuther.sign(#{method}, #{url}, #{inspect map_to_tuples.(params)}, #{inspect oauther_creds})"
    OAuther.sign(to_string(method), url, map_to_tuples.(params), oauther_creds)
    |> OAuther.header
  end
end

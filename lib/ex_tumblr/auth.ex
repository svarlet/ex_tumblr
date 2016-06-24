defmodule ExTumblr.Auth do
  @moduledoc false

  alias ExTumblr.Client

  @type authorization_headers :: {String.t, String.t}
  @type auth :: :oauth | :api_key_auth | :no_auth
  @type base_request :: {method, path, auth}
  @type method :: :get | :post
  @type url :: String.t
  @type path :: String.t
  @type body :: {:form, Keyword.t} | nil
  @type headers :: {String.t, String.t} | nil
  @type signed_request :: {method, url, body, headers}

  @spec sign(base_request, Client.t, map) :: signed_request
  def sign({method, path, :oauth}, client, params) do
    url = build_url(client.hostname, path)
    {headers, body} = sign_request_with_oauth(method, url, client.credentials, params)
    {method, url, {:form, body}, [headers]}
  end

  def sign({:get, path, :api_key_auth}, client, params) do
    query =
      (params || Map.new)
      |> Map.put("api_key", client.credentials.consumer_key)
      |> URI.encode_query
    {:get, build_url(client.hostname, path, query), nil, nil}
  end

  def sign({:get, path, :no_auth}, client, params) do
    query = URI.encode_query(params || Map.new)
    {:get, build_url(client.hostname, path, query), nil, nil}
  end

  defp build_url(hostname, path, query \\ nil)
  defp build_url(hostname, path, query) when query in [nil, ""], do: hostname <> path
  defp build_url(hostname, path, query), do: hostname <> path <> "?" <> query

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

    OAuther.sign(to_string(method), url, map_to_tuples.(params), oauther_creds)
    |> OAuther.header
  end
end

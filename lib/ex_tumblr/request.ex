defmodule ExTumblr.Request do
  defstruct [:method, :url, :headers, :body]

  @spec sign_request(atom, String.t, Credentials.t, Keyword.t) :: {tuple(String.t), Keyword.t}
  defp sign_request_with_oauth(method, url, credentials, params) do
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

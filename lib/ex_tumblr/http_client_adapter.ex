defmodule ExTumblr.HTTPClientBehaviour do
  @callback request(method :: atom, url :: String.t , body :: String.t, headers :: Keyword.t) :: any
end

defmodule ExTumblr.HTTPoisonAdapter do
  @behaviour ExTumblr.HTTPClientBehaviour

  require Logger

  def request(method, url, body, headers) do
    Logger.debug "Sending request #{method}, #{url}, #{body}, #{headers}"
    HTTPoison.request(method, url, body || "", headers || [])
  end
end

defmodule ExTumblr.HTTPSpyAdapter do
  @behaviour ExTumblr.HTTPClientBehaviour

  def request(method, url, body, headers) do
    send self, {method, url, body, headers}
  end
end

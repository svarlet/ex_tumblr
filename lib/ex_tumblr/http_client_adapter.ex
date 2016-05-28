defmodule ExTumblr.HTTPoisonAdapter do
  def request(method, url, body, headers) do
    HTTPoison.request(method, url, body || "", headers || [])
  end
end

defmodule ExTumblr.HTTPSpyAdapter do
  def request(method, url, body, headers) do
    send self, {method, url, body, headers}
  end
end

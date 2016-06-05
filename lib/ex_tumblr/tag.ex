defmodule ExTumblr.Tag do
  @hostname "https://api.tumblr.com"

  def tagged(credentials, params) do
    {:get, "#{@hostname}/v2/tagged", params, :api_key_auth, credentials}
  end
end

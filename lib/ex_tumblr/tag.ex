defmodule ExTumblr.Tag do
  def tagged(credentials, params) do
    {:get, "#{@hostname}/v2/tagged", params, :api_key_auth, credentials}
  end
end

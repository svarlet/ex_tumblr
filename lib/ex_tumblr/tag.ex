defmodule ExTumblr.Tag do
  def tagged do
    {:get, "/v2/tagged", :api_key_auth}
  end
end

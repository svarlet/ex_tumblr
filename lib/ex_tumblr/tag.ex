defmodule ExTumblr.Tag do
  @hostname "https://api.tumblr.com"

  def tagged do
    {:get, "#{@hostname}/v2/tagged", :api_key_auth}
  end
end

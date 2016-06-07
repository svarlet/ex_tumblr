defmodule ExTumblr.Tag do
  @hostname Application.get_env :ex_tumblr, :endpoint

  def tagged do
    {:get, "#{@hostname}/v2/tagged", :api_key_auth}
  end
end

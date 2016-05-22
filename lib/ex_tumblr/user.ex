defmodule ExTumblr.User do
  @hostname Application.get_env :ex_tumblr, :hostname

  def info(credentials, params) do
    {:get, "#{@hostname}/v2/user/info", params, :oauth, credentials}
  end

  def dashboard(credentials, params) do
    {:get, "#{@hostname}/v2/user/dashboard", params, :oauth, credentials}
  end

  def likes(credentials, params) do
    {:get, "#{@hostname}/v2/user/likes", params, :oauth, credentials}
  end

  def following(credentials, params) do
    {:get, "#{@hostname}/v2/user/following", params, :oauth, credentials}
  end
end

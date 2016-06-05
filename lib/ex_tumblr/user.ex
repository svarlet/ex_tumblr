defmodule ExTumblr.User do
  @hostname "https://api.tumblr.com"

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

  def follow(credentials, params) do
    {:post, "#{@hostname}/v2/user/follow", params, :oauth, credentials}
  end

  def unfollow(credentials, params) do
    {:post, "#{@hostname}/v2/user/unfollow", params, :oauth, credentials}
  end

  def like(credentials, params) do
    {:post, "#{@hostname}/v2/user/like", params, :oauth, credentials}
  end

  def unlike(credentials, params) do
    {:post, "#{@hostname}/v2/user/unlike", params, :oauth, credentials}
  end
end

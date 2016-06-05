defmodule ExTumblr.User do
  @hostname "https://api.tumblr.com"

  def info do
    {:get, "#{@hostname}/v2/user/info", :oauth}
  end

  def dashboard do
    {:get, "#{@hostname}/v2/user/dashboard", :oauth}
  end

  def likes do
    {:get, "#{@hostname}/v2/user/likes", :oauth}
  end

  def following do
    {:get, "#{@hostname}/v2/user/following", :oauth}
  end

  def follow do
    {:post, "#{@hostname}/v2/user/follow", :oauth}
  end

  def unfollow do
    {:post, "#{@hostname}/v2/user/unfollow", :oauth}
  end

  def like do
    {:post, "#{@hostname}/v2/user/like", :oauth}
  end

  def unlike do
    {:post, "#{@hostname}/v2/user/unlike", :oauth}
  end
end

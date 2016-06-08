defmodule ExTumblr.User do
  def info do
    {:get, "/v2/user/info", :oauth}
  end

  def dashboard do
    {:get, "/v2/user/dashboard", :oauth}
  end

  def likes do
    {:get, "/v2/user/likes", :oauth}
  end

  def following do
    {:get, "/v2/user/following", :oauth}
  end

  def follow do
    {:post, "/v2/user/follow", :oauth}
  end

  def unfollow do
    {:post, "/v2/user/unfollow", :oauth}
  end

  def like do
    {:post, "/v2/user/like", :oauth}
  end

  def unlike do
    {:post, "/v2/user/unlike", :oauth}
  end
end

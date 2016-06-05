defmodule ExTumblr.UserTest do
  use ExUnit.Case, async: true

  alias ExTumblr.User

  test "info/2 creates a valid request" do
    {:get, "https://api.tumblr.com/v2/user/info", :oauth} = User.info
  end

  test "dashboard/2 creates a valid request" do
    {:get, "https://api.tumblr.com/v2/user/dashboard", :oauth} = User.dashboard
  end

  test "likes/2 creates a valid request" do
    {:get, "https://api.tumblr.com/v2/user/likes", :oauth} = User.likes
  end

  test "following/2 creates a valid request" do
    {:get, "https://api.tumblr.com/v2/user/following", :oauth} = User.following
  end

  test "follow/2 creates a valid request" do
    {:post, "https://api.tumblr.com/v2/user/follow", :oauth} = User.follow
  end

  test "unfollow/2 creates a valid request" do
    {:post, "https://api.tumblr.com/v2/user/unfollow", :oauth} = User.unfollow
  end

  test "like/2 creates a valid request" do
    {:post, "https://api.tumblr.com/v2/user/like", :oauth} = User.like
  end

  test "unlike/2 creates a valid request" do
    {:post, "https://api.tumblr.com/v2/user/unlike", :oauth} = User.unlike
  end
end

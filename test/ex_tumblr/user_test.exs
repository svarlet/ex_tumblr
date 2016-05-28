defmodule ExTumblr.UserTest do
  use ExUnit.Case, async: true

  alias ExTumblr.User

  setup do
    {:ok, params: %{dummy: "param"}, credentials: %{consumer_key: "ck", consumer_secret: "cs", token: "t", token_key: "tk"}}
  end

  test "info/2 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/user/info", ^params, :oauth, ^credentials} = User.info(credentials, params)
  end

  test "dashboard/2 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/user/dashboard", ^params, :oauth, ^credentials} = User.dashboard(credentials, params)
  end

  test "likes/2 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/user/likes", ^params, :oauth, ^credentials} = User.likes(credentials, params)
  end

  test "following/2 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/user/following", ^params, :oauth, ^credentials} = User.following(credentials, params)
  end
end

defmodule ExTumblr.BlogTest do
  use ExUnit.Case, async: true

  alias ExTumblr.Blog

  setup do
    {:ok, credentials: %{consumer_key: "ck", consumer_secret: "cs", token: "t", token_secret: "ts"}, params: %{dummy: "dummy"}}
  end

  test "info/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/info", ^params, :api_key_auth, ^credentials} = Blog.info("gunkatana.tumblr.com", credentials, params)
  end

  test "avatar/2 creates a valid request" do
    assert {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/avatar/48", nil, :no_auth, nil} = Blog.avatar("gunkatana.tumblr.com", 48)
  end

  test "followers/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/followers", ^params, :oauth, ^credentials} = Blog.followers("gunkatana.tumblr.com", credentials, params)
  end

  test "likes/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/likes", ^params, :api_key_auth, ^credentials} = Blog.likes("gunkatana.tumblr.com", credentials, params)
  end

  test "posts/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts", ^params, :api_key_auth, ^credentials} = Blog.posts("gunkatana.tumblr.com", credentials, params)
  end

  test "queued_posts/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts/queue", ^params, :oauth, ^credentials} = Blog.queued_posts("gunkatana.tumblr.com", credentials, params)
  end

  test "drafts/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts/drafts", ^params, :oauth, ^credentials} = Blog.drafts("gunkatana.tumblr.com", credentials, params)
  end

  test "submission/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts/submission", ^params, :oauth, ^credentials} = Blog.submission("gunkatana.tumblr.com", credentials, params)
  end

  test "create/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post", ^params, :oauth, ^credentials} = Blog.create("gunkatana.tumblr.com", credentials, params)
  end

  test "edit/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post/edit", ^params, :oauth, ^credentials} = Blog.edit("gunkatana.tumblr.com", credentials, params)
  end

  test "reblog/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post/reblog", ^params, :oauth, ^credentials} = Blog.reblog("gunkatana.tumblr.com", credentials, params)
  end

  test "delete/3 creates a valid request", %{credentials: credentials, params: params} do
    assert {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post/delete", ^params, :oauth, ^credentials} = Blog.delete("gunkatana.tumblr.com", credentials, params)
  end





end

defmodule ExTumblr.BlogTest do
  use ExUnit.Case, async: true

  alias ExTumblr.Blog

  test "info" do
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/info", :api_key_auth} = Blog.create_info_request("gunkatana.tumblr.com")
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/info", :api_key_auth} = Blog.create_info_request("gunkatana")
  end

  test "avatar/2 creates a valid request" do
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/avatar/48", :no_auth} = Blog.create_avatar_request("gunkatana.tumblr.com", 48)
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/avatar/48", :no_auth} = Blog.create_avatar_request("gunkatana", 48)
  end

  test "followers" do
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/followers", :oauth} = Blog.create_followers_request("gunkatana.tumblr.com")
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/followers", :oauth} = Blog.create_followers_request("gunkatana")
  end

  test "likes" do
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/likes", :api_key_auth} = Blog.create_likes_request("gunkatana.tumblr.com")
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/likes", :api_key_auth} = Blog.create_likes_request("gunkatana")
  end

  test "posts" do
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts", :api_key_auth} = Blog.create_posts_request("gunkatana.tumblr.com")
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts", :api_key_auth} = Blog.create_posts_request("gunkatana")
  end

  test "queued_posts" do
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts/queue", :oauth} = Blog.create_queued_posts_request("gunkatana.tumblr.com")
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts/queue", :oauth} = Blog.create_queued_posts_request("gunkatana")
  end

  test "drafts" do
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts/drafts", :oauth} = Blog.create_drafts_request("gunkatana.tumblr.com")
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts/drafts", :oauth} = Blog.create_drafts_request("gunkatana")
  end

  test "submission" do
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts/submission", :oauth} = Blog.create_submission_request("gunkatana.tumblr.com")
    {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/posts/submission", :oauth} = Blog.create_submission_request("gunkatana")
  end

  test "post" do
    {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post", :oauth} = Blog.create_post_request("gunkatana.tumblr.com")
    {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post", :oauth} = Blog.create_post_request("gunkatana")
  end

  test "edit" do
    {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post/edit", :oauth} = Blog.create_edit_request("gunkatana.tumblr.com")
    {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post/edit", :oauth} = Blog.create_edit_request("gunkatana")
  end

  test "reblog" do
    {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post/reblog", :oauth} = Blog.create_reblog_request("gunkatana.tumblr.com")
    {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post/reblog", :oauth} = Blog.create_reblog_request("gunkatana")
  end

  test "delete" do
    {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post/delete", :oauth} = Blog.create_delete_request("gunkatana.tumblr.com")
    {:post, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/post/delete", :oauth} = Blog.create_delete_request("gunkatana")
  end
end

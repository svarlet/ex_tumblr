defmodule ExTumblr.BlogTest do
  use ExUnit.Case, async: true

  alias ExTumblr.Blog

  test "likes" do
    {:get, "/v2/blog/gunkatana.tumblr.com/likes", :api_key_auth} = Blog.create_likes_request("gunkatana.tumblr.com")
  end

  test "queued_posts" do
    {:get, "/v2/blog/gunkatana.tumblr.com/posts/queue", :oauth} = Blog.create_queued_posts_request("gunkatana.tumblr.com")
  end

  test "drafts" do
    {:get, "/v2/blog/gunkatana.tumblr.com/posts/drafts", :oauth} = Blog.create_drafts_request("gunkatana.tumblr.com")
  end

  test "submission" do
    {:get, "/v2/blog/gunkatana.tumblr.com/posts/submission", :oauth} = Blog.create_submission_request("gunkatana.tumblr.com")
  end

  test "post" do
    {:post, "/v2/blog/gunkatana.tumblr.com/post", :oauth} = Blog.create_post_request("gunkatana.tumblr.com")
  end

  test "edit" do
    {:post, "/v2/blog/gunkatana.tumblr.com/post/edit", :oauth} = Blog.create_edit_request("gunkatana.tumblr.com")
  end

  test "reblog" do
    {:post, "/v2/blog/gunkatana.tumblr.com/post/reblog", :oauth} = Blog.create_reblog_request("gunkatana.tumblr.com")
  end

  test "delete" do
    {:post, "/v2/blog/gunkatana.tumblr.com/post/delete", :oauth} = Blog.create_delete_request("gunkatana.tumblr.com")
  end
end

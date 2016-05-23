defmodule ExTumblr.Blog do
  @hostname Application.get_env :ex_tumblr, :hostname

  def create_info_request(blog_identifier) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/info", :api_key_auth}
  end

  def create_avatar_request(blog_identifier, size) when size in [16, 24, 30, 40, 48, 64, 96, 128, 512] do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/avatar/#{size}", :no_auth}
  end

  def create_followers_request(blog_identifier) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/followers", :oauth}
  end

  def create_likes_request(blog_identifier) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/likes", :api_key_auth}
  end

  def create_posts_request(blog_identifier) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/posts", :api_key_auth}
  end

  def create_queued_posts_request(blog_identifier) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/posts/queue", :oauth}
  end

  def create_drafts_request(blog_identifier) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/posts/drafts", :oauth}
  end

  def create_submission_request(blog_identifier) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/posts/submission", :oauth}
  end

  def create_create_request(blog_identifier) do
    {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post", :oauth}
  end

  def create_edit_request(blog_identifier) do
    {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post/edit", :oauth}
  end

  def create_reblog_request(blog_identifier) do
    {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post/reblog", :oauth}
  end

  def create_delete_request(blog_identifier) do
    {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post/delete", :oauth}
  end
end

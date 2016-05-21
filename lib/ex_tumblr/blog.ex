defmodule ExTumblr.Blog do
  @hostname Application.get_env :ex_tumblr, :hostname

  def info(blog_identifier, credentials, params) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/info", params, :api_key_auth, credentials}
  end

  def avatar(blog_identifier, params) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/avatar", params, :no_auth, nil}
  end

  def followers(blog_identifier, credentials, params) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/followers", params, :oauth, credentials}
  end

  def likes(blog_identifier, credentials, params) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/likes", params, :api_key_auth, credentials}
  end

  def posts(blog_identifier, credentials, params) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/posts", params, :api_key_auth, credentials}
  end

  def queued_posts(blog_identifier, credentials, params) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/posts/queue", params, :oauth, credentials}
  end

  def drafts(blog_identifier, credentials, params) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/posts/drafts", params, :oauth, credentials}
  end

  def submission(blog_identifier, credentials, params) do
    {:get, "#{@hostname}/v2/blog/#{blog_identifier}/posts/submission", params, :oauth, credentials}
  end

  def create(blog_identifier, credentials, params) do
    {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post", params, :oauth, credentials}
  end

  def edit(blog_identifier, credentials, params) do
    {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post/edit", params, :oauth, credentials}
  end

  def reblog(blog_identifier, credentials, params) do
    {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post/reblog", params, :oauth, credentials}
  end

  def delete(blog_identifier, credentials, params) do
    {:post, "#{@hostname}/v2/blog/#{blog_identifier}/post/delete", params, :oauth, credentials}
  end
end

defmodule ExTumblr.Blog do
  @moduledoc false

  @doc """
  Construct the url path for a blog endpoint.
  """
  @spec construct_url(String.t, String.t) :: String.t
  def construct_url(blog_identifier, endpoint) do
    "/v2/blog/#{blog_identifier}/#{endpoint}"
  end

  def create_followers_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "followers"), :oauth}
  end

  def create_likes_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "likes"), :api_key_auth}
  end

  def create_posts_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "posts"), :api_key_auth}
  end

  def create_queued_posts_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "posts/queue"), :oauth}
  end

  def create_drafts_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "posts/drafts"), :oauth}
  end

  def create_submission_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "posts/submission"), :oauth}
  end

  def create_post_request(blog_identifier) do
    {:post, construct_url(blog_identifier, "post"), :oauth}
  end

  def create_edit_request(blog_identifier) do
    {:post, construct_url(blog_identifier, "post/edit"), :oauth}
  end

  def create_reblog_request(blog_identifier) do
    {:post, construct_url(blog_identifier, "post/reblog"), :oauth}
  end

  def create_delete_request(blog_identifier) do
    {:post, construct_url(blog_identifier, "post/delete"), :oauth}
  end
end

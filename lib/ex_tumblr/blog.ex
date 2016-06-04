defmodule ExTumblr.Blog do
  @moduledoc false

  @hostname "https://api.tumblr.com"

  @type blog_identifier :: String.t
  @type auth :: :oauth | :api_key_auth | :no_auth
  @type method :: :get | :post
  @type url :: String.t
  @type base_request :: {method, url, auth}

  @spec create_info_request(blog_identifier) :: base_request
  def create_info_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "info"), :api_key_auth}
  end

  @spec construct_url(String.t, String.t) :: String.t
  defp construct_url(blog_identifier, endpoint) do
    b_id =
      blog_identifier
      |> normalize_blog_identifier
    "#{@hostname}/v2/blog/#{b_id}/#{endpoint}"
  end

  @spec normalize_blog_identifier(String.t) :: String.t
  defp normalize_blog_identifier(blog_identifier) do
    if String.match? blog_identifier, ~r/\.tumblr\.com/ do
      blog_identifier
    else
      blog_identifier <> ".tumblr.com"
    end
  end

  @spec create_avatar_request(String.t, 16 | 24 | 30 | 40 | 48 | 64 | 96 | 128 | 512) :: base_request
  def create_avatar_request(blog_identifier, size) when size in [16, 24, 30, 40, 48, 64, 96, 128, 512] do
    {:get, construct_url(blog_identifier, "avatar/#{size}"), :no_auth}
  end

  @spec create_followers_request(String.t) :: base_request
  def create_followers_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "followers"), :oauth}
  end

  @spec create_likes_request(String.t) :: base_request
  def create_likes_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "likes"), :api_key_auth}
  end

  @spec create_posts_request(String.t) :: base_request
  def create_posts_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "posts"), :api_key_auth}
  end

  @spec create_queued_posts_request(String.t) :: base_request
  def create_queued_posts_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "posts/queue"), :oauth}
  end

  @spec create_drafts_request(String.t) :: base_request
  def create_drafts_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "posts/drafts"), :oauth}
  end

  @spec create_submission_request(String.t) :: base_request
  def create_submission_request(blog_identifier) do
    {:get, construct_url(blog_identifier, "posts/submission"), :oauth}
  end

  @spec create_post_request(String.t) :: base_request
  def create_post_request(blog_identifier) do
    {:post, construct_url(blog_identifier, "post"), :oauth}
  end

  @spec create_edit_request(String.t) :: base_request
  def create_edit_request(blog_identifier) do
    {:post, construct_url(blog_identifier, "post/edit"), :oauth}
  end

  @spec create_reblog_request(String.t) :: base_request
  def create_reblog_request(blog_identifier) do
    {:post, construct_url(blog_identifier, "post/reblog"), :oauth}
  end

  @spec create_delete_request(String.t) :: base_request
  def create_delete_request(blog_identifier) do
    {:post, construct_url(blog_identifier, "post/delete"), :oauth}
  end
end

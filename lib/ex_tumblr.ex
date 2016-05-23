defmodule ExTumblr do
  defmodule Credentials do
    defstruct consumer_key: nil, consumer_secret: nil, token: nil, token_secret: nil
  end

  alias ExTumblr.{Blog, Request}

  def blog_info(blog_identifier, credentials, params) do
    blog_identifier
    |> Blog.create_info_request
    |> Request.prepare_request_auth(credentials, params)
  end

  def blog_avatar(blog_identifier, size \\ 64) do
    blog_identifier
    |> Blog.create_avatar_request(size)
    |> Request.prepare_request_auth(nil, nil)
  end

  def blog_followers(blog_identifier, credentials, params) do
    blog_identifier
    |> Blog.create_followers_request
    |> Request.prepare_request_auth(credentials, params)
  end
end

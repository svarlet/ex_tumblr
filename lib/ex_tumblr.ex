defmodule ExTumblr do
  @moduledoc """
  Provides functions to query the various endpoints of the Tumblr API.

  See https://www.tumblr.com/docs/en/api/v2
  """
  alias ExTumblr.{Blog, Request, HTTPResponseParser}

  def blog_info(blog_identifier, credentials, params) do
    blog_identifier
    |> Blog.create_info_request
    |> Request.prepare_request_auth(credentials, params)
    |> emit
  end

  def blog_avatar(blog_identifier, size \\ 64) do
    blog_identifier
    |> Blog.create_avatar_request(size)
    |> Request.prepare_request_auth(nil, nil)
    |> emit
    |> process_response
  end

  def blog_followers(blog_identifier, credentials, params) do
    blog_identifier
    |> Blog.create_followers_request
    |> Request.prepare_request_auth(credentials, params)
    |> emit
    |> process_response
  end

  def blog_likes(blog_identifier, credentials, params) do
    blog_identifier
    |> Blog.create_likes_request
    |> Request.prepare_request_auth(credentials, params)
    |> emit
    |> process_response
  end

  def blog_posts(blog_identifier, credentials, params) do
    blog_identifier
    |> Blog.create_posts_request
    |> Request.prepare_request_auth(credentials, params)
    |> emit
    |> process_response
  end

  defp emit({method, url, body, headers}) do
    adapter = Application.get_env :ex_tumblr, :http_client
    Kernel.apply(adapter, :request, [method, url, body, headers])
  end

  defp process_response({_, response}), do: HTTPResponseParser.parse response
  defp process_response(anything), do: HTTPResponseParser.parse anything
end

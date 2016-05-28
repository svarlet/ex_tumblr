defmodule ExTumblr do
  alias ExTumblr.{Blog, Request}

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
  end

  def blog_followers(blog_identifier, credentials, params) do
    blog_identifier
    |> Blog.create_followers_request
    |> Request.prepare_request_auth(credentials, params)
    |> emit
  end

  defp emit({method, url, body, headers}) do
    adapter = Application.get_env :ex_tumblr, :http_client
    Kernel.apply(adapter, :request, [method, url, body, headers])
  end

end

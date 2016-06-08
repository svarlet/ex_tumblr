defmodule ExTumblr do
  require Logger

  @moduledoc """
  Provides functions to query the various endpoints of the Tumblr API.

  See https://www.tumblr.com/docs/en/api/v2
  """
  alias ExTumblr.{Blog, Request, HTTPResponseParser}

  def avatar(blog_identifier, size \\ 64) do
    blog_identifier
    |> Blog.create_avatar_request(size)
    |> Request.prepare_request_auth(nil, nil)
    |> emit
  end

  defp emit({method, endpoint, body, headers}) do
    url = hostname <> endpoint
    Logger.info "Sending #{method} request to #{url}"
    HTTPoison.request(method, url, body || "", headers || [])
  end

  defp hostname do
    Application.get_env(:ex_tumblr, :hostname) || "https://api.tumblr.com"
  end

  [{"info", &Blog.create_info_request/1},
   {"followers", &Blog.create_followers_request/1},
   {"likes", &Blog.create_likes_request/1},
   {"posts", &Blog.create_posts_request/1},
   {"queued", &Blog.create_queued_posts_request/1},
   {"drafts", &Blog.create_drafts_request/1},
   {"submissions", &Blog.create_drafts_request/1},
   {"post", &Blog.create_post_request/1},
   {"edit", &Blog.create_edit_request/1},
   {"reblog", &Blog.create_reblog_request/1},
   {"delete", &Blog.create_delete_request/1}
  ]
  |> Enum.each(
       fn {name, init_fun} ->
         @spec unquote(String.to_atom(name))(String.t, ExTumblr.Credentials.t, map) :: HTTPResponseParser.result | HTTPResponseParser.error
         def unquote(String.to_atom(name))(blog_identifier, credentials, params) do
           blog_identifier
           |> unquote(init_fun).()
           |> Request.prepare_request_auth(credentials, params)
           |> emit
         end
       end)
end

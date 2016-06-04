defmodule ExTumblr do
  @moduledoc """
  Provides functions to query the various endpoints of the Tumblr API.

  See https://www.tumblr.com/docs/en/api/v2
  """
  alias ExTumblr.{Blog, Request, HTTPResponseParser}

  def blog_avatar(blog_identifier, size \\ 64) do
    blog_identifier
    |> Blog.create_avatar_request(size)
    |> Request.prepare_request_auth(nil, nil)
    |> emit
    |> process_response
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
         def unquote(String.to_atom(name))(blog_identifier, credentials, params) do
           blog_identifier
           |> unquote(init_fun).()
           |> Request.prepare_request_auth(credentials, params)
           |> emit
           |> process_response
         end
       end)

  defp emit({method, url, body, headers}) do
    adapter = Application.get_env :ex_tumblr, :http_client
    Kernel.apply(adapter, :request, [method, url, body, headers])
  end

  defp process_response({_, response}), do: HTTPResponseParser.parse response
  defp process_response(anything), do: HTTPResponseParser.parse anything
end

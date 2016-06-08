defmodule ExTumblr do
  require Logger

  alias ExTumblr.{Blog, Auth}

  @moduledoc """
  Provides functions to query the various endpoints of the Tumblr API.

  See https://www.tumblr.com/docs/en/api/v2
  """

  # [
  #  {"likes", &Blog.create_likes_request/1},
  #  {"posts", &Blog.create_posts_request/1},
  #  {"queued", &Blog.create_queued_posts_request/1},
  #  {"drafts", &Blog.create_drafts_request/1},
  #  {"submissions", &Blog.create_drafts_request/1},
  #  {"post", &Blog.create_post_request/1},
  #  {"edit", &Blog.create_edit_request/1},
  #  {"reblog", &Blog.create_reblog_request/1},
  #  {"delete", &Blog.create_delete_request/1}
  # ]
  # |> Enum.each(
  #      fn {name, init_fun} ->
  #        @spec unquote(String.to_atom(name))(String.t, ExTumblr.Credentials.t, map) :: HTTPResponseParser.result | HTTPResponseParser.error
  #        def unquote(String.to_atom(name))(blog_identifier, credentials, params) do
  #          blog_identifier
  #          |> unquote(init_fun).()
  #          |> Auth.sign(credentials, params)
  #          |> emit
  #        end
  #      end)
end

defmodule ExTumblr.Avatar do
  use ExTumblr.Transport

  @moduledoc """
  Provide a function to request the avatar url of a blog.
  """

  @type avatar_size :: 16 | 24 | 30 | 40 | 48 | 64 | 96 | 128 | 512

  alias ExTumblr.{Client, Blog, Auth}

  @doc """
  Request the url of the avatar of a blog.

  [Official documentation](https://www.tumblr.com/docs/en/api/v2#blog-avatar)
  """
  @spec request(Client.t, String.t, avatar_size) :: String.t
  def request(client, blog_identifier, size \\ 64) do
    blog_identifier
    |> create_avatar_request(size)
    |> Auth.sign(client, nil)
    |> emit
    |> parse
  end

  @spec parse({atom, HTTPoison.Response.t}) :: String.t
  defp parse({:ok, %HTTPoison.Response{body: body}}) do
    body
    |> URI.decode_query
    |> Map.get("avatar_url")
  end

  @spec create_avatar_request(String.t, avatar_size) :: tuple
  defp create_avatar_request(blog_identifier, size) when size in [16, 24, 30, 40, 48, 64, 96, 128, 512] do
    {:get, Blog.path_for(blog_identifier, "avatar/#{size}"), :no_auth}
  end
end

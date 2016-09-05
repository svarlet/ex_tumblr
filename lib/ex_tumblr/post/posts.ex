defmodule ExTumblr.Post.Posts do
  @moduledoc """
  Types and functions to retrieves blog posts.
  [Official documentation](https://www.tumblr.com/docs/en/api/v2#posts)
  """

  use ExTumblr.Transport

  alias ExTumblr.Post.PostParser
  alias ExTumblr.{Blog, Info, Client, Auth}

  @typedoc """
  A struct to represent the response content from the posts endpoint.
  [Official documentation](https://www.tumblr.com/docs/en/api/v2#posts)
  """
  @type t :: %__MODULE__{
    blog:        Info.t,
    posts:       [any],
    total_posts: non_neg_integer
  }

  defstruct [:blog, :posts, :total_posts]

  @spec request(Client.t, String.t, map) :: t
  def request(client, blog_identifier, params) do
    blog_identifier
    |> create_posts_request
    |> Auth.sign(client, params)
    |> emit
    |> parse
  end

  defp create_posts_request(blog_identifier) do
    {:get, Blog.path_for(blog_identifier, "posts"), :api_key_auth}
  end

  defp parse({:ok, %HTTPoison.Response{body: body}}) do
    response =
      body
      |> Poison.decode!
      |> Map.get("response")

    %__MODULE__{
      blog:        Info.to_struct(response["blog"]),
      posts:       Enum.map(response["posts"], &PostParser.parse/1),
      total_posts: response["total_posts"]
    }
  end
end

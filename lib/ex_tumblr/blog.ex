defmodule ExTumblr.Blog do
  alias ExTumblr.Blog

  @typedoc """
  Represents the properties of a call to the Blog info endpoint.

  More info at https://www.tumblr.com/docs/en/api/v2#blog-info
  """
  @type t :: %Blog{
    title: String.t,
    posts: non_neg_integer,
    name: String.t,
    updated: non_neg_integer,
    description: String.t,
    ask: boolean,
    ask_anon: boolean,
    likes: non_neg_integer,
    is_blocked_from_primary: boolean
  }

  defstruct title: nil,
    posts: 0,
    name: nil,
    updated: 0,
    description: nil,
    ask: false,
    ask_anon: false,
    likes: 0,
    is_blocked_from_primary: false

  @api_key Application.get_env :ex_tumblr, :api_key

  @doc """
  Requests general information about the specified blog such as the title,
  number of posts and other high-level data.

  ## Examples

      iex> ExTumblr.Blog.info "gunkatana"
      "FIXME"

  """
  def info(blog_identifier) do
    "/blog/#{blog_identifier}.tumblr.com/info?api_key=#{@api_key}"
    |> ExTumblr.get!
    |> extract_blog_info
  end

  defp property(map, property) do
    case Map.fetch map, property do
      {:ok, value} -> {:ok, value}
      :error -> {:error, "The #{property} key does not exist."}
    end
  end

  defp extract_blog_info(http_response) do
    with({:ok, body} <- property(http_response, :body),
      {:ok, response} <- property(body, "response"),
      {:ok, blog_info} <- property(response, "blog"),
      do: from_map(blog_info))
  end

  defp from_map(blog_info) do
    read = fn field, default -> Map.get(blog_info, field, default) end
    %Blog{
      title: read.("title", nil),
      posts: read.("posts", 0),
      name: read.("name", nil),
      updated: read.("updated", 0),
      description: read.("description", nil),
      ask: read.("ask", false),
      ask_anon: read.("ask_anon", false),
      likes: read.("likes", 0),
      is_blocked_from_primary: read.("is_blocked_from_primary", false)
    }
  end
end

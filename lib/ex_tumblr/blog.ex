defmodule ExTumblr.Blog do
  alias ExTumblr.Blog

  import ExTumblr.Utils, only: [property: 2]

  @tumblr_connector Application.get_env(:ex_tumblr, :ex_tumblr_connector)

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

  @doc """
  Requests general information about the specified blog such as the title,
  number of posts and other high-level data.

  ## Examples

      iex> ExTumblr.Blog.info "gunkatana", "api-key"
      "FIXME: http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/"
  """
  def info(blog_identifier, api_key) do
    "/blog/#{blog_identifier}.tumblr.com/info?api_key=#{api_key}"
    |> @tumblr_connector.get!
    |> extract_blog_info
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

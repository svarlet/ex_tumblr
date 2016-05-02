defmodule ExTumblr.Blog do
  alias ExTumblr.Blog

  import ExTumblr.Utils, only: [property: 2]

  @http_client Application.get_env(:ex_tumblr, :http_client)

  @hostname Application.get_env(:ex_tumblr, :hostname)

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

      iex> {:ok, info} = ExTumblr.Blog.info "gunkatana", "api-key"
      iex> info
      %ExTumblr.Blog{
        title: "Gunkatana",
        name: "gunkatana",
        posts: 13,
        updated: 1455328457,
        description: "a cool description",
        ask: false,
        ask_anon: false,
        likes: 0,
        is_blocked_from_primary: false
      }
  """
  @spec info(String.t, String.t) :: {:ok, t} | {:error, String.t}
  def info(blog_identifier, api_key) do
    "/blog/#{blog_identifier}.tumblr.com/info?api_key=#{api_key}"
    |> @http_client.get!
    |> extract_blog_info
  end

  def build_request(nil, _), do: {:error, "Nil is not a valid blog identifier."}
  def build_request(_, nil), do: {:error, "Nil is not a valid api key."}
  def build_request(blog_identifier, api_key) do
    request = %URI{
      host: @hostname,
      path: path_for(blog_identifier),
      query: URI.encode_query(%{api_key: api_key})
    }
    |> URI.to_string
  end

  def do_request do
    
  end

  @spec extract_blog_info(map) :: {:ok, t} | {:error, String.t}
  defp extract_blog_info(http_response) do
    with({:ok, body} <- property(http_response, :body),
      {:ok, response} <- property(body, "response"),
      {:ok, blog_info} <- property(response, "blog"),
      do: {:ok, from_map(blog_info)})
  end

  @spec from_map(map) :: t
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

  defimpl Inspect do
    def inspect(dict, _opts) do
      """
      %ExTumblr.Blog{
        title: #{dict.title},
        name: #{dict.name},
        posts: #{dict.posts},
        updated: #{dict.updated},
        description: #{dict.description},
        ask: #{dict.ask},
        ask_anon: #{dict.ask_anon},
        likes: #{dict.likes},
        is_blocked_from_primary: #{dict.is_blocked_from_primary}
      }
      """
    end
  end
end

defmodule ExTumblr.Blog do
  alias ExTumblr.{Blog, Validator}

  import ExTumblr.Utils, only: [property: 2, blank?: 1]

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

      iex> api_key = System.get_env "TUMBLR_API_KEY"
      iex> {:ok, info} = ExTumblr.Blog.info "gunkatana.tumblr.com", api_key
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
    with(
      {:ok, valid_blog_identifier} <- Validator.validate_blog_identifier(blog_identifier),
      {:ok, valid_api_key} <- Validator.validate_api_key(api_key),
    do:
      valid_blog_identifier
      |> build_request(valid_api_key)
      |> send_request
      |> parse_response
    )
  end

  defp build_request(blog_identifier, api_key) do
    @hostname
    |> URI.parse
    |> Map.put(:path, path_for(blog_identifier))
    |> Map.put(:query, URI.encode_query(%{api_key: api_key}))
    |> URI.to_string
  end

  defp path_for(blog_identifier) do
    "/v2/blog/#{blog_identifier}/info"
  end

  @spec send_request(String.t, fun()) :: {:ok, HTTPoison.Response.t} | {:error, HTTPoison.Error.t}
  def send_request(request, http_get_client \\ &HTTPoison.get/1) do
    request
    |> http_get_client.()
  end

  @spec parse_response({:ok, map}) :: {:ok, t} | {:error, String.t}
  defp parse_response({:ok, http_response}) do
    with(
      {:ok, body} <- Poison.decode(http_response.body),
      {:ok, response} <- property(body, "response"),
      {:ok, blog_info} <- property(response, "blog"),
    do:
      {:ok, from_map(blog_info)}
    )
  end

  defp parse_response(http_error) do
    http_error
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

  def avatar(blog_identifier, size) when size in [16, 24, 30, 40, 48, 64, 96, 128, 512] do
    with(
      {:ok, valid_blog_identifier} <- Validator.validate_blog_identifier(blog_identifier),
    do:
      @hostname
      |> URI.parse
      |> Map.put(:path, build_path([blog_identifier, "avatar", size]))
    )
  end

  def build_path(path_elements) do
    case path_elements do
      nil -> ""
      [] -> ""
      _ -> path_elements
           |> Enum.reduce("/", &Kernel.<>(&2, &1))
    end
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

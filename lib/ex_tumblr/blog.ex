defmodule ExTumblr.Blog do
  alias ExTumblr.Blog

  import ExTumblr.Utils, only: [property: 2]

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
      {:ok, valid_blog_identifier} <- validate_blog_identifier(blog_identifier),
      {:ok, valid_api_key} <- validate_api_key(api_key),
    do:
      build_request(valid_blog_identifier, valid_api_key)
      |> send_request
      |> parse_response
    )
  end

  def blank?(string), do: Regex.match? ~r/^\s*$/, string

  defp validate_blog_identifier(blog_identifier) do
    cond do
      is_nil blog_identifier -> {:error, "Nil is not a valid blog identifier."}
      blank? blog_identifier -> {:error, "A blog identifier cannot be blank."}
      true -> {:ok, blog_identifier}
    end
  end

  defp validate_api_key(api_key) do
    cond do
      is_nil api_key -> {:error, "Nil is not a valid api key."}
      blank? api_key -> {:error, "An api key cannot be blank."}
      true -> {:ok, api_key}
    end
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

  @spec send_request(String.t) :: {:ok, HTTPoison.Response.t} | {:error, HTTPoison.Error.t}
  defp send_request(request) do
    request
    |> HTTPoison.get
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

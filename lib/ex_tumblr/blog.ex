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


  @doc """
  Requests general information about the specified blog such as the title,
  number of posts and other high-level data.

  ## Examples

      iex> ExTumblr.Blog.info "gunkatana"
      "FIXME"

  """
  def info(blog_identifier) do
    with({:ok, api_key} <- get_api_key,
         {:ok, http_response} <- ExTumblr.get("/blog/#{blog_identifier}.tumblr.com/info?api_key=#{api_key}"),
         {:ok, body} <- get_response_body(http_response),
         {:ok, blog_info} <- get_blog_info(body),
         do: from_map(blog_info))
  end

  defp get_api_key do
    case Application.get_env(:ex_tumblr, :api_key, "not defined") do
      "not defined" -> {:error, "Tumblr API key is not defined in the Application config."}
      value -> {:ok, value}
    end
  end

  defp get_response_body(%HTTPoison.Response{body: body}), do: {:ok, body}
  defp get_response_body(_), do: {:error, "Response does not contain a body field."}

  defp get_blog_info(%{"response" => %{"blog" => blog_info}}), do: {:ok, blog_info}
  defp get_blog_info(_), do: {:error, "Response body does not contain the expected `response` field."}

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

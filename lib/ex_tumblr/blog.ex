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
      FIXME

  """
  def info(blog_identifier) do
    api_key = Application.get_env(:ex_tumblr, :api_key)
    ExTumblr.get("/blog/#{blog_identifier}.tumblr.com/info?api_key=#{api_key}")
  end
end

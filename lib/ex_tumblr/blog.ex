defmodule ExTumblr.Blog do
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

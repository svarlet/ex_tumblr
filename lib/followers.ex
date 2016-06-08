defmodule ExTumblr.Followers do
  use ExTumblr.Transport

  alias ExTumblr.{Blog, Auth}

  @moduledoc """
  Provide functions to request data from the followers endpoint.
  """

  def request(blog_identifier, credentials, params) do
    blog_identifier
    |> create_followers_request
    |> Auth.sign
    |> emit
    |> parse
  end

  defp create_followers_request(blog_identifier) do
    {:get, Blog.construct_url(blog_identifier, "followers"), :oauth}
  end

  defp parse({:ok, %HTTPoison.Response{body: body}}) do
    
  end
end

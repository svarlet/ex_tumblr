defmodule ExTumblr.Follower do
  @typedoc """
  A map representing a blog follower.
  [Official documentation](https://www.tumblr.com/docs/en/api/v2#blog-followers)
  """
  @type t :: %__MODULE__{
    name: String.t,
    following: boolean,
    url: String.t,
    updated: non_neg_integer
  }

  defstruct name: nil,
    following: false,
    url: nil,
    updated: 0
end

defmodule ExTumblr.Followers do
  use ExTumblr.Transport

  alias ExTumblr.{Blog, Auth}

  @moduledoc """
  Provide a request function to query the followers endpoint.
  [Official documentation](https://www.tumblr.com/docs/en/api/v2#blog-followers)
  """

  @type t :: %__MODULE__{
    total_users: non_neg_integer,
    users: [ExTumblr.Follower.t]
  }

  defstruct total_users: 0, users: nil

  def request(blog_identifier, credentials, params) do
    blog_identifier
    |> create_followers_request
    |> Auth.sign(credentials, params)
    |> emit
    |> parse
  end

  @spec create_followers_request(String.t) :: tuple
  defp create_followers_request(blog_identifier) do
    {:get, Blog.construct_url(blog_identifier, "followers"), :oauth}
  end

  defp parse({:ok, %HTTPoison.Response{body: body}}) do
    nil
  end
end

defmodule ExTumblr.Follower do
  @moduledoc """
  Define a struct and functions to manage a blog follower.
  See [Official documentation](https://www.tumblr.com/docs/en/api/v2#blog-followers)
  about the followers endpoint.
  """

  @typedoc """
  A struct representing a blog follower.
  [Official documentation](https://www.tumblr.com/docs/en/api/v2#blog-followers)
  """
  @type t :: %__MODULE__{
    name:      String.t,
    following: boolean,
    url:       String.t,
    updated:   non_neg_integer
  }

  defstruct name: nil,
    following: false,
    url:       nil,
    updated:   0

  alias ExTumblr.Utils.Parsing

  @doc """
  Transform a map into a Follower struct.

  Keys must be strings, values can be any type.
  """
  @spec parse(%{String.t => any}) :: t
  def parse(raw_map) do
    Parsing.to_struct(raw_map, __MODULE__)
  end
end

defmodule ExTumblr.Followers do
  @moduledoc """
  Provide a request function to query the followers endpoint.
  [Official documentation](https://www.tumblr.com/docs/en/api/v2#blog-followers)
  """

  use ExTumblr.Transport

  alias ExTumblr.{Client, Blog, Auth, Follower}
  alias ExTumblr.Utils.Parsing

  @type t :: %__MODULE__{
    total_users: non_neg_integer,
    users:       [ExTumblr.Follower.t]
  }

  defstruct total_users: 0, users: nil

  @spec request(Client.t, String.t, map) :: t
  def request(client, blog_identifier, params) do
    blog_identifier
    |> create_followers_request
    |> Auth.sign(client, params)
    |> emit
    |> parse
  end

  @spec create_followers_request(String.t) :: tuple
  defp create_followers_request(blog_identifier) do
    {:get, Blog.path_for(blog_identifier, "followers"), :oauth}
  end

  defp parse({:ok, %HTTPoison.Response{body: body}}) do
    body
    |> Poison.decode!
    |> Map.get("response")
    |> Parsing.to_struct(__MODULE__)
    |> parse_each_follower
  end

  defp parse_each_follower(%__MODULE__{users: raw_users} = followers) do
    %__MODULE__{followers | users: Enum.map(raw_users, &Follower.parse/1)}
  end
end

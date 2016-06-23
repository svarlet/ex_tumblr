defmodule ExTumblr.Post do
  @moduledoc """
  Struct and functions to represent and manage a post.
  """

  @type t :: %__MODULE__{
    blog_name:    String.t,
    id:           non_neg_integer,
    post_url:     String.t,
    type:         String.t,
    timestamp:    non_neg_integer,
    date:         String.t,
    format:       String.t,
    reblog_key:   String.t,
    tags:         [String.t],
    bookmarklet:  boolean,
    mobile:       boolean,
    source_url:   String.t,
    source_title: String.t,
    liked:        boolean,
    state:        String.t,
    total_posts:  non_neg_integer
  }

  defstruct [:blog_name,
             :id,
             :post_url,
             :type,
             :timestamp,
             :date,
             :format,
             :reblog_key,
             :tags,
             :bookmarklet,
             :mobile,
             :source_url,
             :source_title,
             :liked,
             :state,
             :total_posts
            ]

  def parse(raw_post) do
    Parsing.to_struct(raw_post, __MODULE__, %__MODULE__{} |> Map.keys |> Enum.map(&to_string/1))
  end
end


defmodule ExTumblr.Posts do
  @moduledoc """
  Types and functions to retrieves blog posts.
  [Official documentation](https://www.tumblr.com/docs/en/api/v2#posts)
  """

  use ExTumblr.Transport

  alias ExTumblr.{Blog, Info, Post, Client, Auth}

  @typedoc """
  A struct to represent the response content from the posts endpoint.
  [Official documentation](https://www.tumblr.com/docs/en/api/v2#posts)
  """
  @type t :: %__MODULE__{
    blog:  Info.t,
    posts: [Post.t]
  }

  defstruct [:blog, :posts]

  @spec request(Client.t, String.t, map) :: t
  def request(client, blog_identifier, params) do
    blog_identifier
    |> create_posts_request
    |> Auth.sign(client, params)
    |> emit
    |> parse
  end

  defp create_posts_request(blog_identifier) do
    {:get, Blog.path_for(blog_identifier, "posts"), :api_key_auth}
  end

  defp parse({:ok, %HTTPoison.Response{body: body}}) do
    body
    |> Poison.decode!
    |> Map.get("response")
    |> Parsing.to_struct(__MODULE__, ~w(blog posts))
    |> parse_each_post
  end

  defp parse_each_post(%__MODULE__{posts: raw_posts} = posts) do
    %__MODULE__{posts | posts: Enum.map(raw_posts, &Post.parse/1)}
  end
end

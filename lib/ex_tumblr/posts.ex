defmodule ExTumblr.Post do
  @moduledoc """
  Struct and functions to represent and manage a post.
  """

  alias ExTumblr.Utils.Parsing

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
    source_url:   String.t, #MOVE TO QUOTE POSTS? see "Notes" column in docs
    source_title: String.t, #MOVE TO QUOTE POSTS?
    liked:        boolean,
    state:        String.t,
    #FOR TEXT POSTS
    title: String.t,
    body: String.t,
    #FOR PHOTO POSTS
    photos: [], #todo: list of photos objects
    caption: String.t,
    width: number(),
    height: number(),
    #FOR QUOTE POSTS
    text: String.t,
    source: String.t,
    #FOR LINK POSTS
    title: String.t, #fixme: already defined for text posts
    url: String.t,
    author: String.t,
    excerpt: String.t,
    publisher: String.t,
    photos: [], #fixme: also defined for photo posts
    description: String.t,
    #FOR CHAT POSTS
    title: String.t, #fixme: also defined for link and text posts
    body: String.t, #fixme: also defined for text posts
    dialogue: [], #todo: define a type for the contained objects
    #FOR AUDIO POSTS
    caption: String.t, #fixme: also defined for photo posts
    player: String.t,
    plays: non_neg_integer,
    album_art: String.t,
    artist: String.t,
    album: String.t,
    track_name: String.t,
    track_number: non_neg_integer,
    year: non_neg_integer,
    #FOR VIDEO POSTS
    caption: String.t, #fixme: also defined for audio and photo posts
    player: [], #fixme: also defined for audio posts AND IT'S A DIFFERENT TYPE!!!!
    #FOR ANSWERS POSTS
    asking_name: String.t,
    asking_url: String.t,
    question: String.t,
    answer: String.t
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
             # FOR TEXT POSTS
             :title,
             :body,
             #
            ]

  @doc """
  Transforms a %{String.t => any} into a Post struct.
  """
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
    posts: [Post.t],
    total_posts: non_neg_integer
  }

  defstruct [:blog, :posts, :total_posts]

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
    response =
      body
      |> Poison.decode!
      |> Map.get("response")

    %__MODULE__{
      blog: response
            |> Map.get("blog")
            |> Info.from_map,
      posts: response
             |> Map.get("posts")
             |> Enum.map(&Post.parse/1),
      total_posts: response
                   |> Map.get("total_posts")
    }
  end
end

defmodule ExTumblr.Info do
  use ExTumblr.Transport

  alias ExTumblr.{Client, Auth, Blog}
  alias ExTumblr.Utils.Parsing

  @moduledoc """
  Provide function and type definition for the blog info endpoint.
  """

  @type t :: %__MODULE__{
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
  Retrieve general information about the specified blog.

  [Official documentation](https://www.tumblr.com/docs/en/api/v2#blog-info)
  """
  @spec request(String.t, Client.t) :: t
  def request(client, blog_identifier) do
    blog_identifier
    |> create_info_request
    |> Auth.sign(client, nil)
    |> emit
    |> parse_http_response
  end

  @spec create_info_request(String.t) :: tuple
  defp create_info_request(blog_identifier) do
    {:get, Blog.path_for(blog_identifier, "info"), :api_key_auth}
  end

  defp parse_http_response({:ok, %HTTPoison.Response{body: body}}) do
    body
    |> Poison.decode!
    |> get_in(["response", "blog"])
    |> to_struct
  end

  @doc """
  Transform a generic map into an `Info` struct.
  """
  def to_struct(raw_map) do
    Parsing.to_struct(raw_map, __MODULE__)
  end
end

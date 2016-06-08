defmodule ExTumblr.Info do
  use ExTumblr.Transport

  alias ExTumblr.{Auth, Blog}
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
  @spec request(String.t, Credentials.t, map) :: t
  def request(blog_identifier, credentials, params) do
    blog_identifier
    |> create_info_request
    |> Auth.sign(credentials, params)
    |> emit
    |> parse
  end

  @spec create_info_request(String.t) :: tuple
  defp create_info_request(blog_identifier) do
    {:get, Blog.construct_url(blog_identifier, "info"), :api_key_auth}
  end

  @accepted_keys ~w(title posts name updated description ask ask_anon likes is_blocked_from_primary)

  defp parse({:ok, %HTTPoison.Response{body: body}}) do
    body
    |> Poison.decode!
    |> get_in(["response", "blog"])
    |> Parsing.to_struct(__MODULE__, @accepted_keys)
  end
end

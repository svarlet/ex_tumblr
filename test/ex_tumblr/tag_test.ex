defmodule ExTumblr.TagTest do
  use ExUnit.Case, async: true
  alias ExTumblr.{Credentials, Tag}

  test "tagged/2 creates a valid request" do
    params = %{tag: "lol"}
    credentials = %Credentials{}
    {:get "https://api.tumblr.com/v2/tagged", ^params, ^credentials} = Tag.tagged(credentials, params)
  end
end

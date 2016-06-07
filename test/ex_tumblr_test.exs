defmodule ExTumblrTest do
  use ExUnit.Case, async: true

  alias ExTumblr.Credentials

  setup do
    bypass = Bypass.open
    Application.put_env(:ex_tumblr, :endpoint, "http://localhost:#{bypass.port}")
    {:ok, bypass: bypass}
  end

  test "lol", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/avatar/48" == conn.request_path
    end
    {:ok, response} = ExTumblr.blog_avatar "gunkatana.tumblr.com", 48
  end
end

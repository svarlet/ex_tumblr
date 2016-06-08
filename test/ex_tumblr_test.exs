defmodule ExTumblrTest do
  use ExUnit.Case, async: true

  setup do
    bypass = Bypass.open
    Application.put_env(:ex_tumblr, :hostname, "http://localhost:#{bypass.port}")
    {:ok, bypass: bypass}
  end

  test "lol", %{bypass: bypass} do
    prebaked_response = "avatar_url=https://67.media.tumblr.com/avatar_34abdab07c47_48.png"
    Bypass.expect bypass, fn conn ->
      assert "/v2/blog/gunkatana.tumblr.com/avatar/48" == conn.request_path
      conn
      |> Plug.Conn.put_resp_header("status", "301 Moved Permanently")
      |> Plug.Conn.resp(200, prebaked_response)
    end
    {:ok, response} = ExTumblr.avatar "gunkatana.tumblr.com", 48
  end
end

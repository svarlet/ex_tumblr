defmodule ExTumblr.AvatarTest do
  use ShouldI, async: true

  setup context do
    bypass = Bypass.open
    Application.put_env(:ex_tumblr, :hostname, "http://localhost:#{bypass.port}")
    assign context, bypass: bypass
  end

  should "handle the particular response of the avatar endpoint", context do
    avatar_url = "https://67.media.tumblr.com/avatar_34abdab07c47_48.png"
    prebaked_response = "avatar_url=#{avatar_url}"
    Bypass.expect context.bypass, fn conn ->
      assert "/v2/blog/gunkatana.tumblr.com/avatar/48" == conn.request_path
      conn
      |> Plug.Conn.resp(200, prebaked_response)
    end
    assert avatar_url == ExTumblr.Avatar.request "gunkatana.tumblr.com", 48
  end
end

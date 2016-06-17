defmodule ExTumblr.AvatarTest do
  use ShouldI

  setup context do
    bypass = Bypass.open
    client = %ExTumblr.Client{hostname: "http://localhost:#{bypass.port}"}
    context
    |> assign(bypass: bypass)
    |> assign(client: client)
  end

  should "handle the particular response of the avatar endpoint", context do
    avatar_url = "https://67.media.tumblr.com/avatar_34abdab07c47_48.png"
    prebaked_response = "avatar_url=#{avatar_url}"
    Bypass.expect context.bypass, fn conn ->
      assert "/v2/blog/gunkatana.tumblr.com/avatar/48" == conn.request_path
      conn
      |> Plug.Conn.resp(200, prebaked_response)
    end
    assert avatar_url == ExTumblr.Avatar.request(context.client, "gunkatana.tumblr.com", 48)
  end
end

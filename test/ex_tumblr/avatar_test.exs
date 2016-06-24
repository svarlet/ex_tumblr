defmodule ExTumblr.AvatarTest do
  use ExUnit.Case, async: true

  defp set_bypass(_context) do
    {:ok, bypass: Bypass.open}
  end

  defp set_client(context) do
    {:ok, client: %ExTumblr.Client{hostname: "http://localhost:#{context.bypass.port}"}}
  end

  setup [:set_bypass, :set_client]

  test "handle the particular response of the avatar endpoint", context do
    avatar_url = "https://67.media.tumblr.com/avatar_34abdab07c47_48.png"
    prebaked_response = "avatar_url=#{avatar_url}"
    Bypass.expect context.bypass, fn conn ->
      assert "/v2/blog/gunkatana.tumblr.com/avatar/48" == conn.request_path
      Plug.Conn.resp(conn, 200, prebaked_response)
    end
    assert avatar_url == ExTumblr.Avatar.request(context.client, "gunkatana.tumblr.com", 48)
  end
end

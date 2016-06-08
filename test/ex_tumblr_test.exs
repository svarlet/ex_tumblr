defmodule ExTumblrTest do
  use ShouldI, async: true

  having "a running remote api" do
    setup context do
      bypass = Bypass.open
      Application.put_env(:ex_tumblr, :hostname, "http://localhost:#{bypass.port}")
      assign context, bypass: bypass
    end

    should "handle the particular response of the avatar endpoint", context do
      prebaked_response = "avatar_url=https://67.media.tumblr.com/avatar_34abdab07c47_48.png"
      Bypass.expect context.bypass, fn conn ->
        assert "/v2/blog/gunkatana.tumblr.com/avatar/48" == conn.request_path
        conn
        |> Plug.Conn.put_resp_header("status", "301 Moved Permanently")
        |> Plug.Conn.resp(200, prebaked_response)
      end
      {:ok, %HTTPoison.Response{body: body}} = ExTumblr.avatar "gunkatana.tumblr.com", 48
      assert body == prebaked_response
    end


  end
end

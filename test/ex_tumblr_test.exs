defmodule ExTumblrTest do
  use ShouldI, async: true

  alias ExTumblr.Credentials

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
      {:ok, %HTTPoison.Response{body: ^prebaked_response}} = ExTumblr.avatar "gunkatana.tumblr.com", 48
    end

    having "a valid tumblr api key" do
      setup context do
        assign context, credentials: %Credentials{consumer_key: System.get_env "TUMBLR_API_KEY"}
      end

      should "retrive blog info", context do
        prebaked_response = """
        {
          "meta": {
            "status": 200,
            "msg": "OK"
          },
          "response": {
            "blog": {
              "title": "Gunkatana",
              "name": "gunkatana",
              "total_posts": 13,
              "posts": 13,
              "url": "http://gunkatana.tumblr.com/",
              "updated": 1455328457,
              "description": "<p>Gunkatana is a cyberpunk action game of two speeds: turbo fast and dead! </p><p>Fast N' Dangerous grind rails take you to your next kill across neon-lit streets.</p><p>For PC / Mac / Linux - 2016</p><p>www.gunkatana.com</p>",
              "is_nsfw": false,
              "ask": false,
              "ask_page_title": "Ask me anything",
              "ask_anon": false,
              "share_likes": false
            }
          }
        }
        """
        Bypass.expect context.bypass, fn conn ->
          assert "/v2/blog/gunkatana.tumblr.com/info" == conn.request_path
          Plug.Conn.resp(conn, 200, prebaked_response)
        end
        {:ok, %HTTPoison.Response{body: prebaked_response}} = ExTumblr.info "gunkatana.tumblr.com", context.credentials, nil
      end
    end
  end
end

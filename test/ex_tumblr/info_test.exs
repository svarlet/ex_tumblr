defmodule ExTumblr.InfoTest do
  use ShouldI, async: true

  alias ExTumblr.{Credentials, Info}

  having "a running remote api" do
    setup context do
      bypass = Bypass.open
      Application.put_env(:ex_tumblr, :hostname, "http://localhost:#{bypass.port}")
      context
      |> assign(bypass: bypass)
      |> assign(credentials: %Credentials{consumer_key: System.get_env "TUMBLR_API_KEY"})
    end

    should "retrieve blog info", context do
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
            "description": "desc",
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
        assert "api_key=#{context.credentials.consumer_key}" == conn.query_string
        Plug.Conn.resp(conn, 200, prebaked_response)
      end
      expected =
        %Info{
          title: "Gunkatana",
          name: "gunkatana",
          posts: 13,
          updated: 1455328457,
          description: "desc",
          ask: false,
          ask_anon: false,
          is_blocked_from_primary: false
        }
      assert expected == Info.request "gunkatana.tumblr.com", context.credentials, nil
    end
  end
end

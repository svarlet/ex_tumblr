defmodule ExTumblr.Connector.MockConnector do
  def get!("/blog/gunkatana.tumblr.com/info?api_key=api-key") do
    wrap_in_body = fn (value) -> %{body: value} end
    """
    {"meta":{"status":200,"msg":"OK"},"response":{"blog":{"title":"Gunkatana","name":"gunkatana","total_posts":13,"posts":13,"url":"http:\/\/gunkatana.tumblr.com\/","updated":1455328457,"description":"\u003Cp\u003EGunkatana is a cyberpunk action game of two speeds: turbo fast and dead! \u003C\/p\u003E\u003Cp\u003EFast N\u0027 Dangerous grind rails take you to your next kill across neon-lit streets.\u003C\/p\u003E\u003Cp\u003EFor PC \/ Mac \/ Linux - 2016\u003C\/p\u003E\u003Cp\u003Ewww.gunkatana.com\u003C\/p\u003E","is_nsfw":false,"ask":false,"ask_page_title":"Ask me anything","ask_anon":false,"share_likes":false}}}
"""
    |> Poison.decode!
    |> wrap_in_body.()
  end
end

defmodule ExTumblrTest do
  use ShouldI, async: true

  alias ExTumblr.Credentials

  having "specified a custom HTTP client adapter" do
    should "send the prepared http request via the custom adapter" do
      ExTumblr.blog_info "gunkatana.tumblr.com", %Credentials{consumer_key: "lol"}, nil
      assert_received {:get, "https://api.tumblr.com/v2/blog/gunkatana.tumblr.com/info?api_key=lol", nil, nil}
    end
  end
end

defmodule ExTumblr.RequestTest do
  use ShouldI, async: true

  alias ExTumblr.Request

  having "No authentication required by the API" do
    setup context do
       context
       |> assign(base_request: {:method, "my_url", :no_auth})
       |> assign(params: %{my_param: "my value", my_other_param: "my other value"})
    end

    should "prepare a request with a no headers and no body", context do
      {_, _, body, headers} = Request.prepare_request_auth(context.base_request, nil, context.params)
      assert body == nil
      assert headers == nil
    end

    should "encode and format the parameters", context do
      {_, url, _, _} = Request.prepare_request_auth(context.base_request, nil, context.params)
      assert url == "my_url?my_other_param=my+other+value&my_param=my+value"
    end
  end
end

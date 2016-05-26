defmodule ExTumblr.RequestTest do
  use ShouldI, async: true

  alias ExTumblr.Request

  having "No authentication required by the API" do
    setup context do
       context
       |> assign(base_request: {:method, "my_url", :no_auth})
       |> assign(params: %{my_param: "my_value", my_other_param: "my_other_value"})
    end

    should "prepare a request with a nil body", context do
      {_, _, body, _} = Request.prepare_request_auth(context.base_request, nil, context.params)
      assert body == nil
    end

    should "prepare a request with nil headers", context do
      {_, _, _, headers} = Request.prepare_request_auth(context.base_request, nil, context.params)
      assert headers == nil
    end
  end
end

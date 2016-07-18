ExCheck.start()
ExUnit.start()
Application.ensure_all_started(:bypass)

defmodule ExTumblr.BypassSetupTemplate do
  defmacro __using__(opts) do
    quote do
      use ExUnit.Case, unquote(opts)
      alias ExTumblr.{Client, Credentials}

      setup context do
        bypass = Bypass.open
        client =
          %Client{
            hostname: "http://localhost:#{bypass.port}",
            credentials:
            %Credentials{
              consumer_secret: "ct",
              consumer_key:    "ck",
              token:           "t",
              token_secret:    "ts"
            }
          }
        context
        |> Map.put(:bypass, bypass)
        |> Map.put(:client, client)
      end
    end
  end
end

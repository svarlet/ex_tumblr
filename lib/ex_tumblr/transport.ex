defmodule ExTumblr.Transport do
  defmacro __using__(_opts) do
    quote do
      require Logger

      defp emit({method, url, body, headers}) do
        Logger.info "#{__MODULE__}: Sending #{method} request to #{url}"
        HTTPoison.request(method, url, body || "", headers || [])
      end
    end
  end
end

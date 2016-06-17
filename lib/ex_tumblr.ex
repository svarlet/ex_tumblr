defmodule ExTumblr do
  defmodule Credentials do
    @typedoc """
    Defines a structure to represent API credentials
    """

    @type t :: %ExTumblr.Credentials{}

    defstruct [:consumer_key, :consumer_secret, :token, :token_secret]
  end

  defmodule Client do
    @typedoc """
    Defines a struct to store the API hostname and credentials.
    """

    @type t :: %__MODULE__{hostname: String.t, credentials: Credentials.t}

    defstruct [:hostname, :credentials]
  end
end

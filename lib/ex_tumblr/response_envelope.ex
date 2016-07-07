defmodule ExTumblr.ResponseMetadata do
  @type t :: %__MODULE__{
    status: non_neg_integer(),
    msg: String.t
  }

  defstruct ~w(status msg)a
end

defmodule ExTumblr.ResponseEnvelope do
  @type t :: %__MODULE__{
    meta: ResponseMetadata.t,
    response: any
  }

  defstruct ~w(meta response)a
end

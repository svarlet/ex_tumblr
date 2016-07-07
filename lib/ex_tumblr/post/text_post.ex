defmodule ExTumblr.Post.TextPost do
  alias ExTumblr.Post.CommonPostData

  @type t :: %__MODULE__{
    base:  CommonPostData.t,
    title: String.t,
    body:  String.t
  }

  defstruct ~w(base title body)a
end

defmodule ExTumblr.Post.QuotePost do
  alias ExTumblr.Post.CommonPostData

  @type t :: %__MODULE__{
    base:   CommonPostData.t,
    text:   String.t,
    source: String.t
  }

  defstruct ~w(base text source)a
end

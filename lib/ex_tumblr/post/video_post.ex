defmodule ExTumblr.Post.VideoPost do
  alias ExTumblr.Post.CommonPostData

  @type t :: %__MODULE__{
    base:    CommonPostData.t,
    caption: String.t,
    player:  [player]
  }

  @type player :: %{
    width:      number(),
    embed_code: String.t
  }

  defstruct ~w(base caption player)a
end

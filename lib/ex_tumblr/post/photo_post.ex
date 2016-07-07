defmodule ExTumblr.Post.PhotoPost do
  alias ExTumblr.Post.{CommonPostData, PhotoItem}

  @type t :: %__MODULE__{
    base:    CommonPostData.t,
    photos:  [PhotoItem.t],
    caption: String.t,
    width:   number(),
    height:  number()
  }

  defstruct ~w(base photos caption width height)a
end

defmodule ExTumblr.Post.LinkPost do
  alias ExTumblr.Post.{CommonPostData, PhotoItem}

  @type t :: %__MODULE__{
    base:        CommonPostData.t,
    title:       String.t,
    url:         String.t,
    author:      String.t,
    excerpt:     String.t,
    publisher:   String.t,
    photos:      [PhotoItem.t],
    description: String.t
  }

  defstruct ~w(base title url author excerpt publisher photos description)a
end

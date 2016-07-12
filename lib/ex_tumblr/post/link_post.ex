defmodule ExTumblr.Post.LinkPost do
  alias ExTumblr.Post.PhotoItem

  @type t :: %__MODULE__{
    blog_name:    String.t,
    id:           non_neg_integer,
    post_url:     String,
    type:         String.t,
    timestamp:    non_neg_integer,
    date:         String.t,
    format:       String.t,
    reblog_key:   String.t,
    tags:         [String.t],
    bookmarklet:  boolean,
    mobile:       boolean,
    source_url:   String.t,
    source_title: String.t,
    liked:        boolean,
    state:        String.t,
    title:        String.t,
    title:        String.t,
    url:          String.t,
    author:       String.t,
    excerpt:      String.t,
    publisher:    String.t,
    photos:       [PhotoItem.t],
    description:  String.t
  }

  defstruct ~w(blog_name id post_url type timestamp date format reblog_key tags bookmarklet mobile source_url source_title liked state title url author excerpt publisher photos description)a
end

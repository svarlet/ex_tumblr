defmodule ExTumblr.Post.QuotePost do
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
    text:         String.t,
    source:       String.t
  }

  defstruct ~w(blog_name id post_url type timestamp date format reblog_key tags bookmarklet mobile source_url source_title liked state text source)a
end

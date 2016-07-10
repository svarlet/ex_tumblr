defmodule ExTumblr.Post.PostParser do
  alias ExTumblr.Utils.Parsing
  alias ExTumblr.Post.CommonPostData
  alias ExTumblr.Post.TextPost
  alias ExTumblr.Post.{PhotoPost, PhotoItem}
  alias ExTumblr.Post.QuotePost
  alias ExTumblr.Post.LinkPost
  # alias ExTumblr.Post.ChatPost
  # alias ExTumblr.Post.AudioPost
  # alias ExTumblr.Post.VideoPost
  # alias ExTumblr.Post.AnswerPost

  defp parse_common_keys(raw_post) do
    Parsing.to_struct(raw_post, CommonPostData)
  end

  def parse(%{"type" => "text"} = raw_post) do
    %TextPost{
      base:  parse_common_keys(raw_post),
      title: raw_post["title"],
      body:  raw_post["body"]
    }
  end

  def parse(%{"type" => "photo"} = raw_post) do
    %PhotoPost{
      base:    parse_common_keys(raw_post),
      caption: raw_post["caption"],
      width:   raw_post["width"],
      height:  raw_post["height"],
      photos:  Enum.map(raw_post["photos"], &PhotoItem.parse/1)
    }
  end

  def parse(%{"type" => "quote"} = raw_post) do
    %QuotePost{
      base:   parse_common_keys(raw_post),
      text:   raw_post["text"],
      source: raw_post["source"]
    }
  end

  def parse(%{"type" => "link"} = raw_post) do
    %LinkPost{
      base:        raw_post["base"],
      title:       raw_post["title"],
      url:         raw_post["url"],
      author:      raw_post["author"],
      excerpt:     raw_post["excerpt"],
      publisher:   raw_post["publisher"],
      photos:      Enum.map(raw_post["photos"], &PhotoItem.parse/1),
      description: raw_post["description"]
    }
  end

  # def parse(%{"type" => "chat"} = raw_post) do
  # end

  # def parse(%{"type" => "audio"} = raw_post) do
  # end

  # def parse(%{"type" => "video"} = raw_post) do
  # end

  # def parse(%{"type" => "answer"} = raw_post) do
  # end
end

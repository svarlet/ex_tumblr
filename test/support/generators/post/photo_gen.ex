defmodule ExTumblr.Support.Generators.Post.PhotoGen do
  use PropCheck

  defp url_gen, do: elements ["url1", "url2"]

  defp photo_meta_gen do
    let [width, height, url] <- [nat, nat, url_gen] do
      %{"width" => width,
        "height" => height,
        "url" => url}
    end
  end

  defp caption_gen, do: elements ["", "caption"]

  def photo_item do
    let [caption, original_size, alt_sizes] <- [caption_gen, photo_meta_gen, list(photo_meta_gen)] do
      %{"caption" => caption,
        "original_size" => original_size,
        "alt_sizes" => alt_sizes}
    end
  end
  
end

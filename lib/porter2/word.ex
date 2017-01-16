defmodule Porter2.Word do
  def trim_leading_apostrophe( "'" <> rest ), do: rest
  def trim_leading_apostrophe( word ), do: word

  def transform_vowel_ys( word ) do
    Regex.replace( ~r/(\A|[aeiouy])y/, word, "\\1Y" )
  end

  def remove_apostrophe_s_suffix( word ) do 
    Regex.replace( ~r/'s?'?\z/, word, "" )
  end

  def replace_suffixes( word ) do
    word
    |> String.reverse
    |> replace_reversed_suffixes
    |> String.reverse
  end

  defp contains_vowels?( word ) do
    Regex.match?( ~r/[aeiouy]/, word )
  end

  defp replace_reversed_suffixes( "sess" <> reversed_prefix ) do
    "ss" <> reversed_prefix
  end

  defp replace_reversed_suffixes( "dei" <> reversed_prefix ) do
    new_suffix = case String.length( reversed_prefix ) do
                   x when x <= 1 -> "ei"
                   _             -> "i"
                 end
    new_suffix <> reversed_prefix 
  end

  defp replace_reversed_suffixes( "sei" <> reversed_prefix ) do
    new_suffix = case String.length( reversed_prefix ) do
                   x when x <= 1 -> "ei"
                   _             -> "i"
                 end
    new_suffix <> reversed_prefix
  end

  defp replace_reversed_suffixes( "s" <> reversed_prefix = word ) do
    if Regex.match?( ~r/^.+[aeiouy]/, reversed_prefix ) do
      reversed_prefix
    else
      word
    end
  end

  defp replace_reversed_suffixes( "yldee" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "yldee" <> _rest -> "ee" <> reversed_prefix
      _                -> word
    end
  end

  defp replace_reversed_suffixes( "dee" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "dee" <> _rest -> "ee" <> reversed_prefix
      _              -> word
    end
  end

  defp replace_reversed_suffixes( "ylde" <> reversed_prefix = word ) do
    if contains_vowels?( reversed_prefix ) do
      reversed_prefix 
      |> replace_adverb_suffix
    else
      word
    end
  end

  defp replace_reversed_suffixes( "de" <> reversed_prefix = word ) do
    if contains_vowels?( reversed_prefix ) do
      reversed_prefix 
      |> replace_adverb_suffix
    else
      word
    end
  end
  defp replace_reversed_suffixes( "gni" <> reversed_prefix = word ) do
    if contains_vowels?( reversed_prefix ) do
      reversed_prefix 
      |> replace_adverb_suffix
    else
      word
    end
  end
  defp replace_reversed_suffixes( "ylgni" <> reversed_prefix = word ) do
    if contains_vowels?( reversed_prefix ) do
      reversed_prefix 
      |> replace_adverb_suffix
    else
      word
    end
  end

  defp replace_reversed_suffixes( "y" <> reversed_prefix = word ) do
    if Regex.match?( ~r/^[^aeiouy].+$/, reversed_prefix ) do
      "i" <> reversed_prefix
    else
      word
    end
  end

  defp replace_reversed_suffixes( "Y" <> reversed_prefix = word ) do
    if Regex.match?( ~r/^[^aeiouy].+$/, reversed_prefix ) do
      "i" <> reversed_prefix
    else
      word
    end
  end

  defp replace_adverb_suffix( "ta" <> _reversed_prefix = word ) do
    "e" <> word
  end

  defp replace_adverb_suffix( "lb" <> _reversed_prefix = word ) do
    "e" <> word
  end

  defp replace_adverb_suffix( "zi" <> _reversed_prefix = word ) do
    "e" <> word
  end

  defp replace_adverb_suffix( "bb" <> reversed_prefix ) do
    "b" <> reversed_prefix
  end

  defp replace_adverb_suffix( "dd" <> reversed_prefix ) do
    "d" <> reversed_prefix
  end

  defp replace_adverb_suffix( "ff" <> reversed_prefix ) do
    "f" <> reversed_prefix
  end

  defp replace_adverb_suffix( "gg" <> reversed_prefix ) do
    "g" <> reversed_prefix
  end

  defp replace_adverb_suffix( "mm" <> reversed_prefix ) do
    "m" <> reversed_prefix
  end

  defp replace_adverb_suffix( "nn" <> reversed_prefix ) do
    "n" <> reversed_prefix
  end

  defp replace_adverb_suffix( "pp" <> reversed_prefix ) do
    "p" <> reversed_prefix
  end

  defp replace_adverb_suffix( "rr" <> reversed_prefix ) do
    "r" <> reversed_prefix
  end

  defp replace_adverb_suffix( "tt" <> reversed_prefix ) do
    "t" <> reversed_prefix
  end

  defp replace_adverb_suffix( word ) do
    short_word = word
                 |> String.reverse
                 |> is_word_short?
    if short_word do
      "e" <> word
    else
      word
    end
  end

  def r1_region( word ) do
    case Regex.run( ~r/(?<=[aeiouy][^aeiouy]).*$/, word, capture: :first ) do
      x when is_list( x ) -> hd( x )
      _                   -> ""
    end
  end

  def reverse_r1_region( drow ) do
    case Regex.run( ~r/^.*(?=[^aeiouy][aeiouy])/, drow, capture: :first ) do
      x when is_list( x ) -> hd( x )
      _                   -> ""
    end
  end

  def word_ends_in_short_syllable?( word ) do
    Regex.match?( ~r/[^aeiouy][aeiouy][^aeioywxY]$/, word )
  end

  def is_word_short?( word ) do
    ( r1_region( word ) == "" ) && word_ends_in_short_syllable?( word )
  end

end

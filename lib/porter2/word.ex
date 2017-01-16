defmodule Porter2.Word do
  def trim_leading_apostrophe( "'"<> rest = word ), do: rest
  def trim_leading_apostrophe( word ), do: word

  def transform_vowel_ys( word ) do
    Regex.replace( ~r/(\A|[aeiou])y/, word, "\\1Y" )
  end

  def remove_apostrophe_s_suffix( word ) do 
    Regex.replace( ~r/'s?'?\z/, word, "" )
  end

  def replace_suffixes( word ) do
    word
    |> String.reverse
    |> replace_reversed_suffixes
  end

  defp replace_reversed_suffixes( "sess" <> reversed_prefix = word ) do
    String.reverse( reversed_prefix ) <> "ss"
  end

  defp replace_reversed_suffixes( "dei" <> reversed_prefix = word ) do
    new_suffix = case String.length( reversed_prefix ) do
                   x when x <= 1 -> "ie"
                   _ -> "i"
                 end
    String.reverse( reversed_prefix ) <> new_suffix
  end

  defp replace_reversed_suffixes( "sei" <> reversed_prefix = word ) do
    new_suffix = case String.length( reversed_prefix ) do
                   x when x <= 1 -> "ie"
                   _ -> "i"
                 end
    String.reverse( reversed_prefix ) <> new_suffix
  end

  defp replace_reversed_suffixes( "s" <> reversed_prefix = word ) do
    if Regex.match?( ~r/^.[^aeiouy]*$/, reversed_prefix ) do
      String.reverse( word )
    else
      String.reverse( reversed_prefix )
    end
  end

  defp replace_reversed_suffixes( "ylde" <> reversed_prefix = word ) do
    if Regex.match?( ~r/[aeiou]/, reversed_prefix ) do
      reversed_prefix 
      |> replace_adverb_suffix
      |> String.reverse
    else
      String.reverse( word )
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

  defp replace_adverb_suffix( "bb" <> reversed_prefix = _word ) do
    "b" <> reversed_prefix
  end

  defp replace_adverb_suffix( "dd" <> reversed_prefix = _word ) do
    "d" <> reversed_prefix
  end

  defp replace_adverb_suffix( "ff" <> reversed_prefix = _word ) do
    "f" <> reversed_prefix
  end

  defp replace_adverb_suffix( "gg" <> reversed_prefix = _word ) do
    "g" <> reversed_prefix
  end

  defp replace_adverb_suffix( "mm" <> reversed_prefix = _word ) do
    "m" <> reversed_prefix
  end

  defp replace_adverb_suffix( "nn" <> reversed_prefix = _word ) do
    "n" <> reversed_prefix
  end

  defp replace_adverb_suffix( "pp" <> reversed_prefix = _word ) do
    "p" <> reversed_prefix
  end

  defp replace_adverb_suffix( "rr" <> reversed_prefix = _word ) do
    "r" <> reversed_prefix
  end

  defp replace_adverb_suffix( "tt" <> reversed_prefix = _word ) do
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
    case Regex.run( ~r/(?<=[aeiou][^aeiou]).*$/, word, caputure: :first ) do
      [ "" ]              -> nil
      x when is_list( x ) -> hd( x )
      _                   -> nil
    end
  end

  def word_ends_in_short_syllable?( word ) do
    Regex.match?( ~r/[^aeiouy][aeiouy][^aeioywxY]$/, word )
  end

  def is_word_short?( word ) do
    ( r1_region( word ) == nil ) && word_ends_in_short_syllable?( word )
  end

end

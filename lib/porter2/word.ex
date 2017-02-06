defmodule Porter2.Word do
  @moduledoc """
  Functions concerned with the actual stemming and associated helper functions
  """
  @spec trim_leading_apostrophe( binary ) :: binary
  def trim_leading_apostrophe( "'" <> rest ), do: rest
  def trim_leading_apostrophe( word ), do: word

  @spec transform_vowel_ys( binary ) :: binary
  def transform_vowel_ys( word ) do
    Regex.replace( ~r/(\A|[aeiouy])y/, word, "\\1Y" )
  end

  @spec remove_apostrophe_s_suffix( binary ) :: binary
  def remove_apostrophe_s_suffix( word ) do 
    Regex.replace( ~r/'s?'?\z/, word, "" )
  end

  @spec replace_suffixes( binary ) :: binary
  def replace_suffixes( word ) do
    word
    |> String.reverse
    |> replace_reversed_suffixes
    |> String.reverse
  end

  defp contains_vowels?( word ) do
    Regex.match?( ~r/[aeiouy]/, word )
  end

  defp replace_reversed_suffix_if_prefix_contains_vowels( reversed_prefix, word ) do
    if contains_vowels?( reversed_prefix ) do
      reversed_prefix 
      |> replace_adverb_suffix
    else
      word
    end
  end

  defp replace_reversed_suffixes( "sess" <> reversed_prefix ), do: "ss" <> reversed_prefix
  defp replace_reversed_suffixes( <<"dei">> ), do: "ei"
  defp replace_reversed_suffixes( <<"dei", reversed_prefix::binary-size(1)>> ), do: "ei" <> reversed_prefix
  defp replace_reversed_suffixes( "dei" <> reversed_prefix ), do: "i" <> reversed_prefix
  defp replace_reversed_suffixes( <<"sei">> ), do: "ei"
  defp replace_reversed_suffixes( <<"sei", reversed_prefix::binary-size(1)>> ), do: "ei" <> reversed_prefix
  defp replace_reversed_suffixes( "sei" <> reversed_prefix ), do: "i" <> reversed_prefix
  defp replace_reversed_suffixes( "ss" <> _reversed_prefix = word ), do: word
  defp replace_reversed_suffixes( "su" <> _reversed_prefix = word ), do: word

  defp replace_reversed_suffixes( "s" <> reversed_prefix = word ) do
    if Regex.match?( ~r/^.+[aeiouy]/, reversed_prefix ) do
      reversed_prefix
    else
      word
    end
  end

  defp replace_reversed_suffixes( "yldee" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "yldee", reversed_prefix, "ee" )
  end

  defp replace_reversed_suffixes( "ylgni" <> reversed_prefix = word ) do
    replace_reversed_suffix_if_prefix_contains_vowels( reversed_prefix, word )
  end

  defp replace_reversed_suffixes( "ylde" <> reversed_prefix = word ) do
    replace_reversed_suffix_if_prefix_contains_vowels( reversed_prefix, word )
  end

  defp replace_reversed_suffixes( "dee" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "dee", reversed_prefix, "ee" )
  end

  defp replace_reversed_suffixes( "gni" <> reversed_prefix = word ) do
    replace_reversed_suffix_if_prefix_contains_vowels( reversed_prefix, word )
  end

  defp replace_reversed_suffixes( "de" <> reversed_prefix = word ) do
    replace_reversed_suffix_if_prefix_contains_vowels( reversed_prefix, word )
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

  defp replace_reversed_suffixes( word ), do: word

  defp replace_adverb_suffix( "ta" <> _reversed_prefix = word ), do: "e" <> word
  defp replace_adverb_suffix( "lb" <> _reversed_prefix = word ), do: "e" <> word
  defp replace_adverb_suffix( "zi" <> _reversed_prefix = word ), do: "e" <> word
  defp replace_adverb_suffix( "bb" <> reversed_prefix ), do: "b" <> reversed_prefix
  defp replace_adverb_suffix( "dd" <> reversed_prefix ), do: "d" <> reversed_prefix
  defp replace_adverb_suffix( "ff" <> reversed_prefix ), do: "f" <> reversed_prefix
  defp replace_adverb_suffix( "gg" <> reversed_prefix ), do: "g" <> reversed_prefix
  defp replace_adverb_suffix( "mm" <> reversed_prefix ), do: "m" <> reversed_prefix
  defp replace_adverb_suffix( "nn" <> reversed_prefix ), do: "n" <> reversed_prefix
  defp replace_adverb_suffix( "pp" <> reversed_prefix ), do: "p" <> reversed_prefix
  defp replace_adverb_suffix( "rr" <> reversed_prefix ), do: "r" <> reversed_prefix
  defp replace_adverb_suffix( "tt" <> reversed_prefix ), do: "t" <> reversed_prefix

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

  @spec r1_region( binary ) :: binary
  def r1_region( word ) do
    case Regex.run( ~r/(?<=[aeiouy][^aeiouy]).*$/, word, capture: :first ) do
      x when is_list( x ) -> hd( x )
      _                   -> ""
    end
  end

  @spec reverse_r1_region( binary ) :: binary
  def reverse_r1_region( drow ) do
    case Regex.run( ~r/^.*(?=[^aeiouy][aeiouy])/, drow, capture: :first ) do
      x when is_list( x ) -> hd( x )
      _                   -> ""
    end
  end

  @spec r2_region( binary ) :: binary
  def r2_region( word ) do
    # we can't use a regex with lookbehind here, as the lookbehind region needs
    # to be of fixed length (sr 2017-01-17)
    word
    |> r1_region
    |> r1_region
  end

  @spec reverse_r2_region( binary ) :: binary
  def reverse_r2_region( drow ) do
    case Regex.run( ~r/^.*(?=[^aeiouy][aeiouy].*[^aeiouy][aeiouy])/, drow, capture: :first ) do
      x when is_list( x ) -> hd( x )
      _                   -> ""
    end
  end
  
  @spec word_ends_in_short_syllable?( binary ) :: boolean
  def word_ends_in_short_syllable?( word ) do
    Regex.match?( ~r/[^aeiouy][aeiouy][^aeioywxY]$/, word )
  end

  @spec is_word_short?( binary ) :: boolean
  def is_word_short?( word ) do
    ( r1_region( word ) == "" ) && word_ends_in_short_syllable?( word )
  end

  @spec primary_special_suffix_replacement( binary ) :: binary
  def primary_special_suffix_replacement( word ) do
    word
    |> String.reverse
    |> primary_suffix_replacement
    |> String.reverse
  end

  defp primary_suffix_replacement( "noitazi" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "noitazi", reversed_prefix, "ezi" )
  end

  defp primary_suffix_replacement( "lanoita" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "lanoita", reversed_prefix, "eta" )
  end

  defp primary_suffix_replacement( "ssenluf" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "ssenluf", reversed_prefix, "luf" )
  end

  defp primary_suffix_replacement( "ssensuo" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "ssensuo", reversed_prefix, "suo" )
  end

  defp primary_suffix_replacement( "ssenevi" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "ssenevi", reversed_prefix, "evi" )
  end

  defp primary_suffix_replacement( "lanoit" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "lanoit", reversed_prefix, "noit" )
  end

  defp primary_suffix_replacement( "itilib" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "itilib", reversed_prefix, "elb" )
  end

  defp primary_suffix_replacement( "ilssel" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "ilssel", reversed_prefix, "ssel" )
  end

  defp primary_suffix_replacement( "ilsuo" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "ilsuo", reversed_prefix, "suo" )
  end

  defp primary_suffix_replacement( "itivi" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "itivi", reversed_prefix, "evi" )
  end

  defp primary_suffix_replacement( "illuf" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "illuf", reversed_prefix, "luf" )
  end
  defp primary_suffix_replacement( "iltne" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "iltne", reversed_prefix, "tne" )
  end

  defp primary_suffix_replacement( "noita" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "noita", reversed_prefix, "eta" )
  end

  defp primary_suffix_replacement( "msila" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "msila", reversed_prefix, "la" )
  end

  defp primary_suffix_replacement( "itila" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "itila", reversed_prefix, "la" )
  end

  defp primary_suffix_replacement( "icne" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "icne", reversed_prefix, "ecne" )
  end

  defp primary_suffix_replacement( "icna" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "icna", reversed_prefix, "ecna" )
  end

  defp primary_suffix_replacement( "ilba" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "ilba", reversed_prefix, "elba" )
  end

  defp primary_suffix_replacement( "rota" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "rota", reversed_prefix, "eta" )
  end

  defp primary_suffix_replacement( "illa" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "illa", reversed_prefix, "la" )
  end

  defp primary_suffix_replacement( "rezi" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "rezi", reversed_prefix, "ezi" )
  end

  defp primary_suffix_replacement( "igol" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "igo", reversed_prefix, "gol" )
  end
  defp primary_suffix_replacement( "igo" <> _reversed_prefix = word ), do: word

  defp primary_suffix_replacement( "ilb" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "ilb", reversed_prefix, "elb" )
  end

  defp primary_suffix_replacement( "ilc" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "il", reversed_prefix, "c" )
  end

  defp primary_suffix_replacement( "ild" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "il", reversed_prefix, "d" )
  end

  defp primary_suffix_replacement( "ile" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "il", reversed_prefix, "e" )
  end

  defp primary_suffix_replacement( "ilg" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "il", reversed_prefix, "g" )
  end

  defp primary_suffix_replacement( "ilh" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "il", reversed_prefix, "h" )
  end

  defp primary_suffix_replacement( "ilk" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "il", reversed_prefix, "k" )
  end

  defp primary_suffix_replacement( "ilm" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "il", reversed_prefix, "m" )
  end

  defp primary_suffix_replacement( "iln" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "il", reversed_prefix, "n" )
  end

  defp primary_suffix_replacement( "ilr" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "il", reversed_prefix, "r" )
  end

  defp primary_suffix_replacement( "ilt" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "il", reversed_prefix, "t" )
  end

  defp primary_suffix_replacement( word ), do: word

  defp replace_reversed_suffix_in_r1( word, suffix, prefix, replacement ) do
    if String.starts_with?( reverse_r1_region( word ), suffix ) do
      replacement <> prefix
    else
      word
    end
  end

  defp replace_reversed_suffix_in_r2( word, suffix, prefix, replacement ) do
    if String.starts_with?( reverse_r2_region( word ), suffix ) do
      replacement <> prefix
    else
      word
    end
  end

  @spec secondary_special_suffix_replacement( binary ) :: binary
  def secondary_special_suffix_replacement( word ) do
    word
    |> String.reverse
    |> secondary_suffix_replacement
    |> String.reverse
  end

  defp secondary_suffix_replacement( "lanoita" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "lanoita", reversed_prefix, "eta" )
  end

  defp secondary_suffix_replacement( "lanoit" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "lanoit", reversed_prefix, "noit" )
  end

  defp secondary_suffix_replacement( "ezila" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "ezila", reversed_prefix, "la" )
  end

  defp secondary_suffix_replacement( "evita" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "evita", reversed_prefix, "" )
  end

  defp secondary_suffix_replacement( "etaci" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "etaci", reversed_prefix, "ci" )
  end

  defp secondary_suffix_replacement( "itici" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "itici", reversed_prefix, "ci" )
  end

  defp secondary_suffix_replacement( "laci" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "laci", reversed_prefix, "ci" )
  end

  defp secondary_suffix_replacement( "ssen" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "ssen", reversed_prefix, "" )
  end

  defp secondary_suffix_replacement( "luf" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r1( word, "luf", reversed_prefix, "" )
  end

  defp secondary_suffix_replacement( word ), do: word

  @spec primary_suffix_deletion( binary ) :: binary
  def primary_suffix_deletion( word ) do
    word
    |> String.reverse
    |> reversed_primary_suffix_deletion
    |> String.reverse
  end

  defp reversed_primary_suffix_deletion( "tneme" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "tneme", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "ecna" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "ecna", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "ecne" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "ecne", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "elba" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "elba", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "elbi" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "elbi", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "tnem" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "tnem", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "tna" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "tna", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "tne" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "tne", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "msi" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "msi", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "eta" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "eta", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "iti" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "iti", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "suo" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "suo", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "evi" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "evi", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "ezi" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "ezi", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "nois" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "nois", reversed_prefix, "s" )
  end
  defp reversed_primary_suffix_deletion( "noit" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "noit", reversed_prefix, "t" )
  end
  defp reversed_primary_suffix_deletion( "la" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "la", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "re" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "re", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( "ci" <> reversed_prefix = word ) do
    replace_reversed_suffix_in_r2( word, "ci", reversed_prefix, "" )
  end
  defp reversed_primary_suffix_deletion( word ), do: word

 
  @spec secondary_suffix_deletion( binary ) :: binary
  def secondary_suffix_deletion( word ) do
    word
    |> String.reverse
    |> reversed_secondary_suffix_deletion
    |> String.reverse
  end

  defp reversed_secondary_suffix_deletion( "ll" <> reversed_prefix = word ) do
    case reverse_r2_region( word ) do
      "l" <> _rest -> "l" <> reversed_prefix
      _            -> word
    end
  end

  defp reversed_secondary_suffix_deletion( "e" <> reversed_prefix = word ) do
    case reverse_r2_region( word ) do
      "e" <> _rest  -> reversed_prefix
      _             -> case reverse_r1_region( word ) do
                         "e" <> _rest -> if word_ends_in_short_syllable?( String.reverse( reversed_prefix ) ) do
                                           word
                                         else
                                           reversed_prefix
                                         end
                         _            -> word
                       end
    end
  end

  defp reversed_secondary_suffix_deletion( word ), do: word

end

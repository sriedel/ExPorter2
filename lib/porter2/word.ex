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

  def r2_region( word ) do
    # we can't use a regex with lookbehind here, as the lookbehind region needs
    # to be of fixed length (sr 2017-01-17)
    word
    |> r1_region
    |> r1_region
  end

  def reverse_r2_region( drow ) do
    case Regex.run( ~r/^.*(?=[^aeiouy][aeiouy].*[^aeiouy][aeiouy])/, drow, capture: :first ) do
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

  def primary_special_suffix_replacement( word ) do
    word
    |> String.reverse
    |> primary_suffix_replacement
    |> String.reverse
  end

  defp primary_suffix_replacement( "noitazi" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "noitazi" <> _rest -> "ezi" <> reversed_prefix
      _                  -> word
    end
  end

  defp primary_suffix_replacement( "lanoita" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "lanoita" <> _rest -> "eta" <> reversed_prefix
      _                  -> word
    end
  end

  defp primary_suffix_replacement( "ssenluf" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "ssenluf" <> _rest -> "luf" <> reversed_prefix
      _                  -> word
    end
  end

  defp primary_suffix_replacement( "ssensuo" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "ssensuo" <> _rest -> "suo" <> reversed_prefix
      _                  -> word
    end
  end

  defp primary_suffix_replacement( "ssenevi" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "ssenevi" <> _rest -> "evi" <> reversed_prefix
      _                  -> word
    end
  end

  defp primary_suffix_replacement( "lanoit" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "lanoit" <> _rest -> "noit" <> reversed_prefix
      _                 -> word
    end
  end

  defp primary_suffix_replacement( "itilib" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "itilib" <> _rest -> "elb" <> reversed_prefix
      _                 -> word
    end
  end

  defp primary_suffix_replacement( "ilssel" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "ilssel" <> _rest -> "ssel" <> reversed_prefix
      _                 -> word
    end
  end

  defp primary_suffix_replacement( "ilsuo" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "ilsuo" <> _rest -> "suo" <> reversed_prefix
      _                -> word
    end
  end

  defp primary_suffix_replacement( "itivi" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "itivi" <> _rest -> "evi" <> reversed_prefix
       _               -> word
    end
  end

  defp primary_suffix_replacement( "illuf" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "illuf" <> _rest -> "luf" <> reversed_prefix
      _                -> word
    end
  end
  defp primary_suffix_replacement( "iltne" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "iltne" <> _rest -> "tne" <> reversed_prefix
      _                -> word
    end
  end

  defp primary_suffix_replacement( "noita" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "noita" <> _rest -> "eta" <> reversed_prefix
      _                -> word
    end
  end

  defp primary_suffix_replacement( "msila" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "msila" <> _rest -> "la" <> reversed_prefix
      _                -> word
    end
  end

  defp primary_suffix_replacement( "itila" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "itila" <> _rest -> "la" <> reversed_prefix
      _                -> word
    end
  end

  defp primary_suffix_replacement( "icne" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "icne" <> _rest -> "ecne" <> reversed_prefix
      _               -> word
    end
  end

  defp primary_suffix_replacement( "icna" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "icna" <> _rest -> "ecna" <> reversed_prefix
      _               -> word
    end
  end

  defp primary_suffix_replacement( "ilba" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "ilba" <> _rest -> "elba" <> reversed_prefix
      _               -> word
    end
  end

  defp primary_suffix_replacement( "rota" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "rota" <> _rest -> "eta" <> reversed_prefix
      _               -> word
    end
  end

  defp primary_suffix_replacement( "illa" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "illa" <> _rest -> "la" <> reversed_prefix
      _               -> word
    end
  end

  defp primary_suffix_replacement( "rezi" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "rezi" <> _rest -> "ezi" <> reversed_prefix
      _               -> word
    end
  end

  defp primary_suffix_replacement( "igol" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "igo" <> _rest -> "gol" <> reversed_prefix
      _              -> word
    end
  end
  defp primary_suffix_replacement( "igo" <> _reversed_prefix = word ), do: word

  defp primary_suffix_replacement( "ilb" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "ilb" <> _rest -> "elb" <> reversed_prefix
      _              -> word
    end
  end

  defp primary_suffix_replacement( "ilc" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "il" <> _rest -> "c" <> reversed_prefix
      _             -> word
    end
  end

  defp primary_suffix_replacement( "ild" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "il" <> _rest -> "d" <> reversed_prefix
      _             -> word
    end
  end

  defp primary_suffix_replacement( "ile" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "il" <> _rest -> "e" <> reversed_prefix
      _             -> word
    end
  end

  defp primary_suffix_replacement( "ilg" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "il" <> _rest -> "g" <> reversed_prefix
      _             -> word
    end
  end

  defp primary_suffix_replacement( "ilh" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "il" <> _rest -> "h" <> reversed_prefix
      _             -> word
    end
  end

  defp primary_suffix_replacement( "ilk" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "il" <> _rest -> "k" <> reversed_prefix
      _             -> word
    end
  end

  defp primary_suffix_replacement( "ilm" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "il" <> _rest -> "m" <> reversed_prefix
      _             -> word
    end
  end

  defp primary_suffix_replacement( "iln" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "il" <> _rest -> "n" <> reversed_prefix
      _             -> word
    end
  end

  defp primary_suffix_replacement( "ilr" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "il" <> _rest -> "r" <> reversed_prefix
      _             -> word
    end
  end

  defp primary_suffix_replacement( "ilt" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "il" <> _rest -> "t" <> reversed_prefix
      _             -> word
    end
  end

  defp primary_suffix_replacement( word ), do: word

  def secondary_special_suffix_replacement( word ) do
    word
    |> String.reverse
    |> secondary_suffix_replacement
    |> String.reverse
  end

  defp secondary_suffix_replacement( "lanoita" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "lanoita" <> _rest -> "eta" <> reversed_prefix
      _                  -> word
    end
  end

  defp secondary_suffix_replacement( "lanoit" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "lanoit" <> _rest -> "noit" <> reversed_prefix
      _                 -> word
    end
  end

  defp secondary_suffix_replacement( "ezila" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "ezila" <> _rest -> "la" <> reversed_prefix
      _                 -> word
    end
  end

  defp secondary_suffix_replacement( "evita" <> reversed_prefix = word ) do
    case reverse_r2_region( word ) do
      "evita" <> _rest -> reversed_prefix
      _                -> word
    end
  end

  defp secondary_suffix_replacement( "etaci" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "etaci" <> _rest -> "ci" <> reversed_prefix
      _                -> word
    end
  end

  defp secondary_suffix_replacement( "itici" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "itici" <> _rest -> "ci" <> reversed_prefix
      _                -> word
    end
  end

  defp secondary_suffix_replacement( "laci" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "laci" <> _rest -> "ci" <> reversed_prefix
      _               -> word
    end
  end

  defp secondary_suffix_replacement( "ssen" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "ssen" <> _rest -> reversed_prefix
      _               -> word
    end
  end

  defp secondary_suffix_replacement( "luf" <> reversed_prefix = word ) do
    case reverse_r1_region( word ) do
      "luf" <> _rest -> reversed_prefix
      _              -> word
    end
  end

  defp secondary_suffix_replacement( word ), do: word

  

end

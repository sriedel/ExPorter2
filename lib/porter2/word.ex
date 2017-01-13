defmodule Porter2.Word do
  def trim_leading_apostrophe( "'"<> rest = word ), do: rest
  def trim_leading_apostrophe( word ), do: word

  def transform_vowel_ys( word ) do
    Regex.replace( ~r/(\A|[aeiou])y/, word, "\\1Y" )
  end

  def remove_apostrophe_s_suffix( word ) do 
    Regex.replace( ~r/'s?'?\z/, word, "" )
  end
end

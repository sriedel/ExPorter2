defmodule Porter2.Word do
  def trim_leading_apostrophe( "'"<> rest = word ), do: rest
  def trim_leading_apostrophe( word ), do: word
end

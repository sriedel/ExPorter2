defmodule Porter2.WordSpec do
  use ESpec

  it do: expect true |> to(be_true())

  describe ".trim_leading_apostrophe" do
    it "should remove a leading apostrophe in a word" do
      "'cos" |> Porter2.Word.trim_leading_apostrophe |> expect |> to( eq "cos" )
    end

    it "should leave a word as is if it has no apostrophe" do
      "cos" |> Porter2.Word.trim_leading_apostrophe |> expect |> to( eq "cos" )
    end
    
  end
end

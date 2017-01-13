defmodule Porter2.WordSpec do
  use ESpec

  it do: expect true |> to(be_true())

  describe ".trim_leading_apostrophe" do
    it "should remove a leading apostrophe in a word" do
      "'cos" 
      |> Porter2.Word.trim_leading_apostrophe 
      |> expect |> to( eq "cos" )
    end

    it "should leave a word as is if it has no apostrophe" do
      "cos" 
      |> Porter2.Word.trim_leading_apostrophe 
      |> expect |> to( eq "cos" )
    end
  end

  describe ".transform_vowel_ys" do
    it "should transform an initial y to Y" do
      "you" 
      |> Porter2.Word.transform_vowel_ys 
      |> expect |> to( eq "You" )
    end

    it "should transform a y after a vowel to Y" do
      "oy"
      |> Porter2.Word.transform_vowel_ys
      |> expect |> to( eq "oY" )
    end

    it "should not transform a y after a consonant to Y" do
      "why"
      |> Porter2.Word.transform_vowel_ys
      |> expect |> to( eq "why" )
    end
  end
end

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

  describe ".remove_apostrophe_s_suffix" do
    it "should remove a 's' suffix" do
      "foo's'"
      |> Porter2.Word.remove_apostrophe_s_suffix
      |> expect |> to( eq "foo" )
    end

    it "should remove a 's suffix" do
      "germany's"
      |> Porter2.Word.remove_apostrophe_s_suffix
      |> expect |> to( eq "germany" )
    end

    it "should remove a ' suffix" do
      "his'"
      |> Porter2.Word.remove_apostrophe_s_suffix
      |> expect |> to( eq "his" )
    end

    it "should not remove other suffixes" do
      "his"
      |> Porter2.Word.remove_apostrophe_s_suffix
      |> expect |> to( eq "his" )
    end
  end

  describe ".replace_suffixes" do
    it "should replace a 'sses' suffix with 'ss' " do
      "asses"
      |> Porter2.Word.replace_suffixes
      |> expect |> to( eq "ass" )
    end

    context "words with an 'ied' suffix" do
      it "should replace the word 'ied' with ie" do
        "ied"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "ie" )
      end

      it "should replace the suffix with 'ie' if there is only one letter before it" do
        "tied"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "tie" )
      end

      it "should replace the suffix with 'i' if there is more than one letter before it" do
        "tried"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "tri" )
      end
    end

    context "words with an 'ies' suffix" do
      it "should replace the word 'ies' with ie" do
        "ies"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "ie" )
      end

      it "should replace the suffix with 'ie' if there is only one letter before it" do
        "ties"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "tie" )
      end

      it "should replace the suffix with 'i' if there is more than one letter before it" do
        "tries"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "tri" )
      end
    end

  
    context "words with an 's' suffix" do
      it "should remove the suffix if there is a vowel in the word that is not directly preceeding the suffix" do
        "gaps"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "gap" )
      end

      it "should remove the suffix if there is a vowel in the word that is not directly preceeding the suffix, but also a vowel that directly preceeds the suffix" do
        "kiwis" 
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "kiwi" )
      end

      it "should not change the word if there is no vowel in the word that is not directly preceeding the suffix" do
        "bcs"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "bcs" )
      end

      it "should not change the word if there is a vowel directly preceeding the suffix, but not before" do
        "gas"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "gas" )
      end
    end

    it "should replace an 'eed' suffix with 'ee' if it is in the r1 region"
    it "should not replace an 'eed' suffix if it is not in the r1 region"
    it "should replace an 'eedly' suffix with 'ee' if it is in the r1 region"
    it "should not replace an 'eedly' suffix with 'ee' if it is not in the r1 region"

    context "word with an 'ed' suffix" do
      context "when the preceeding word part contains a vowel" do
        it "should replace the suffix with 'e' if the suffix is preceeded by 'at'" do
          "luxuriated"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "luxuriate" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'bl'" do
          "somethingbled"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "somethingble" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'iz'" do
          "somethingized"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "somethingize" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a doubled letter" do
          "hopped"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "hop" )
        end

        it "should replace the suffix with an 'e' if the word without the suffix is short" do
          "hoped"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "hope" )
        end

        it "otherwise it should just remove the suffix" do
          "awarded"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "award" )
        end
      end

      it "should not change the word if the preceeding word part does not contain a vowel" do
        "med"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "med" )
      end

      it "should not change the word if there is no preceeding word part" do
        "ed"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "ed" )
      end
    end

    context "word with an 'edly' suffix" do
      context "when the preceeding word part contains a vowel" do
        it "should replace the suffix with 'e' if the suffix is preceeded by 'at'" do
          "luxuriatedly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "luxuriate" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'bl'" do
          "somethingbledly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "somethingble" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'iz'" do
          "somethingizedly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "somethingize" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a doubled letter" do
          "hoppedly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "hop" )
        end

        it "should replace the suffix with an 'e' if the word without the suffix is short" do
          "hopedly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "hope" )
        end

        it "otherwise it should just remove the suffix" do
          "awardedly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "award" )
        end
      end

      it "should not change the word if the preceeding word part does not contain a vowel" do
        "medly"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "medly" )
      end

      it "should not change the word if there is no preceeding word part" do
        "edly"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "edly" )
      end
    end

    context "word with an 'ing' suffix" do
      context "when the preceeding word part contains a vowel" do
        it "should replace the suffix with 'e' if the suffix is preceeded by 'at'" do
          "luxuriating"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "luxuriate" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'bl'" do
          "somethingbling"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "somethingble" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'iz'" do
          "somethingizing"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "somethingize" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a doubled letter" do
          "hopping"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "hop" )
        end

        it "should replace the suffix with an 'e' if the word without the suffix is short" do
          "hoping"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "hope" )
        end

        it "otherwise it should just remove the suffix" do
          "awarding"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "award" )
        end
      end

      it "should not change the word if the preceeding word part does not contain a vowel" do
        "ming"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "ming" )
      end

      it "should not change the word if there is no preceeding word part" do
        "ing"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "ing" )
      end
    end

    context "word with an 'ingly' suffix" do
      context "when the preceeding word part contains a vowel" do
        it "should replace the suffix with 'e' if the suffix is preceeded by 'at'" do
          "luxuriatingly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "luxuriate" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'bl'" do
          "somethingblingly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "somethingble" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'iz'" do
          "somethingizingly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "somethingize" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a doubled letter" do
          "hoppingly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "hop" )
        end

        it "should replace the suffix with an 'e' if the word without the suffix is short" do
          "hopingly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "hope" )
        end

        it "otherwise it should just remove the suffix" do
          "awardingly"
          |> Porter2.Word.replace_suffixes
          |> expect |> to( eq "award" )
        end
      end

      it "should not change the word if the preceeding word part does not contain a vowel" do
        "mingly"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "mingly" )
      end

      it "should not change the word if there is no preceeding word part" do
        "ingly"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "ingly" )
      end
    end


    it "should replace an 'ingly' suffix with 'e' if the suffix is preceeded by 'at'"
    it "should replace an 'ingly' suffix with 'e' if the suffix is preceeded by 'bl'"
    it "should replace an 'ingly' suffix with 'e' if the suffix is preceeded by 'iz'"
    it "should remove an 'ingly' suffix and remove one of a doubled letter if the suffix is preceeded by a doubled letter"
    it "should replace an 'ingly' suffix with an 'e' if the word without the suffix is short"
    it "should remove an 'ingly' suffix if it is not preceeded by 'at', 'bl' or 'iz'"

    it "should replace an 'ed' suffix with 'e' if the suffix is preceeded by 'at'"
    it "should replace an 'ed' suffix with 'e' if the suffix is preceeded by 'bl'"
    it "should replace an 'ed' suffix with 'e' if the suffix is preceeded by 'iz'"
    it "should remove an 'ed' suffix and remove one of a doubled letter if the suffix is preceeded by a doubled letter"
    it "should replace an 'ed' suffix with an 'e' if the word without the suffix is short"
    it "should remove an 'ed' suffix if it is not preceeded by 'at', 'bl' or 'iz'"


    it "should replace a 'y' suffix with an 'i' if it is preceeded by a non-vowel and the word is longer than 2 letters"
    it "should not replace a 'y' suffix if the suffix is not preceeded by a non-vowel"
    it "should not replace a 'y' suffix if the word is only 2 letters long and the suffix is preceeded by a vowel"
    it "should not replace a 'y' suffix if the word is only 2 letters long and the suffix is preceeded by a non-vowel"

    it "should replace a 'Y' suffix with an 'i' if it is preceeded by a non-vowel and the word is longer than 2 letters"
    it "should not replace a 'Y' suffix if the suffix is not preceeded by a non-vowel"
    it "should not replace a 'Y' suffix if the word is only 2 letters long and the suffix is preceeded by a vowel"
    it "should not replace a 'Y' suffix if the word is only 2 letters long and the suffix is preceeded by a non-vowel"
  end

  context ".r1_region" do
    context "for a word that contains a non-vowel following a vowel" do
      it "should return the word part after this non-vowel" do
        "foobar"
        |> Porter2.Word.r1_region
        |> expect |> to( eq "ar" )
      end
    end

    context "for a word that as no non-vowel following a vowel" do
      it "should return nil" do
        "foo"
        |> Porter2.Word.r1_region
        |> expect |> to( eq nil )
      end
    end

    context "for a word that has no word part following the vowel <> non-vowel sequence" do
      it "should return nil" do
        "it"
        |> Porter2.Word.r1_region
        |> expect |> to( eq nil )
      end
    end

    context "for a word that has no vowel" do
      it "should return nil" do
        "psst"
        |> Porter2.Word.r1_region
        |> expect |> to( eq nil )
      end
    end
  end

  context ".word_ends_in_short_syllable?" do
    context "for a word with a suffix of the type 'non-vowel' <> 'vowel' <> 'non-vowel other than w, x or Y'" do
      it "should return true" do
        "tetris"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_true )
      end
    end

    context "for a word with a suffix of the type 'non-vowel' <> 'vowel' <> 'w'" do
      it "should return false" do
        "now"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false )
      end
    end

    context "for a word with a suffix of the type 'non-vowel' <> 'vowel' <> 'x'" do
      it "should return false" do
        "sex"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false )
      end
    end

    context "for a word with a suffix of the type 'non-vowel' <> 'vowel' <> 'Y'" do
      it "should return false" do
        "feY"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false )
      end
    end

    context "for a word with a suffix of the type 'non-vowel' <> 'vowel'" do
      it "should return false" do
        "seemingly"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false )
      end
    end

    context "for a word with a suffix of the type 'non-vowel' <> 'non-vowel'" do
      it "should return false" do
        "ring"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false )
      end
    end

    context "for a word containing only one letter" do
      it "should return false" do
        "a"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false )
      end
    end
  end

  context ".is_word_short?" do
    context "if the word ends in a short syllable and r1_region is nil" do
      it "should return true" do
        "spin"
        |> Porter2.Word.is_word_short?
        |> expect |> to( be_true )
      end
    end

    # NOTE: if the r1 region is not nil, the word cannot end in a short syllable
    
    context "if the word does not end in a short syllable and r1_region is nil" do
      it "should return false" do
        "sex"
        |> Porter2.Word.is_word_short?
        |> expect |> to( be_false )
      end
    end

    context "if the word does not end in a short syllable and r1_region is not nil" do
      it "should return false" do
        "ring"
        |> Porter2.Word.is_word_short?\
        |> expect |> to( be_false )
      end
    end
  end
end

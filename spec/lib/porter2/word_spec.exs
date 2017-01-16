defmodule Porter2.WordSpec do
  use ESpec
  
  def expect_processed_word_to_match( word, expected ) do
    expect( tested_function().( word ) ) |> to( eq expected )
  end

  describe ".trim_leading_apostrophe" do
    let :tested_function, do: &Porter2.Word.trim_leading_apostrophe/1

    it "should remove a leading apostrophe in a word" do
      expect_processed_word_to_match( "'cos", "cos" )
    end

    it "should leave a word as is if it has no apostrophe" do
      expect_processed_word_to_match( "cos", "cos" )
    end
  end

  describe ".transform_vowel_ys" do
    let :tested_function, do: &Porter2.Word.transform_vowel_ys/1

    it "should transform an initial y to Y" do
      expect_processed_word_to_match( "you", "You" )
    end

    it "should transform a y after a vowel to Y" do
      expect_processed_word_to_match( "oy", "oY" )
    end

    it "should not transform a y after a consonant to Y" do
      expect_processed_word_to_match( "why", "why" )
    end
  end

  describe ".remove_apostrophe_s_suffix" do
    let :tested_function, do: &Porter2.Word.remove_apostrophe_s_suffix/1

    it "should remove a 's' suffix" do
      expect_processed_word_to_match( "foo's'", "foo" )
    end

    it "should remove a 's suffix" do
      expect_processed_word_to_match( "germany's", "germany" )
    end

    it "should remove a ' suffix" do
      expect_processed_word_to_match( "his'", "his" )
    end

    it "should not remove other suffixes" do
      expect_processed_word_to_match( "his", "his" )
    end
  end

  describe ".replace_suffixes" do
    let :tested_function, do: &Porter2.Word.replace_suffixes/1

    it "should replace a 'sses' suffix with 'ss' " do
      expect_processed_word_to_match( "asses", "ass" )
    end

    context "words with an 'ied' suffix" do
      it "should replace the word 'ied' with ie" do
        expect_processed_word_to_match( "ied", "ie" )
      end

      it "should replace the suffix with 'ie' if there is only one letter before it" do
        expect_processed_word_to_match( "tied", "tie" )
      end

      it "should replace the suffix with 'i' if there is more than one letter before it" do
        expect_processed_word_to_match( "tried", "tri" )
      end
    end

    context "words with an 'ies' suffix" do
      it "should replace the word 'ies' with ie" do
        expect_processed_word_to_match( "ies", "ie" )
      end

      it "should replace the suffix with 'ie' if there is only one letter before it" do
        expect_processed_word_to_match( "ties", "tie" )
      end

      it "should replace the suffix with 'i' if there is more than one letter before it" do
        expect_processed_word_to_match( "tries", "tri" )
      end
    end

  
    context "words with an 's' suffix" do
      it "should remove the suffix if there is a vowel in the word that is not directly preceeding the suffix" do
        expect_processed_word_to_match( "gaps", "gap" )
      end

      it "should remove the suffix if there is a vowel in the word that is not directly preceeding the suffix, but also a vowel that directly preceeds the suffix" do
        expect_processed_word_to_match( "kiwis", "kiwi" )
      end

      it "should not change the word if there is no vowel in the word that is not directly preceeding the suffix" do
        expect_processed_word_to_match( "bcs", "bcs" )
      end

      it "should not change the word if there is a vowel directly preceeding the suffix, but not before" do
        expect_processed_word_to_match( "gas", "gas" )
        "gas"
        |> Porter2.Word.replace_suffixes
        |> expect |> to( eq "gas" )
      end
    end

    context "word with an 'eed' suffix" do
      it "should replace the suffix with 'ee' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "stingweed", "stingwee" )
      end

      it "should not replace the suffix if the suffix is not in the r1 region" do
        expect_processed_word_to_match( "weed", "weed" )
      end
    end

    context "word with an 'eedly' suffix" do
      it "should replace the suffix with 'ee' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "stingweedly", "stingwee" )
      end

      it "should not replace the suffix with 'ee' if the suffix is not in the r1 region" do
        expect_processed_word_to_match( "weedly", "weedly" )
      end
    end

    context "word with an 'ed' suffix" do
      context "when the preceeding word part contains a vowel" do
        it "should replace the suffix with 'e' if the suffix is preceeded by 'at'" do
        expect_processed_word_to_match( "luxuriated", "luxuriate" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'bl'" do
          expect_processed_word_to_match( "somethingbled", "somethingble" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'iz'" do
          expect_processed_word_to_match( "somethingized", "somethingize" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a doubled letter" do
          expect_processed_word_to_match( "hopped", "hop" )
        end

        it "should replace the suffix with an 'e' if the word without the suffix is short" do
          expect_processed_word_to_match( "hoped", "hope" )
        end

        it "otherwise it should just remove the suffix" do
          expect_processed_word_to_match( "awarded", "award" )
        end
      end

      it "should not change the word if the preceeding word part does not contain a vowel" do
        expect_processed_word_to_match( "med", "med" )
      end

      it "should not change the word if there is no preceeding word part" do
        expect_processed_word_to_match( "ed", "ed" )
      end
    end

    context "word with an 'edly' suffix" do
      context "when the preceeding word part contains a vowel" do
        it "should replace the suffix with 'e' if the suffix is preceeded by 'at'" do
          expect_processed_word_to_match( "luxuriatedly", "luxuriate" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'bl'" do
          expect_processed_word_to_match( "somethingbledly", "somethingble" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'iz'" do
          expect_processed_word_to_match( "somethingizedly", "somethingize" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a doubled letter" do
          expect_processed_word_to_match( "hoppedly", "hop" )
        end

        it "should replace the suffix with an 'e' if the word without the suffix is short" do
          expect_processed_word_to_match( "hopedly", "hope" )
        end

        it "otherwise it should just remove the suffix" do
          expect_processed_word_to_match( "awardedly", "award" )
        end
      end

      it "should not change the word if the preceeding word part does not contain a vowel" do
        expect_processed_word_to_match( "medly", "medly" )
      end

      it "should not change the word if there is no preceeding word part" do
        expect_processed_word_to_match( "edly", "edly" )
      end
    end

    context "word with an 'ing' suffix" do
      context "when the preceeding word part contains a vowel" do
        it "should replace the suffix with 'e' if the suffix is preceeded by 'at'" do
          expect_processed_word_to_match( "luxuriating", "luxuriate" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'bl'" do
          expect_processed_word_to_match( "somethingbling", "somethingble" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'iz'" do
          expect_processed_word_to_match( "agonizing", "agonize" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a doubled letter" do
          expect_processed_word_to_match( "hopping", "hop" )
        end

        it "should replace the suffix with an 'e' if the word without the suffix is short" do
          expect_processed_word_to_match( "hoping", "hope" )
        end

        it "otherwise it should just remove the suffix" do
          expect_processed_word_to_match( "awarding", "award" )
        end
      end

      it "should not change the word if the preceeding word part does not contain a vowel" do
        expect_processed_word_to_match( "ming", "ming" )
      end

      it "should not change the word if there is no preceeding word part" do
        expect_processed_word_to_match( "ing", "ing" )
      end
    end

    context "word with an 'ingly' suffix" do
      context "when the preceeding word part contains a vowel" do
        it "should replace the suffix with 'e' if the suffix is preceeded by 'at'" do
          expect_processed_word_to_match( "luxuriatingly", "luxuriate" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'bl'" do
          expect_processed_word_to_match( "fumblingly", "fumble" )
        end

        it "should replace the suffix with 'e' if the suffix is preceeded by 'iz'" do
          expect_processed_word_to_match( "agonizingly", "agonize" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a doubled letter" do
          expect_processed_word_to_match( "hoppingly", "hop" )
        end

        it "should replace the suffix with an 'e' if the word without the suffix is short" do
          expect_processed_word_to_match( "hopingly", "hope" )
        end

        it "otherwise it should just remove the suffix" do
          expect_processed_word_to_match( "awardingly", "award" )
        end
      end

      it "should not change the word if the preceeding word part does not contain a vowel" do
        expect_processed_word_to_match( "mingly", "mingly" )
      end

      it "should not change the word if there is no preceeding word part" do
        expect_processed_word_to_match( "ingly", "ingly" )
      end
    end

    context "a word ending with 'y'" do
      it "should replace the suffix with an 'i' if it is preceeded by a non-vowel and the word is longer than 2 letters" do
        expect_processed_word_to_match( "cry", "cri" )
      end

      it "should not replace the suffix if the suffix is not preceeded by a non-vowel" do
        expect_processed_word_to_match( "say", "say" )
      end

      it "should not replace the suffix if the word is only 2 letters long and the suffix is preceeded by a vowel" do
        expect_processed_word_to_match( "oy", "oy" )
      end

      it "should not replace the suffix if the word is only 2 letters long and the suffix is preceeded by a non-vowel" do
        expect_processed_word_to_match( "by", "by" )
      end
    end


    context "a word ending with 'Y'" do
      it "should replace the suffix with an 'i' if it is preceeded by a non-vowel and the word is longer than 2 letters" do
        expect_processed_word_to_match( "crY", "cri" )
      end

      it "should not replace the suffix if the suffix is not preceeded by a non-vowel" do
        expect_processed_word_to_match( "saY", "saY" )
      end

      it "should not replace the suffix if the word is only 2 letters long and the suffix is preceeded by a vowel" do
        expect_processed_word_to_match( "oY", "oY" )
      end

      it "should not replace the suffix if the word is only 2 letters long and the suffix is preceeded by a non-vowel" do
        expect_processed_word_to_match( "bY", "bY" )
      end
    end
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
      it "should return \"\"" do
        "foo"
        |> Porter2.Word.r1_region
        |> expect |> to( eq "" )
      end
    end

    context "for a word that has no word part following the vowel <> non-vowel sequence" do
      it "should return \"\"" do
        "it"
        |> Porter2.Word.r1_region
        |> expect |> to( eq "" )
      end
    end

    context "for a word that has no vowel" do
      it "should return \"\"" do
        "psst"
        |> Porter2.Word.r1_region
        |> expect |> to( eq "" )
      end
    end
  end

  context ".reverse_r1_region" do
    context "for a word that contains a non-vowel following a vowel" do
      it "should return the word part after this non-vowel" do
        "foobar"
        |> String.reverse
        |> Porter2.Word.reverse_r1_region
        |> expect |> to( eq "ra" )
      end
    end

    context "for a word that as no non-vowel following a vowel" do
      it "should return \"\"" do
        "foo"
        |> String.reverse
        |> Porter2.Word.reverse_r1_region
        |> expect |> to( eq "" )
      end
    end

    context "for a word that has no word part following the vowel <> non-vowel sequence" do
      it "should return \"\"" do
        "it"
        |> String.reverse
        |> Porter2.Word.reverse_r1_region
        |> expect |> to( eq "" )
      end
    end

    context "for a word that has no vowel" do
      it "should return \"\"" do
        "psst"
        |> String.reverse
        |> Porter2.Word.reverse_r1_region
        |> expect |> to( eq "" )
      end
    end
  end

  context ".word_ends_in_short_syllable?" do
    context "for a word with a suffix of the type 'non-vowel' <> 'vowel' <> 'non-vowel other than w, x or Y'" do
      it "should return true" do
        "tetris"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_true() )
      end
    end

    context "for a word with a suffix of the type 'non-vowel' <> 'vowel' <> 'w'" do
      it "should return false" do
        "now"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false() )
      end
    end

    context "for a word with a suffix of the type 'non-vowel' <> 'vowel' <> 'x'" do
      it "should return false" do
        "sex"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false() )
      end
    end

    context "for a word with a suffix of the type 'non-vowel' <> 'vowel' <> 'Y'" do
      it "should return false" do
        "feY"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false() )
      end
    end

    context "for a word with a suffix of the type 'non-vowel' <> 'vowel'" do
      it "should return false" do
        "seemingly"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false() )
      end
    end

    context "for a word with a suffix of the type 'non-vowel' <> 'non-vowel'" do
      it "should return false" do
        "ring"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false() )
      end
    end

    context "for a word containing only one letter" do
      it "should return false" do
        "a"
        |> Porter2.Word.word_ends_in_short_syllable?
        |> expect |> to( be_false() )
      end
    end
  end

  context ".is_word_short?" do
    context "if the word ends in a short syllable and r1_region is nil" do
      it "should return true" do
        "spin"
        |> Porter2.Word.is_word_short?
        |> expect |> to( be_true() )
      end
    end

    # NOTE: if the r1 region is not nil, the word cannot end in a short syllable
    
    context "if the word does not end in a short syllable and r1_region is nil" do
      it "should return false" do
        "sex"
        |> Porter2.Word.is_word_short?
        |> expect |> to( be_false() )
      end
    end

    context "if the word does not end in a short syllable and r1_region is not nil" do
      it "should return false" do
        "ring"
        |> Porter2.Word.is_word_short?
        |> expect |> to( be_false() )
      end
    end
  end
end

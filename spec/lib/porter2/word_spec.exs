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

    context "words with an 'ss' suffix" do
      it "should not remove the suffix" do
        expect_processed_word_to_match( "fuss", "fuss" )
      end
    end

    context "words with an 'us' suffix" do
      it "should not remove the suffix" do
        expect_processed_word_to_match( "dingus", "dingus" )
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

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a double b" do
          expect_processed_word_to_match( "sobbingly", "sob" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a double d" do
          expect_processed_word_to_match( "forbiddingly", "forbid" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a double f" do
          expect_processed_word_to_match( "fluffingly", "fluf" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a double g" do
          expect_processed_word_to_match( "unflaggingly", "unflag" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a double m" do
          expect_processed_word_to_match( "swimmingly", "swim" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a double n" do
          expect_processed_word_to_match( "cunningly", "cun" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a double p" do
          expect_processed_word_to_match( "hoppingly", "hop" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a double r" do
          expect_processed_word_to_match( "jarringly", "jar" )
        end

        it "should remove the suffix and remove one of a doubled letter if the suffix is preceeded by a double t" do
          expect_processed_word_to_match( "fittingly", "fit" )
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

  context ".r2_region" do
    context "for a word with an empty r1 region" do
      it "should return \"\"" do
        "it"
        |> Porter2.Word.r2_region
        |> expect |> to( eq "" )
      end
    end

    context "for a word with an r1 region" do
      context "for a word that contains a non-vowel following a vowel within the r1 region" do
        it "should return the word part after this non-vowel" do
          "foobarbaz"
          |> Porter2.Word.r2_region
          |> expect |> to( eq "baz" )
        end
      end

      context "for a word that as no non-vowel following a vowel within the r1 region" do
        it "should return \"\"" do
          "foobao"
          |> Porter2.Word.r2_region
          |> expect |> to( eq "" )
        end
      end

      context "for a word that has no word part following the vowel <> non-vowel sequence within the r1 region" do
        it "should return \"\"" do
          "foobar"
          |> Porter2.Word.r2_region
          |> expect |> to( eq "" )
        end
      end

      context "for a word that has no vowel within the r1 region" do
        it "should return \"\"" do
          "foobrr"
          |> Porter2.Word.r2_region
          |> expect |> to( eq "" )
        end
      end
    end
  end

  context ".reverse_r2_region" do
    context "for a word with an empty r1 region" do
      it "should return \"\"" do
        "it"
        |> String.reverse
        |> Porter2.Word.reverse_r2_region
        |> expect |> to( eq "" )
      end
    end

    context "for a word with an r1 region" do
      context "for a word that contains a non-vowel following a vowel within the r1 region" do
        it "should return the word part after this non-vowel" do
          "foobarbaz"
          |> String.reverse
          |> Porter2.Word.reverse_r2_region
          |> expect |> to( eq "zab" )
        end
      end

      context "for a word that as no non-vowel following a vowel within the r1 region" do
        it "should return \"\"" do
          "foobao"
          |> String.reverse
          |> Porter2.Word.reverse_r2_region
          |> expect |> to( eq "" )
        end
      end

      context "for a word that has no word part following the vowel <> non-vowel sequence within the r1 region" do
        it "should return \"\"" do
          "foobar"
          |> String.reverse
          |> Porter2.Word.reverse_r2_region
          |> expect |> to( eq "" )
        end
      end

      context "for a word that has no vowel within the r1 region" do
        it "should return \"\"" do
          "foobrr"
          |> String.reverse
          |> Porter2.Word.reverse_r2_region
          |> expect |> to( eq "" )
        end
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

  context ".primary_special_suffix_replacement" do
    let :tested_function, do: &Porter2.Word.primary_special_suffix_replacement/1

    context "for a word with the suffix 'tional'" do
      it "should replace the suffix by 'tion' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "optional", "option" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "tritional", "tritional" )
      end
    end

    context "for a word with the suffix 'enci'" do
      it "should replace the suffix by 'ence' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "valenci", "valence" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "trenci", "trenci" )
      end
    end

    context "for a word with the suffix 'anci'" do
      it "should replace the suffix by 'ance' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "balanci", "balance" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "truanci", "truanci" )
      end
    end

    context "for a word with the suffix 'abli'" do
      it "should replace the suffix by 'able' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "favorabli", "favorable" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "viabli", "viabli" )
      end
    end

    context "for a word with the suffix 'entli'" do
      it "should replace the suffix by 'ent' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "virulentli", "virulent" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "gentli", "gentli" )
      end
    end

    context "for a word with the suffix 'izer'" do
      it "should replace the suffix by 'ize' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "vaporizer", "vaporize" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "sizer", "sizer" )
      end
    end
    context "for a word with the suffix 'ization'" do
      it "should replace the suffix by 'ize' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "nationalization", "nationalize" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "xization", "xization" )
      end
    end

    context "for a word with the suffix 'ational'" do
      it "should replace the suffix by 'ate' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "vocational", "vocate" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "national", "national" )
      end
    end

    context "for a word with the suffix 'ation'" do
      it "should replace the suffix by 'ate' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "sensation", "sensate" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "nation", "nation" )
      end
    end

    context "for a word with the suffix 'ator'" do
      it "should replace the suffix by 'ate' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "violator", "violate" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "gator", "gator" )
      end
    end

    context "for a word with the suffix 'alism'" do
      it "should replace the suffix by 'al' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "nationalism", "national" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "dualism", "dualism" )
      end
    end

    context "for a word with the suffix 'aliti'" do
      it "should replace the suffix by 'al' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "vitaliti", "vital" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "realiti", "realiti" )
      end
    end

    context "for a word with the suffix 'alli'" do
      it "should replace the suffix by 'al' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "verballi", "verbal" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "alli", "alli" )
      end
    end

    context "for a word with the suffix 'fulness'" do
      it "should replace the suffix by 'ful' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "usefulness", "useful" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "xfulness", "xfulness" )
      end
    end

    context "for a word with the suffix 'ousli'" do
      it "should replace the suffix by 'ous' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "zealousli", "zealous" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "piously", "piously" )
      end
    end

    context "for a word with the suffix 'ousness'" do
      it "should replace the suffix by 'ous' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "tediousness", "tedious" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "piousness", "piousness" )
      end
    end

    context "for a word with the suffix 'iveness'" do
      it "should replace the suffix by 'ive' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "aliveness", "alive" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "liveness", "liveness" )
      end
    end

    context "for a word with the suffix 'iviti'" do
      it "should replace the suffix by 'ive' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "nativiti", "native" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "naiviti", "naiviti" )
      end
    end

    context "for a word with the suffix 'biliti'" do
      it "should replace the suffix by 'ble' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "sensibiliti", "sensible" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "abiliti", "abiliti" )
      end
    end

    context "for a word with the suffix 'bli'" do
      it "should replace the suffix by 'ble' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "wobbli", "wobble" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "abli", "abli" )
      end
    end

    context "for a word with the suffix 'ogi'" do
      context "and the suffix is preceeded by an 'l'" do
        it "should replace the suffix by 'og' if the suffix is in the r1 region" do
          expect_processed_word_to_match( "virologi", "virolog" )
        end

        it "should not replace the suffix if it is not in the r1 region" do
          expect_processed_word_to_match( "xlogi", "xlogi" )
        end
      end

      context "and the suffix is not preceeded by an 'l'" do
        it "should not replace the suffix if it is in the r1 region" do
          expect_processed_word_to_match( "pedagogi", "pedagogi" )
        end

        it "should not replace the suffix if it is not in the r1 region" do
          expect_processed_word_to_match( "fogi", "fogi" )
        end
      end
    end

    context "for a word with the suffix 'fulli'" do
      it "should replace the suffix by 'ful' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "awefulli", "aweful" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "fulli", "fulli" )
      end
    end

    context "for a word with the suffix 'lessli'" do
      it "should replace the suffix by 'less' if the suffix is in the r1 region" do
        expect_processed_word_to_match( "effortlessli", "effortless" )
      end

      it "should not replace the suffix if it is not in the r1 region" do
        expect_processed_word_to_match( "xlessli", "xlessli" )
      end
    end

    context "for a word with the suffix 'li'" do
      context "and the suffix is preceeded by a valid 'li' ending" do
        context "for a 'c' ending" do
          it "should delete the suffix if the suffix is in the r1 region" do
            expect_processed_word_to_match( "publicli", "public" )
          end

          it "should not delete the suffix if it is not in the r1 region" do
            expect_processed_word_to_match( "cli", "cli" )
          end
        end

        context "for a 'd' ending" do
          it "should delete the suffix if the suffix is in the r1 region" do
            expect_processed_word_to_match( "wildli", "wild" )
          end

          it "should not delete the suffix if it is not in the r1 region" do
            expect_processed_word_to_match( "dli", "dli" )
          end
        end

        context "for an 'e' ending" do
          it "should delete the suffix if the suffix is in the r1 region" do
            expect_processed_word_to_match( "wiseli", "wise" )
          end

          it "should not delete the suffix if it is not in the r1 region" do
            expect_processed_word_to_match( "reli", "reli" )
          end
        end

        context "for a 'g' ending" do
          it "should delete the suffix if the suffix is in the r1 region" do
            expect_processed_word_to_match( "wrongli", "wrong" )
          end

          it "should not delete the suffix if it is not in the r1 region" do
            expect_processed_word_to_match( "xgli", "xgli" )
          end
        end

        context "for an 'h' ending" do
          it "should delete the suffix if the suffix is in the r1 region" do
            expect_processed_word_to_match( "richli", "rich" )
          end

          it "should not delete the suffix if it is not in the r1 region" do
            expect_processed_word_to_match( "xhli", "xhli" )
          end
        end

        context "for a 'k' ending" do
          it "should delete the suffix if the suffix is in the r1 region" do
            expect_processed_word_to_match( "sickli", "sick" )
          end

          it "should not delete the suffix if it is not in the r1 region" do
            expect_processed_word_to_match( "wkli", "wkli" )
          end
        end

        context "for an 'm' ending" do
          it "should delete the suffix if the suffix is in the r1 region" do
            expect_processed_word_to_match( "primli", "prim" )
          end

          it "should not delete the suffix if it is not in the r1 region" do
            expect_processed_word_to_match( "xmly", "xmly" )
          end
        end

        context "for an 'n' ending" do
          it "should delete the suffix if the suffix is in the r1 region" do
            expect_processed_word_to_match( "wanli", "wan" )
          end

          it "should not delete the suffix if it is not in the r1 region" do
            expect_processed_word_to_match( "xnli", "xnli" )
          end
        end

        context "for an 'r' ending" do
          it "should delete the suffix if the suffix is in the r1 region" do
            expect_processed_word_to_match( "surli", "sur" )
          end

          it "should not delete the suffix if it is not in the r1 region" do
            expect_processed_word_to_match( "xrli", "xrli" )
          end
        end

        context "for a 't' ending" do
          it "should delete the suffix if the suffix is in the r1 region" do
            expect_processed_word_to_match( "wetli", "wet" )
          end

          it "should not delete the suffix if it is not in the r1 region" do
            expect_processed_word_to_match( "xtli", "xtli" )
          end
        end
      end

      context "and the suffix is not preceeded by a valid 'li' ending" do
        it "should not delete the suffix if it is in the r1 region" do
          expect_processed_word_to_match( "exli", "exli" )
        end

        it "should not delete the suffix if it is not in the r1 region" do
          expect_processed_word_to_match( "ali", "ali" )
        end
      end
    end
  end

  context ".secondary_special_suffix_replacement" do
    let :tested_function, do: &Porter2.Word.secondary_special_suffix_replacement/1

    context "for a word with the suffix 'ational'" do
      it "should replace the suffix with 'ate' if the suffix is part of the r1 region" do
        expect_processed_word_to_match( "sensational", "sensate" )
      end

      it "should not replace the suffix if it is not part of the r1 region" do
        expect_processed_word_to_match( "rational", "rational" )
      end
    end

    context "for a word with the suffix 'tional'" do
      it "should replace the suffix with 'tion' if the suffix is part of the r1 region" do
        expect_processed_word_to_match( "optional", "option" )
      end

      it "should not replace the suffix if it is not part of the r1 region" do
        expect_processed_word_to_match( "ational", "ational" )
      end
    end

    context "for a word with the suffix 'alize'" do
      it "should replace the suffix with 'al' if the suffix is part of the r1 region" do
        expect_processed_word_to_match( "rationalize", "rational" )
      end

      it "should not replace the suffix if it is not part of the r1 region" do
        expect_processed_word_to_match( "malize", "malize" )
      end
    end

    context "for a word with the suffix 'ative'" do
      context "and suffix is in the r1 region" do
        it "should delete the suffix if it is also in the r2 region" do
          expect_processed_word_to_match( "ruminative", "rumin" )
        end

        it "should not delete the suffix if it is not also in the r2 region" do
          expect_processed_word_to_match( "talkative", "talkative" )
        end
      end

      it "should not delete the suffix if it is not part of the r1 region" do
        expect_processed_word_to_match( "native", "native" )
      end
    end

    context "for a word with the suffix 'icate'" do
      it "should replace the suffix with 'ic' if the suffix is part of the r1 region" do
        expect_processed_word_to_match( "replicate", "replic" )
      end

      it "should not replace the suffix if it is not part of the r1 region" do
        expect_processed_word_to_match( "bicate", "bicate" )
      end
    end

    context "for a word with the suffix 'iciti'" do
      it "should replace the suffix with 'ic' if the suffix is part of the r1 region" do
        expect_processed_word_to_match( "dupliciti", "duplic" )
      end

      it "should not replace the suffix if it is not part of the r1 region" do
        expect_processed_word_to_match( "diciti", "diciti" )
      end
    end

    context "for a word with the suffix 'ical'" do
      it "should replace the suffix with 'ic' if the suffix is part of the r1 region" do
        expect_processed_word_to_match( "comical", "comic" )
      end

      it "should not replace the suffix if it is not part of the r1 region" do
        expect_processed_word_to_match( "ical", "ical" )
      end
    end

    context "for a word with the suffix 'ness'" do
      it "should delete the suffix if the suffix is part of the r1 region" do
        expect_processed_word_to_match( "awefulness", "aweful" )
      end

      it "should not delete the suffix if it is not part of the r1 region" do
        expect_processed_word_to_match( "xness", "xness" )
      end
    end

    context "for a word with the suffix 'ful'" do
      it "should delete the suffix if the suffix is part of the r1 region" do
        expect_processed_word_to_match( "awful", "aw" )
      end

      it "should not delete the suffix if it is not part of the r1 region" do
        expect_processed_word_to_match( "aful", "aful" )
      end
    end
  end

  context ".primary_suffix_deletion" do
    let :tested_function, do: &Porter2.Word.primary_suffix_deletion/1

    context "for a word with the suffix 'al'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "sensational", "sensation" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "duval", "duval" )
      end
    end

    context "for a word with the suffix 'ance'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "transmittance", "transmitt" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "valance", "valance" )
      end
    end

    context "for a word with the suffix 'ence'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "virulence", "virul" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "thence", "thence" )
      end
    end

    context "for a word with the suffix 'er'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "zoroaster", "zoroast" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "yer", "yer" )
      end
    end

    context "for a word with the suffix 'ic'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "realistic", "realist" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "bic", "bic" )
      end
    end

    context "for a word with the suffix 'able'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "vulnerable", "vulner" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "worktable", "worktable" )
      end
    end

    context "for a word with the suffix 'ible'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "invincible", "invinc" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "vincible", "vincible" )
      end
    end

    context "for a word with the suffix 'ant'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "succulant", "succul" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "ant", "ant" )
      end
    end

    context "for a word with the suffix 'ement'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "understatement", "understat" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "vehement", "vehement" )
      end
    end

    context "for a word with the suffix 'ment'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "unemployment", "unemploy" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "worriment", "worriment" )
      end
    end

    context "for a word with the suffix 'ent'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "unintelligent", "unintellig" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "bent", "bent" )
      end
    end

    context "for a word with the suffix 'ism'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "sensationalism", "sensational" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "truism", "truism" )
      end
    end

    context "for a word with the suffix 'ate'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "suffrocate", "suffroc" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "fate", "fate" )
      end
    end

    context "for a word with the suffix 'iti'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "viciniti", "vicin" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "bitti", "bitti" )
      end
    end

    context "for a word with the suffix 'ous'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "veracious", "veraci" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "yous", "yous" )
      end
    end

    context "for a word with the suffix 'ive'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "unobtrusive", "unobtrus" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "wive", "wive" )
      end
    end

    context "for a word with the suffix 'ize'" do
      it "should delete the suffix if the suffix is part of the r2 region" do
        expect_processed_word_to_match( "trivialize", "trivial" )
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "mize", "mize" )
      end
    end

    context "for a word with the suffix 'ion'" do
      context "if the suffix is part of the r2 region" do
        it "should delete the suffix if the suffix is preceeded by an 's'" do
          expect_processed_word_to_match( "transmission", "transmiss" )
        end

        it "should delete the suffix if the suffix is preceeded by a 't'" do
          expect_processed_word_to_match( "virtualization", "virtualizat" )
        end

        it "should not delete the suffix if the suffix is not preceeded by an 's' or a 't'" do
          expect_processed_word_to_match( "zillion", "zillion" ) 
        end
      end

      it "should not replace the suffix if it is not part of the r2 region" do
        expect_processed_word_to_match( "ration", "ration" )
      end
    end
  end

  context ".secondary_suffix_deletion" do
    let :tested_function, do: &Porter2.Word.secondary_suffix_deletion/1

    context "for a word with the suffix 'e'" do
      context "if the suffix is within the r2 region" do
        it "should delete the suffix" do
          expect_processed_word_to_match( "yuletide", "yuletid" )
        end
      end

      context "if the suffix is not within the r2 region" do
        context "but the suffix is within the r1 region" do
          context "and the suffix is not preceeded by a short syllable" do
            it "should delete the suffix" do
              expect_processed_word_to_match( "overawe", "overaw" )
            end
          end

          context "and the suffix is preceeded by a short syllable" do
            it "should not delete the suffix" do
              expect_processed_word_to_match( "knife", "knife" )
            end
          end
        end

        context "and the suffix is also not part of the r1 region" do
          it "should not delete the suffix" do
            expect_processed_word_to_match( "ye", "ye" )
          end
        end
      end
    end

    context "for a word with the suffix 'l'" do
      context "if the suffix is not within the r2 region" do
        it "should not delete the suffix" do
          expect_processed_word_to_match( "yell", "yell" )
        end
      end

      context "if the suffix is within the r2 region" do
        context "and the suffix is preceeded by another 'l'" do
          it "should delete the suffix" do
            expect_processed_word_to_match( "uphill", "uphil" )
          end
        end

        context "and the suffix is not preceeded by an 'l'" do
          it "should not delete the suffix" do
            expect_processed_word_to_match( "withdrawal", "withdrawal" )
          end
        end
      end
    end
  end
end

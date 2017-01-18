defmodule Porter2Spec do
  use ESpec

  @word_to_stemmed_map %{
    "consign"       => "consign",
    "consigned"     => "consign",
    "consigning"    => "consign",
    "consignment"   => "consign",
    "consist"       => "consist",
    "consisted"     => "consist",
    "consistency"   => "consist",
    "consistent"    => "consist",
    "consistently"  => "consist",
    "consisting"    => "consist",
    "consists"      => "consist",
    "consolation"   => "consol",
    "consolations"  => "consol",
    "consolatory"   => "consolatori",
    "console"       => "consol",
    "consoled"      => "consol",
    "consoles"      => "consol",
    "consolidate"   => "consolid",
    "consolidated"  => "consolid",
    "consolidating" => "consolid",
    "consoling"     => "consol",
    "consolingly"   => "consol",
    "consols"       => "consol",
    "consonant"     => "conson",
    "consort"       => "consort",
    "consorted"     => "consort",
    "consorting"    => "consort",
    "conspicuous"   => "conspicu",
    "conspicuously" => "conspicu",
    "conspiracy"    => "conspiraci",
    "conspirator"   => "conspir",
    "conspirators"  => "conspir",
    "conspire"      => "conspir",
    "conspired"     => "conspir",
    "conspiring"    => "conspir",
    "constable"     => "constabl",
    "constables"    => "constabl",
    "constance"     => "constanc",
    "constancy"     => "constanc",
    "constant"      => "constant",
    "knack"         => "knack",
    "knackeries"    => "knackeri",
    "knacks"        => "knack",
    "knag"          => "knag",
    "knave"         => "knave",
    "knaves"        => "knave",
    "knavish"       => "knavish",
    "kneaded"       => "knead",
    "kneading"      => "knead",
    "knee"          => "knee",
    "kneel"         => "kneel",
    "kneeled"       => "kneel",
    "kneeling"      => "kneel",
    "kneels"        => "kneel",
    "knees"         => "knee",
    "knell"         => "knell",
    "knelt"         => "knelt",
    "knew"          => "knew",
    "knick"         => "knick",
    "knif"          => "knif",
    "knife"         => "knife",
    "knight"        => "knight",
    "knightly"      => "knight",
    "knights"       => "knight",
    "knit"          => "knit",
    "knits"         => "knit",
    "knitted"       => "knit",
    "knitting"      => "knit",
    "knives"        => "knive",
    "knob"          => "knob",
    "knobs"         => "knob",
    "knock"         => "knock",
    "knocked"       => "knock",
    "knocker"       => "knocker",
    "knockers"      => "knocker",
    "knocking"      => "knock",
    "knocks"        => "knock",
    "knopp"         => "knopp",
    "knot"          => "knot",
    "knots"         => "knot"
  }

  defp map_diff( map1, map2 ) when is_map( map1 ) and is_map( map2 ) do
    entries_in_both_maps = Map.take( map2, Map.keys( map1 ) )
    entries_only_in_map1 = Map.drop( map1, Map.keys( map2 ) )
    entries_only_in_map2 = Map.drop( map2, Map.keys( map1 ) )
    keys_with_differing_values = entries_in_both_maps
                                 |> Map.keys
                                 |> Enum.filter( &( Map.fetch( map1, &1 ) != Map.fetch( map2, &1 ) ) )
    IO.puts "Entries only in map 1: "
    IO.inspect entries_only_in_map1
    IO.puts "---"
    IO.puts "Entries only in map 2: "
    IO.inspect entries_only_in_map2
    IO.puts "---"
    IO.puts "Entries with differing values:"
    IO.puts "map 1"
    IO.inspect Map.take( map1, keys_with_differing_values )
    IO.puts "map 2"
    IO.inspect Map.take( map2, keys_with_differing_values )

  end
  describe ".stem" do
    it "should perform the stemming as expected" do
      actual_stemmed_map = for { word, _expected_stemmed } <- @word_to_stemmed_map,
                             into: %{},
                             do: { word, Porter2.stem( word ) }
      # map_diff( @word_to_stemmed_map, actual_stemmed_map )
      expect actual_stemmed_map |> to( eq @word_to_stemmed_map )
    end

  end

end

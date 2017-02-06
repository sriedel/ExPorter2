defmodule Porter2ServerSpec do
  use ESpec

  @word_to_stemmed_map %{
    ""              => "",
    "a"             => "a",
    "ab"            => "ab",
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

  before do
    { :ok, server } = Porter2.start_link
    { :shared, server: server }
  end

  finally do
    Porter2.stop( shared.server )
  end

  context "Stemming with a GenServer" do
    it "should perform the stemming as expected" do
      actual_stemmed_map = for { word, _expected_stemmed } <- @word_to_stemmed_map,
                             into: %{},
                             do: { word, Porter2.stem( shared.server, word ) }
      expect actual_stemmed_map |> to( eq @word_to_stemmed_map )
    end
  end
end

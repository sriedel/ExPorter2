defmodule Porter2 do
  use GenServer

  alias Porter2.Word

  @moduledoc """
  An implementation of the Porter2 word stemming algorithm for the english 
  language as described on 
  http://snowballstem.org/algorithms/english/stemmer.html

  Please note that special word forms are currently not regarded separately.
  """

  @doc """
  Stems the given word; works without the GenServer.
  """
  @spec stem( binary ) :: binary
  def stem( word ) when byte_size( word ) < 3, do: word
  def stem( word ) do
    Regex.replace( ~r/^'\s*/, String.trim( word ), "", global: false )
    |> String.downcase
    |> Word.transform_vowel_ys
    |> Word.remove_apostrophe_s_suffix
    |> Word.replace_suffixes # step 1a, 1b, 1c according to snowball
    |> Word.primary_special_suffix_replacement # Step 2 according to snowball
    |> Word.secondary_special_suffix_replacement # Step 3 according to snowball
    |> Word.primary_suffix_deletion # Step 4 according to snowball
    |> Word.secondary_suffix_deletion # step 5 according to snowball
    |> String.downcase
  end

  @doc """
    Starts the GenServer
  """
  @spec start_link() :: none
  def start_link, do: GenServer.start_link( __MODULE__, :ok, [] )

  @doc """
    Calls the given GenServer pid to stem the given word
  """
  @spec stem( pid, binary ) :: binary
  def stem( server, word ) do
    GenServer.call( server, { :stem, word } )
  end

  ### GenServer callbacks
  @doc """
    GenServer callback for initialization
  """
  @spec init( :ok ) :: { :ok, map }
  def init( :ok ), do: { :ok, %{} }

  @doc """
    GenServer callback for stemming a word.
  """
  @spec handle_call( { atom, binary } ) :: { atom, any }
  def handle_call( { :stem, word } ) when is_binary( word ) do
    { :reply, stem( word ) }
  end
end

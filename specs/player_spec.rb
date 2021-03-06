require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require 'pry'
require_relative '../lib/player'


# Get that nice colorized output
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

describe 'Player' do

  describe "name" do

    it 'gets a name' do
      Scrabble::Player.new("Chihiro").must_be_kind_of Scrabble::Player
      Scrabble::Player.new("Haku").name.must_be :==,"Haku"
      Scrabble::Player.new().name.must_equal "No Face"
    end
  end

  describe "plays" do

    it 'returns an array of words' do
      haku = Scrabble::Player.new("Haku")
      haku.plays = ["Haku", "dust bunnies"]
      haku.plays[0].must_be_kind_of String
      haku.plays[1].must_be_kind_of String
      haku.plays[0].wont_be_kind_of Integer

      haku.plays[0].wont_be_nil

      Scrabble::Player.new.plays.must_be_kind_of Array
    end
  end

  describe 'play(word)' do
    before do
      @first_player = Scrabble::Player.new("Yubaba")
    end
    it 'adds input to plays array' do
      @first_player.plays.must_be_empty #before any plays

      @first_player.play("dragon")
      @first_player.plays.must_include "dragon"
      @first_player.plays.wont_be_nil
      @first_player.plays.length.must_equal 1
      #binding.pry
    end

    it 'returns false if player has already won' do

      @first_player.total_score.wont_be:<,0

      @first_player.play("radish")
      @first_player.total_score.must_be:>,0


      @first_player.total_score = 110
      @first_player.play("rice").must_equal false
      #binding.pry
    end

    it 'returns the score of the word' do #if player didn't win
      @first_player.play("dragon").must_equal 8
      @first_player.play("dog").must_equal 5
      @first_player.plays.must_equal ["dragon", "dog"]
      @first_player.total_score.must_equal 13
    end
  end

  describe 'highest_scoring_word' do
    before do
      @first_player = Scrabble::Player.new("Yubaba")
    end
    it 'returns the highest scoring played word' do
      @first_player.play("dragon")
      @first_player.play("dog")

      @first_player.highest_scoring_word.must_equal "DRAGON"
    end
  end

  describe 'highest_word_score' do
    before do
      @first_player = Scrabble::Player.new("Yubaba")
    end

    it 'returns the highest_scoring_word score' do
      @first_player.play("dragon")
      @first_player.play("dog")

      @first_player.highest_word_score.must_equal 8
    end


  end

  describe "gets tiles" do
    it "is a collection of tiles with a max of 7 letters" do

      Scrabble::Player.new.tiles.must_be_kind_of Array

      Scrabble::Player.new.tiles.length.must_be:<,8

      Scrabble::Player.new.tiles.each do |letter|
        letter.must_be_kind_of String
      end

    end
  end



  describe "draw_tiles(tile_bag)" do
    before do
      @a_player = Scrabble::Player.new("Kamaji")
    end
    #binding.pry

    it 'fills tile array until it has 7 letters from tile bag' do
      bag = Scrabble::TileBag.new
      #@a_player.tile_bag

      @a_player.draw_tiles(bag)
      #binding.pry

      @a_player.tiles.length.must_equal 7

      # edge case! we put an eigth tile into tiles to make sure an ArgumentError was raised.
      #@a_player.tiles << "A"


      proc {
        @a_player.draw_tiles(bag)}.must_raise ArgumentError

      end
    end

    describe "game test" do

      it 'plays the game based on our code' do

        kamaji = Scrabble::Player.new("Kamaji")
        bag = Scrabble::TileBag.new
        kamaji.draw_tiles(bag)

        kamaji.play("cat")

        kamaji.tiles

        binding.pry



      end

    end



  end # end of all tests

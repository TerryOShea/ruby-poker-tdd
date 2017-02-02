require_relative 'card'

class Deck

  SUITS = [:hearts, :spades, :diamonds, :clubs]

  attr_reader :cards

  def initialize
    @cards = populate_deck
  end

  def shuffle!
    @cards.shuffle!
  end

  private

  def populate_deck
    deck = []

    SUITS.each do |suits|
      (2..14).each { |value| deck << Card.new(suits, value) }
    end

    deck
  end

end

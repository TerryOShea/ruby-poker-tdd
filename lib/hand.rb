require 'set'
require 'colorize'

class Hand

  SUITS = [:clubs, :diamonds, :hearts, :spades]

  COLOR = {
    :hearts => :red,
    :spades => :black,
    :diamonds => :red,
    :clubs => :black
  }

  attr_reader :multiples
  attr_accessor :cards

  def initialize(cards)
    validate_hand(cards)
    @cards = cards
    @multiples = get_multiples
  end

  def render
    ["|#{"\u203e".encode('utf-8') * 5}| " * 5,
     "|     | " * 5,
     "|#{@cards.map { |card| card.to_s.colorize(COLOR[card.suit]) }.join("| |")}|",
     "|     | " * 5,
     "|_____| " * 5,
     "   #{(0..4).to_a.join("       ")}"].join("\n")
  end

  def beats_hand?(other_hand)
    other_highest_card = other_hand.highest_card

    if is_straight_flush? || other_hand.is_straight_flush?
      return true unless other_hand.is_straight_flush?
      return false unless is_straight_flush?
      highest_card.beats?(other_highest_card)
    end

    if is_four_of_a_kind? || other_hand.is_four_of_a_kind?
      return true unless other_hand.is_four_of_a_kind?
      return false unless is_four_of_a_kind?

      @multiples.key(4) > other_hand.multiples.key(4)
    end

    if is_full_house? || other_hand.is_full_house?
      return true unless other_hand.is_full_house?
      return false unless is_full_house?

      @multiples.key(3) > other_hand.multiples.key(3)
    end

    if is_flush? || other_hand.is_flush?
      return true unless other_hand.is_flush?
      return false unless is_flush?

      highest_card.beats?(other_highest_card)
    end

    if is_straight? || other_hand.is_straight?
      return true unless other_hand.is_straight?
      return false unless is_straight?

      highest_card.beats?(other_highest_card)
    end

    if is_three_of_a_kind? || other_hand.is_three_of_a_kind?
      return true unless other_hand.is_three_of_a_kind?
      return false unless is_three_of_a_kind?

      @multiples.key(3) > other_hand.multiples.key(3)
    end

    if is_two_pair? || other_hand.is_two_pair?
      return true unless other_hand.is_two_pair?
      return false unless is_two_pair?

      pair_value = @multiples.select { |k, v| v == 2 }.keys
      other_pair_value = other_hand.multiples.select { |k, v| v == 2 }.keys

      pair_value.sort.last > other_pair_value.sort.last
    end

    if is_one_pair? || other_hand.is_one_pair?
      return true unless other_hand.is_one_pair?
      return false unless is_one_pair?

      @multiples.key(2) > other_hand.multiples.key(2)
    end

    highest_card.beats?(other_highest_card)
  end

  def highest_card
    @cards.sort_by { |card| card.value }.last
  end

  def is_straight_flush?
    is_flush? && is_straight?
  end

  def is_four_of_a_kind?
    @multiples.values.include?(4)
  end

  def is_full_house?
    @multiples.values.include?(3) && @multiples.values.include?(2)
  end

  def is_flush?
    @cards.map { |card| card.suit }.uniq.length == 1
  end

  def is_straight?
    values = @cards.map { |card| card.value }.sort
    values[0] + 4 == values[4] || values == [2, 3, 4, 5, 14]
  end

  def is_three_of_a_kind?
    @multiples.values.include?(3)
  end

  def is_two_pair?
    @multiples.values.sort == [1, 2, 2]
  end

  def is_one_pair?
    @multiples.values.include?(2)
  end

  private

  def validate_hand(cards)
    raise "hand size is invalid!" unless cards.length == 5

    uniqs = Set.new
    cards.each { |card| uniqs.add("#{card.suit} #{card.value}") }
    raise "cards are not unique!" unless uniqs.length == 5
  end

  def get_multiples
    values_count = Hash.new { |h, k| h[k] = 0 }
    @cards.each { |card| values_count[card.value] += 1 }
    values_count
  end

end

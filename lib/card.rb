class Card

  attr_reader :suit, :value

  SUITS = [:clubs, :diamonds, :hearts, :spades]

  SUIT_STRS = {
    :clubs => "\u2663".encode('utf-8'),
    :diamonds => "\u2666".encode('utf-8'),
    :spades => "\u2660".encode('utf-8'),
    :hearts => "\u2665".encode('utf-8')
  }

  VAL_STRS = {
    11 => "J",
    12 => "Q",
    13 => "K",
    14 => "A"
  }

  def initialize(suit, value)
    raise "invalid suit!" unless SUITS.include?(suit)
    raise "invalid value!" unless (2..14).include?(value)
    @suit = suit
    @value = value
  end

  def beats?(other_card)
    return true if @value > other_card.value
    return false if @value < other_card.value

    SUITS.index(@suit) > SUITS.index(other_card.suit)
  end

  def to_s
    val_str = ((2..10).include?(@value) ? @value : VAL_STRS[@value])
    "#{val_str.to_s.rjust(2)} #{SUIT_STRS[@suit]} "
  end

end

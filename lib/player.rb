class Player

  ACTIONS = [:fold, :see, :raise]

  attr_reader :name, :pot
  attr_accessor :hand

  def initialize(name)
    @name = name
    @pot = 100
    @hand = nil
  end

  def receive_hand(hand)
    @hand = hand
    render_hand
  end

  def render_hand
    puts "Here are your cards, #{@name}:"
    puts @hand.render

    sleep(2)
  end

  def collect_ante(center_pot)
    system("clear")
    puts "Current pot is #{@pot} ducats."
    puts "What's your ante, #{@name} (minimum 1)?"
    puts "You've got #{@pot} ducats."
    ante = gets.chomp.to_i
    @pot -= ante
    ante
  end

  def raise(min_bet)
    puts "What's your raise (must be higher than #{min_bet})?"
    raised_amount = gets.chomp.to_i
    @pot -= raised_amount
    raised_amount
  end

  def see(min_bet)
    puts "You've bet #{min_bet}"
    @pot -= min_bet
    sleep(1)
    puts "You now have #{@pot} ducats"
  end

  def discard
    render_hand

    # using regex to validate input instead of error-catching

    puts "#{@name}, would you like to discard any cards? (y/n)"
    will_discard = gets.chomp.downcase

    until will_discard =~ /^[yn]$/
      puts "I didn't understand that!"
      puts "Would you like to discard any cards? (y/n)"
      will_discard = gets.chomp.downcase
    end

    return [] if will_discard == "n"

    puts "Which cards would you like to discard? (e.g. 1, 2, 3)"
    to_discard = gets.chomp

    until to_discard =~ /^\d([, ]+\d)?([, ]+\d)?$/
      puts "I didn't understand that!"
      puts "Which cards would you like to discard? (e.g. 1, 2, 3)"
      to_discard = gets.chomp
    end

    to_discard.split(/[, ]+/).map(&:to_i)
  end

  def play_turn(center_pot, min_bet)
    puts "It's your turn, #{@name}!"

    puts "Current pot is #{center_pot} ducats"
    puts "You have #{@pot} ducats"
    puts "Minimum bet is #{min_bet}"

    puts "Would you like to fold, see, or raise?"
    reply = gets.chomp.downcase.to_sym

    until ACTIONS.include?(reply)
      puts "That wasn't one of the options!"
      puts "Would you like to fold, see, or raise?"
      reply = gets.chomp.downcase.to_sym
    end

    reply
  end

end

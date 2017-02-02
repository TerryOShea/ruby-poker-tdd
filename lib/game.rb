require_relative 'deck'
require_relative 'player'
require_relative 'hand'

class Game

  def initialize
    @deck = Deck.new
    @deck.shuffle!
    @pot = 0
    @cards_dealt = 0
    @minimum_bet = 1
  end

  def get_players
    puts "What are the (space-separated) names of our players today?"
    gets.chomp.split(" ").map { |name| Player.new(name) }
  end

  def switch_to_next_player
    system("clear")
    @current_player_index = (@current_player_index + 1) % @players.length
    @current_player = @players[@current_player_index]
  end

  def deal_cards(n)
    new_cards = @deck.cards[@cards_dealt...(@cards_dealt + n)]
    @cards_dealt += n
    new_cards
  end

  def play
    system("clear")
    puts "Welcome to Five Card Draw!"
    @players = get_players
    @current_player = @players[0]
    @current_player_index = 0

    collect_antes

    deal_round(1)

    discard_round

    deal_round(2)

    endgame
  end

  def endgame
    puts "Now whoever has the best hand wins!"
    winner = @players[0]
    @players.each_with_index do |player, i|
      puts "Here are #{player.name}'s cards:"
      puts player.hand.render
      winner = player if i != 0 && player.hand.beats_hand?(winner.hand)
      sleep(1)
    end
    announce_winner(winner)
  end

  def announce_winner(player)
    puts "#{player.name} is the winner!"
    puts "Game is over."
  end

  def deal_round(round)
    system("clear")
    puts "Now for the #{round == 1 ? "first" : "second"} dealing round"

    @players.length.times do
      if only_one_player?
        announce_winner(@players[0])
      else
        @current_player.receive_hand(Hand.new(deal_cards(5))) if round == 1
        puts @current_player.hand.render if round == 2

        turn = @current_player.play_turn(@pot, @minimum_bet)

        if turn == :fold
          puts "Goodbye, #{@current_player.name}!"
          @players.delete(@current_player)
          @current_player_index -= 1
          sleep(1)
        elsif turn == :raise
          raised_amount = @current_player.raise(@minimum_bet)
          @pot += raised_amount
          @minimum_bet = raised_amount
        else
          @current_player.see(@minimum_bet)
          @pot += @minimum_bet
        end

        puts "--------------------"
        switch_to_next_player
      end
    end
  end

  def discard_round
    system("clear")
    puts "And now for the discard round."

    @players.length.times do
      to_be_discarded = @current_player.discard

      if to_be_discarded.length > 0
        replacement_cards = deal_cards(to_be_discarded.length)
        new_cards = @current_player.hand.cards

        to_be_discarded.each_with_index do |replace_idx, i|
          new_cards[replace_idx] = replacement_cards[i]
        end

        new_hand = Hand.new(new_cards)
        @current_player.receive_hand(new_hand)
      end

      switch_to_next_player
    end
  end

  def only_one_player?
    @players.length == 1
  end

  def collect_antes
    @players.each do |player|
      @pot += player.collect_ante(@pot)
    end
    puts "Okay, let's deal and play!"
    puts "--------------------"

  end

end

if __FILE__ == $0
  g = Game.new
  g.play
  # puts g.deal_cards(5).join(" ")
  # puts g.deal_cards(5).join(" ")
  # puts g.deal_cards(3).join(" ")
  # puts g.deal_cards(1).join(" ")
  # puts g.deal_cards(2).join(" ")
end

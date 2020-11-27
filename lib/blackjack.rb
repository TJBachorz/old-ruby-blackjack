require 'pry'
require 'io/console'

def user_input
  gets.strip
end

def greeting
  puts "What is your name?"
  name = user_input
  puts ""
  puts "Welcome #{name}! Let's play Blackjack!"
  puts ""
  puts "Press any key to deal the first hand!"
  STDIN.getch
  name
end

ACES = [
  {:ace_of_hearts => 11}, 
  {:ace_of_clubs => 11}, 
  {:ace_of_diamonds => 11}, 
  {:ace_of_spades => 11}
]

deck = []

discard_pile = [
    {:two_of_hearts => 2},
    {:three_of_hearts => 3},
    {:four_of_hearts => 4},
    {:five_of_hearts => 5},
    {:six_of_hearts => 6},
    {:seven_of_hearts => 7},
    {:eight_of_hearts => 8},
    {:nine_of_hearts => 9},
    {:ten_of_hearts => 10},
    {:jack_of_hearts => 10},
    {:queen_of_hearts => 10},
    {:king_of_hearts => 10},
    {:ace_of_hearts => 11},
    {:two_of_spades => 2},
    {:three_of_spades => 3},
    {:four_of_spades => 4},
    {:five_of_spades => 5},
    {:six_of_spades => 6},
    {:seven_of_spades => 7},
    {:eight_of_spades => 8},
    {:nine_of_spades => 9},
    {:ten_of_spades => 10},
    {:jack_of_spades => 10},
    {:queen_of_spades => 10},
    {:king_of_spades => 10},
    {:ace_of_spades => 11},
    {:two_of_clubs => 2},
    {:three_of_clubs => 3},
    {:four_of_clubs => 4},
    {:five_of_clubs => 5},
    {:six_of_clubs => 6},
    {:seven_of_clubs => 7},
    {:eight_of_clubs => 8},
    {:nine_of_clubs => 9},
    {:ten_of_clubs => 10},
    {:jack_of_clubs => 10},
    {:queen_of_clubs => 10},
    {:king_of_clubs => 10},
    {:ace_of_clubs => 11},
    {:two_of_diamonds => 2},
    {:three_of_diamonds => 3},
    {:four_of_diamonds => 4},
    {:five_of_diamonds => 5},
    {:six_of_diamonds => 6},
    {:seven_of_diamonds => 7},
    {:eight_of_diamonds => 8},
    {:nine_of_diamonds => 9},
    {:ten_of_diamonds => 10},
    {:jack_of_diamonds => 10},
    {:queen_of_diamonds => 10},
    {:king_of_diamonds => 10},
    {:ace_of_diamonds => 11}
] 

def shuffle(deck, discard_pile)
  size = discard_pile.length
  until deck.length == size
    deck << discard_pile.slice!(rand(0...discard_pile.length))
  end
  deck
end


def deal_hand(deck, discard_pile)
  hand = Array.new
  until hand.length == 2
    hit(hand, deck, discard_pile)
  end
  hand
end

def hit(hand, deck, discard_pile)
  if deck.length >= 1
    hand << deck.shift
  else
    deck = shuffle(deck, discard_pile)
  end
end

def total_hand(hand)
  total = 0
  hand.each do |cards|
    cards.each do |card, points|
      total += points
    end
  end
  total 
end
  

def total_points(hand)
  aces_held = ace?(hand)
  total = total_hand(hand)
  if aces_held == 0
    return total
  else
    if total > 21
      until total <= 21 || aces_held == 0
        total -= 10
        aces_held -= 1
      end
    else
      return total
    end
  end
  total
end

def display_hand(hand, name)
  puts "#{name}'s HAND:"
  hand.each do |cards|
    cards.each do |card, points|
      puts card.to_s.upcase.gsub!("_", " ")
    end
  end
  puts "TOTAL: #{total_points(hand)}"
  puts ""
end

def display_dealer_hand(hand)
  puts "DEALER'S HAND:"
  counter = 0
  total = 0
  hand.each do |cards|
    cards.each do |card, points|
      if counter == 0
        puts card.to_s.upcase.gsub!("_", " ")
        total += points
        counter += 1
      end
    end
  end
  puts "FACE DOWN CARD"
  puts "TOTAL: #{total}"
  puts ""
end

def hit?(hand, deck, name, discard_pile)
  puts "Would you like to hit(h) or stay(s)?"
  input = user_input
  puts ""
  input
end

def ace?(hand)
  matches = hand & ACES
  return matches.length
end

def bust?(hand)
  if total_points(hand) > 21
    return true
  else
    return false
  end
end

def discard(hand, discard_pile)
  until hand == []
    discard_pile << hand.slice!(hand.length - 1)
  end
end

def winning_deal?(player_hand, dealer_hand, name)
  if total_points(player_hand) == 21 && total_points(dealer_hand) == 21
    return true
    puts "PUSH!"
    puts ""
  elsif total_points(dealer_hand) == 21
    return true
    puts "Dealer has Blackjack! You lose!"
    puts ""
  elsif total_points(player_hand) == 21
    return true
    puts "Blackjack! You win #{name}!"
    puts ""
  end
  false
end

def continue()
  puts "Press any key to continue..."
  STDIN.getch
  puts ""
end

def winning_hand(player_hand, dealer_hand)
  if total_points(player_hand) == total_points(dealer_hand)
    puts "PUSH!"
    puts ""
  elsif total_points(dealer_hand) > total_points(player_hand)
    display_hand(dealer_hand, 'DEALER')
    puts "DEALER Wins!"
    puts ""
  end
end

def play_again?()
  puts "Deal another hand? 'Y' or 'N'"
  puts ""
  input = user_input
  input
end

def run_blackjack(deck, discard_pile)
  name = greeting
  deck = shuffle(deck, discard_pile)
  while true do
    player_hand = deal_hand(deck, discard_pile)
    dealer_hand = deal_hand(deck, discard_pile)
    display_hand(player_hand, name)
    continue()
    display_dealer_hand(dealer_hand)
    unless winning_deal?(player_hand, dealer_hand, name)
      while true do
        command = hit?(player_hand, deck, name, discard_pile)
        if command == 'h'
          hit(player_hand, deck, discard_pile)
          display_hand(player_hand, name)
          if bust?(player_hand)
            break
          end
        elsif command == 's'
          puts "#{name} stays with a score of #{total_points(player_hand)}."
          puts ""
          continue()
          break
        else 
          puts "Invalid input"
          puts ""
        end
      end
      unless bust?(player_hand)
        until total_points(player_hand) <= total_points(dealer_hand) || bust?(dealer_hand)
          puts "DEALER hits..."
          puts ""
          continue()
          hit(dealer_hand, deck, discard_pile)
          display_hand(dealer_hand, "DEALER")
        end
        if bust?(dealer_hand)
          puts "DEALER busts! #{name} wins!"
          puts ""
          continue()
        elsif
          winning_hand(player_hand, dealer_hand)
        end
      end
      if bust?(player_hand)
        puts "Sorry #{name}, you bust!"
        puts ""
      end
    puts "Press any key to deal another hand..."
    STDIN.getch
    puts ""
    discard(player_hand, discard_pile)
    discard(dealer_hand, discard_pile)
    end
  end
end
require './board'

class InvalidMoveError < RuntimeError
end

OPPONENT_TURN = {white: :black, black: :white}

class Game

	def initialize
		@board = Board.new
		@turn = :white
	end
	
	def play
	

		while true 
			begin 
			start_pos, end_pos, add_moves = get_moves_from_user(@turn)
			make_moves(start_pos, end_pos, add_moves)

			rescue InvalidMoveError
				puts "Invalid move, try again"
				retry
			end

			puts "Your opponent has #{@board.count_pieces(OPPONENT_TURN[@turn])} pieces left."

			if @board.count_pieces(OPPONENT_TURN[@turn]) == 0
				puts "Congratulations #{turn}, you won"
				break
			end 
			@turn = OPPONENT_TURN[@turn]
		end

		puts "Game over."
		return nil
	end
	
	def make_moves(start_pos, end_pos, add_moves)
		if add_moves == [] 
			make_single_move(start_pos, end_pos) 
		else
			make_multiple_moves(start_pos, end_pos, add_moves)
		end
	end

	def make_multiple_moves(start_pos, end_pos, add_moves)
		moves_to_process = process_moves(start_pos, end_pos, add_moves)
		multiple_valid_moves = handle_multiple_moves(moves_to_process, @turn)
			
		multiple_valid_moves.each_with_index  do |start_pos, index|
			next if multiple_valid_moves[index+1].nil?
			end_pos = multiple_valid_moves[index+1]
			@board.move(start_pos, end_pos) 
		end
	end

	def make_single_move(start_pos, end_pos) 
		if @board.is_valid_move?(start_pos, end_pos, @turn)
			@board.move(start_pos, end_pos) 
		else
			raise InvalidMoveError
		end
	end

	def handle_multiple_moves(moves_to_process, turn)
		#takes an array of multiple moves, tests them, and returns array if all valid

		dup_board = @board.dup
		moves_to_make = moves_to_process
		moves_to_make.each_with_index  do |start_pos, index|
			end_pos = moves_to_make[index+1]
			next if end_pos.nil?
			raise InvalidMoveError unless dup_board.is_valid_move?(start_pos, end_pos, @turn)
			dup_board.move(start_pos, end_pos)
		end
		moves_to_make
	end

	def get_moves_from_user(turn)
		begin
			print @board.render+"\n\n"
			print "It is #{turn}'s turn.\n\n"
			puts "Enter a move (start):\n"
			start_pos = process_user_entry
			puts "Enter a move (destination):\n"
			end_pos = process_user_entry
			puts "Enter more moves if you want (1,2 3,4 5,6):\n"
			add_moves = process_user_entry

			processed_moves = process_moves(start_pos, end_pos, add_moves) 

			rescue InvalidMoveError
				puts "Invalid move, try again"
			retry 
		end
		
		return start_pos, end_pos, add_moves
	end

	def process_user_entry
		gets.chomp.delete(", ").split("").to_a.map!{|el| el.to_i}
	end

	def process_moves(start_pos, end_pos, add_moves)
		all_moves = start_pos + end_pos + add_moves
		processed_moves = []
		#make an array of this format with moves entered: [[start], [second], [third]...]
		all_moves.each_with_index {|el, i| processed_moves << [el, all_moves[i+1]] if 
			i.even?}
		processed_moves
	end


end

game = Game.new
game.play
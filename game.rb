require './board'

class InvalidMoveError < RuntimeError
end

TURN = {true: :white, false: :black}
OPPONENT_TURN = {white: :black, black: :white}

class Game

	def initialize
		@board = Board.new
	end
	
	def play
	@turn = TURN[:true]

		while true 

			start_pos, end_pos, add_moves = get_moves_from_user(@turn)

			p add_moves
			p start_pos
			p end_pos
			p @turn 
			p @board.is_valid_move?(start_pos, end_pos, @turn)

			if add_moves == [] && @board.is_valid_move?(start_pos, end_pos, @turn)
				@board.move(start_pos, end_pos)
			elsif !@board.is_valid_move?(start_pos, end_pos, @turn)
				raise InvalidMoveError
			else
				moves_to_process = process_moves(start_pos, end_pos, add_moves)
				multiple_valid_moves = handle_multiple_moves(moves_to_process, @turn)
				
				multiple_valid_moves.each_with_index  do |start_pos, index|
					next if multiple_valid_moves[index+1].nil?
					end_pos = multiple_valid_moves[index+1]
					@board.move(start_pos, end_pos) 
				end
			end

			if @board.count_pieces(OPPONENT_TURN[@turn]) == 0
				puts "Congratulations #{turn}, you won"
				break
			end 
			@turn = OPPONENT_TURN[@turn]
		end
		puts "Game over."
		return nil
	end

	def handle_multiple_moves(moves_to_process, turn)
		
		dup_board = @board.dup
		
		moves_to_process.each_with_index  do |start_pos, index|
			end_pos = moves_to_process[index+1]
			next if end_pos.nil?
			raise InvalidMoveError unless dup_board.is_valid_move?(start_pos, end_pos, @turn)
			dup_board.move(start_pos, end_pos)
		end

		moves_to_process
	end

	def get_moves_from_user(turn)
		print @board.render+"\n\n"
		print "It is #{turn}'s turn.\n\n"

		puts "Enter a move (start):\n"
		start_pos = gets.chomp.delete(", ").split("").to_a.map!{|el| el.to_i}
		puts "Enter a move (destination):\n"
		end_pos = gets.chomp.delete(", ").split("").to_a.map!{|el| el.to_i}
		puts "Enter more moves if you want (1,2 3,4 5,6):\n"
		add_moves = gets.chomp.delete(", ").split("").to_a.map!{|el| el.to_i}
		return start_pos, end_pos, add_moves
	end

	def process_moves(start_pos, end_pos, add_moves)
		all_moves = start_pos + end_pos + add_moves
		moves_to_process = []
		all_moves.each_with_index {|el, i| moves_to_process << [el, all_moves[i+1]] if 
			i.even?}
		moves_to_process
	end
end

game = Game.new
game.play
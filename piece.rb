require 'debugger.rb'

class Piece

	SLIDE_MOVE_DIRS = [
		[-1,1],
		[-1,-1],
		[1,-1],
		[1,1]
	]

	JUMP_MOVE_DIRS = [
		[-2, 2],
		[-2,-2],
		[2,2],
		[2,-2]
	]

	OPPONENT_COLOR = {:white => :black, :black => :white}

	attr_accessor :pos, :color, :symbol, :king

	def initialize(pos, color, board)
		@pos, @color, @board = pos, color, board #white or black; white start in rows 7-5; black in 0-3
		@king = false
		@opponent_color = OPPONENT_COLOR[@color]
		board.add_piece(self, @pos)
	end

	# def delta
	# 	if @king == false
	# 		return -1 if color == :white
	# 		return 1 if color == :black 
	# 	end
	# 	#figure out how to handle king direction
	# end

	def all_moves
		sliding_moves = []
		jump_moves = []

		if @king == false 
			if @color == :black 
				SLIDE_MOVE_DIRS[2..3].each {|dir| sliding_moves << [@pos[0] + dir[0], @pos[1] + dir[1]]}
				JUMP_MOVE_DIRS[2..3].each {|dir| jump_moves << [@pos[0] + dir[0], @pos[1] + dir[1]]}
			elsif @color == :white
				SLIDE_MOVE_DIRS[0..1].each {|dir| sliding_moves << [@pos[0] + dir[0], @pos[1] + dir[1]]}
				JUMP_MOVE_DIRS[0..1].each {|dir| jump_moves << [@pos[0] + dir[0], @pos[1] + dir[1]]}
			end
		end

		if @king == true
			SLIDE_MOVE_DIRS.each {|dir| sliding_moves << [@pos[0] + dir[0], @pos[1] + dir[1]]}
			JUMP_MOVE_DIRS.each {|dir| jump_moves << [@pos[0] + dir[0], @pos[1] + dir[1]]}
		end

		return sliding_moves, jump_moves 
	end

	def legal_moves
		legal_moves_list = []
		possible_slide_moves, possible_jump_moves = self.all_moves
		possible_moves = possible_jump_moves + possible_slide_moves
		possible_moves.each {|move| legal_moves_list << move if can_perform_slide?(move) || can_perform_jump?(move)}
		legal_moves_list
	end

	def can_move_to?(end_pos)
		return true if can_perform_slide?(end_pos) || can_perform_jump?(end_pos)
	end

	def square_between(end_pos)
		#find square between self and destination
		i = (end_pos[0] + @pos[0])/2
		j = (end_pos[1] + @pos[1])/2
		return [i, j]
	end

	def on_board?(pos)
		return false if pos[0] < 0 || pos[0] > 7 || pos[1] < 0 || pos[1] > 7
		true
	end 

	def can_perform_slide?(end_pos)
		return false unless self.on_board?(end_pos) 
		sliding_moves, jump_moves = self.all_moves 
		return false unless sliding_moves.include?(end_pos) && @board.empty?(end_pos)
		true
	end

	def can_perform_jump?(end_pos)

		return false unless self.on_board?(end_pos) 
		sliding_moves, jump_moves = self.all_moves 
		return false unless jump_moves.include?(end_pos) 
		return false unless @board.empty?(end_pos)
		square_between = square_between(end_pos)
		return false if @board[square_between] == nil 
		return false unless @board[square_between].color == @opponent_color
		true
	end

	def maybe_promote
		if (self.color == :white && self.pos[0] == 0) || (self.color == :red && self.pos == 7)
			@king = true
		end
	end

	def render 
		@king == false ? "\u2B24" : "\u265A"
	end

end


		
		





		




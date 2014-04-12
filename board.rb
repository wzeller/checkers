require './piece.rb'
require 'colorize'
require 'debugger.rb'

class Board

	def initialize(fill_board = true)
		make_starting_grid(fill_board) 
	end

	def pieces
		@rows.flatten.compact
	end
	
	def make_starting_grid(fill_board)
		@rows = Array.new(8){Array.new(8)}
		#when piece is created it is added to the board
		if fill_board
			[:black, :white].each do |color|
				fill_three_rows(color)
			end
		end
	end

	def fill_three_rows(color)
		i = (color == :black) ? (0..2) : (5..7)
		#generate j positions for all checkers (even numbers mod % 7)
		j = {true => [0,2,4,6], false => [1,3,5,7]}
		piece_count = 0
		i.to_a.each do |i|
			j[i.even?].each do |j|
				Piece.new([i,j], color, self)
			end
		end
	end

	def [](pos)
		i, j = pos 
		@rows[i][j]
	end

	def []=(pos, piece)
		raise "invalid pos" unless valid_pos?(pos)
		i, j = pos
    	@rows[i][j] = piece
    end

	def empty?(pos)
		self[pos].nil?
	end

	def valid_pos?(pos)
		i, j = pos
		return false if i < 0 || i > 7 || j < 0 || j > 7
		true
	end

	def add_piece(piece, pos)
		raise "position not empty" unless empty?(pos)
		self[pos] = piece
	end

	def render

		print " 0 1 2 3 4 5 6 7\n"
    	@rows.map.with_index do |row, i|
     		row.map.with_index do |piece, j|

				#add row numbers at end of row
				j == 7 ? a = "#{i}" : a = ""
				
				#alternate background of squares
        		(i+j).even? ? background_color = :red : background_color = :light_black 

        		if piece.nil? 
        			("  ").colorize({background: background_color})+a 
        		else 
        			(piece.render + " ").colorize({color: piece.color, background: background_color})+a
        		end

      		end.join
    	end.join("\n")
 	end

 	def move(start_pos, end_pos)
 		i, j = start_pos
 		a, b = end_pos
 		piece = self[start_pos]

 		#erase captured piece
 		x = (i+a)/2
 		y = (j+b)/2
		captured_pos = [x,y]

		self[captured_pos] = nil unless b - j == 1
	

		#move piece to destination square
		add_piece(self[start_pos], end_pos)
		#erase start
		self[start_pos] = nil
		piece.pos = end_pos 
		piece.maybe_promote
	end

	def count_pieces(color)
		pieces.select{|piece| piece.color == color}.count
	end

	def dup
		
	    new_board = Board.new(false)

    	pieces.each do |piece|
      		Piece.new(piece.pos, piece.color, new_board)
    	end

   		new_board
  	end

	def is_valid_move?(start_pos, end_pos, color)
		return false unless self[start_pos].legal_moves.include?(end_pos)
		return false unless self[start_pos].color == color
		true 
	end

end


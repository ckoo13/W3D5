require "byebug"
require_relative "tree"

class KnightPathFinder
    attr_reader :pos, :considered_positions, :root_node

    def initialize(pos)
        @pos = pos
        @root_node = PolyTreeNode.new(pos)
        @considered_positions = [pos]
        
        self.build_move_tree
    end

    def self.valid_moves(pos)
        row, col = pos

        #create all 8 possible moves in a hash into a 2-D array
        
        potential_moves =  [
        [row-2, col-1],
             [row-2,col+1],
                [row-1,col-2],
                    [row-1,col+2],
                        [row+1,col-2],
                            [row+1,col+2],
                                [row+2,col+1],
                                    [row+2,col-1]
        ]

        #filter out values that don't fit in the board that are in the 2-D array
        
        potential_moves.select { |array| array.first >= 0 && array.first <= 7 && array.last >=0 && array.last <= 7} 
    end

    def new_move_positions(pos)
        
        #call self.valid_moves(pos)
        moves = KnightPathFinder.valid_moves(pos)

        #filter out any positions that are already in @considered_positions
        remaining_moves = moves.select { |array| !@considered_positions.include?(array)}

        # debugger
        @considered_positions += remaining_moves

        remaining_moves
    end

    def build_move_tree
        queue = [self.root_node]

        until queue.empty?
            ele = queue.shift
            #grab the new move positions that are possible
            pos_children = self.new_move_positions(ele.value)

            #make nodes out of each position in pos_children
            childs = pos_children.map { |pos| PolyTreeNode.new(pos)}

            #have to add these nodes to the children of ele (current node)
            childs.each do |node|
                ele.add_child(node)
            end
            
            #making each position in childs a PolyTreeNode and adding it to the queue
            #debugger
            ele.children.each do |node|
                queue << node
            end
        end
    end

    def find_path(end_pos)
        trace_path_back(self.root_node.bfs(end_pos))
    end

    def trace_path_back(node)
        answer = [node]

        while !node.parent.nil?
            answer << node.parent.value
            node = node.parent
        end

        answer.reverse
    end
end
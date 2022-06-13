require "byebug"

class PolyTreeNode
    attr_reader :value, :parent ,:children
    
    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end
    
    def parent=(node)
        if self.parent.nil?
            @parent = node
            if !self.parent.children.include?(self)
            self.parent.children << self
            end
        else
            self.parent.children.delete(self)
            @parent = node
            if !node.nil? && !self.parent.children.include?(self) 
                self.parent.children << self
            end
        end
    end

    def add_child(node)
        node.parent = self

        if !self.children.include?(node)
            self.children << node
        end
    end 

    def remove_child(node)
        node.parent = nil

        if !self.children.include?(node)
            raise "#{node} is not a child"
        else
            self.children.delete(node)
        end
    end

    def dfs(target)
        #base cases
        return nil if self.nil?
        return self if self.value == target

        #inductive step
        # debugger
        self.children.each do |child|
            result = child.dfs(target)
            return result unless result.nil?
        end

        nil
    end

    def bfs(target)
        queue = [self]

        until queue.empty?
            ele = queue.shift
            # debugger
            if ele.value == (target)
                return ele
            else
                ele.children.each { |child| queue << child}
            end
        end

        nil
    end 

    def inspect
        self.value
    end
end     
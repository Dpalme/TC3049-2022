# Domain-Specific Language Pattern
# Date: 28-Apr-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar

# Prints the result of the evaluation
def show(res)
    puts "Result = #{res}"
end

# Does the comparisson between two objects given a verb (winner|loser)
def _cmp(obj1, obj2, verb)
    # If they are the same, they tie
    if obj1.to_sym == obj2.to_sym
        puts "#{obj1} tie (#{verb} #{obj1})"
        return obj1
    end
    # If it's wins don't have the other object, return false
    return false if !obj1::WINS.has_key?(obj2.to_sym)
    
    # Logs the action with corresponding verb
    puts "#{obj1} #{obj1::WINS.fetch(obj2.to_sym)} #{obj2}" +
    " (#{verb} #{verb == 'winner' ? obj1 : obj2 })"
    # Returns the correct object given the verb
    return obj1 if verb == "winner"
    obj2
end


class Element
    # Default constants
    WINS = {}
    SYM = :Element

    def self.+(other)
        # Checks if self wins or if other wins w/ winner verb
        tmp = _cmp(self, other, "winner")
        return tmp if tmp
        _cmp(other, self, "winner")
    end

    def self.-(other)
        # Checks if self wins or if other wins w/ loser verb
        tmp = _cmp(other, self, "loser")
        return tmp if tmp
        _cmp(self, other, "loser")
    end

    def self.to_sym
        self::SYM
    end
end

class Scissors < Element
    # Defines w/ what verb it wins against others
    WINS = {Paper: "cut", Lizard: "decapitate"}
    # Sets constant class symbol
    SYM = :Scissors
end

class Paper < Element
    # Defines w/ what verb it wins against others
    WINS = {Rock: "covers", Spock: "disproves"}
    # Sets constant class symbol
    SYM = :Paper
end

class Spock < Element
    # Defines w/ what verb it wins against others
    WINS = {Scissors: "smashes", Rock: "vaporizes"}
    # Sets constant class symbol
    SYM = :Spock
end

class Rock < Element
    # Defines w/ what verb it wins against others
    WINS = {Lizard: "crushes", Scissors: "crushes"}
    # Sets constant class symbol
    SYM = :Rock
end

class Lizard < Element
    # Defines w/ what verb it wins against others
    WINS = {Paper: "eats", Spock: "poisons"}
    # Sets constant class symbol
    SYM = :Lizard
end
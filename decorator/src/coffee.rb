# Decorator Pattern
# Date: 21-Apr-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar

# Base beverage class
class Beverage
  # Stores name and cost information
  def initialize(description, cost)
    @description = description
    @cost = cost
  end

  # returns the description
  def description
    @description
  end

  # returns the cost
  def cost
    @cost
  end
end

# Values for Dark Roast
class DarkRoast < Beverage
  def initialize
    super("Dark Roast Coffee", 0.99)
  end
end

# Values for Espresso
class Espresso < Beverage
  def initialize
    super("Espresso", 1.99)
  end
end

# Values for House Blend
class HouseBlend < Beverage
  def initialize
    super("House Blend Coffee", 0.89)
  end
end

# Inherits from beverage to save a line of code
class Condiment < Beverage
  # Adds reference to next-in-line element
  def initialize(description, cost, decorating)
    super(description, cost)
    @decorating = decorating
  end

  # Recursive calls next-in-line description and joins them with ', '
  def description
    @decorating.description + ", " + @description
  end

  # Recursive calls next-in-line cost and sums them all
  def cost
    @decorating.cost + @cost
  end
end

# Values for Mocha
class Mocha < Condiment
  def initialize(decorating)
    super("Mocha", 0.2, decorating)
  end
end

# Values for Whip
class Whip < Condiment
  def initialize(decorating)
    super("Whip", 0.1, decorating)
  end
end

# Values for Soy
class Soy < Condiment
  def initialize(decorating)
    super("Soy", 0.15, decorating)
  end
end

# Values for milk
class Milk < Condiment
  def initialize(decorating)
    super("Milk", 0.1, decorating)
  end
end

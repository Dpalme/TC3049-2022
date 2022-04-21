# Decorator Pattern
# Date: 21-Apr-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar

require "minitest/autorun"
require_relative "coffee"

class CoffeeTest < Minitest::Test
  def test_espresso
    beverage = Espresso.new
    assert_equal("Espresso", beverage.description)
    assert_equal(1.99, beverage.cost)
  end

  def test_dark_roast
    beverage = DarkRoast.new
    beverage = Milk.new(beverage)
    beverage = Mocha.new(beverage)
    beverage = Mocha.new(beverage)
    beverage = Whip.new(beverage)
    assert_equal("Dark Roast Coffee, Milk, Mocha, Mocha, Whip",
                 beverage.description)
    assert_equal(1.59, beverage.cost)
  end

  def test_house_blend
    beverage = HouseBlend.new
    beverage = Soy.new(beverage)
    beverage = Mocha.new(beverage)
    beverage = Whip.new(beverage)
    assert_equal("House Blend Coffee, Soy, Mocha, Whip",
                 beverage.description)
    assert_equal(1.34, beverage.cost)
  end
end

# Student class
# Date: 03-Mar-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar

class Student
  include Enumerable
  # Note: This class does not support the max, min,
  # or sort methods.

  # Student class constructor
  def initialize(id, name, grades)
    @id = id
    @name = name
    @grades = grades
  end

  # Stringifies the current user
  def inspect
    "Student(#{@id}, #{@name.inspect})"
  end

  # Computes the average grade
  def grade_average
    @grades.inject(:+) / @grades.size
  end

  # Iterator over the properties of Student
  def each(&block)
    yield @id
    yield @name
    @grades.each(&block)
    yield grade_average
  end
end

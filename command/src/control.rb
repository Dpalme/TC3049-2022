# Command Pattern
# Date: 10-Mar-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar

# Base class for controller
class RemoteControlWithUndo
  # Array for commands on the on and off columns
  def initialize
    @on_commands = []
    @off_commands = []
    no_command = NoCommand.new
    7.times do
      @on_commands << no_command
      @off_commands << no_command
    end
    @undo_command = no_command
  end

  # Assigns on and off commands to a row of buttons
  def set_command(slot, on_command, off_command)
    @on_commands[slot] = on_command
    @off_commands[slot] = off_command
  end

  # Executes on command and updates undo variable
  def on_button_w
    as_pushed(slot)

    @on_commands[slot].execute
    @undo_command = @on_commands[slot]
  end

  # Executes off command and updates undo variable
  def off_button_was_pushed(slot)
    @off_commands[slot].execute
    @undo_command = @off_commands[slot]
  end

  # Executes undo command
  def undo_button_was_pushed()
    @undo_command.undo
  end

  # Prints out all current button mappings and the last command served
  def inspect
    string_buff = ["\n------ Remote Control -------\n"]
    @on_commands.zip(@off_commands).each_with_index do |commands, i|
      on_command, off_command = commands
      string_buff << "[slot #{i}] #{on_command.class}  " "#{off_command.class}\n"
    end
    string_buff << "[undo] #{@undo_command.class}\n"
    string_buff.join
  end
end

# Base no command class
class NoCommand
  def execute
  end

  def undo
  end
end

# Base class for light object
class Light
  # Makes the level attribute publicly readable
  attr_reader :level

  def initialize(location)
    @location = location
    @level = 0
  end

  # Turns light on
  def on
    @level = 100
    puts "Light is on"
  end

  # Turns light off
  def off
    @level = 0
    puts "Light is off"
  end

  # Dims light to specific level
  def dim(level)
    @level = level
    if level == 0
      off
    else
      puts "Light is dimmed to #{@level}%"
    end
  end
end

class CeilingFan
  # Access these constants from outside this class as
  # CeilingFan::HIGH, CeilingFan::MEDIUM, and so on.
  HIGH = 3
  MEDIUM = 2
  LOW = 1
  OFF = 0

  # makes the speed attribute publicly readable
  attr_reader :speed

  # Creates a new fan
  def initialize(location)
    @location = location
    @speed = OFF
  end

  # Sets fan to high
  def high
    @speed = HIGH
    puts "#{@location} ceiling fan is on high"
  end

  # Sets fan to medium
  def medium
    @speed = MEDIUM
    puts "#{@location} ceiling fan is on medium"
  end

  # Sets fan to low
  def low
    @speed = LOW
    puts "#{@location} ceiling fan is on low"
  end

  # Turns fan off
  def off
    @speed = OFF
    puts "#{@location} ceiling fan is off"
  end
end

# Base class to generalize commands because OOP is awful like this
class LightCommand
  # Gets light and it's current level as baseline
  def initialize(light)
    @light = light
    @last = light.level
  end

  # Compares stored level to return light to previous level
  def undo
    return @light.on if @last == 100
    return @light.off if @last == 0
    @light.dim(@last)
  end
end

class LightOnCommand < LightCommand
  # Stores current level and turns light on
  def execute
    @last = @light.level
    @light.on
  end
end

class LightOffCommand < LightCommand
  # Stores current level and turns light on
  def execute
    @last = @light.level
    @light.off
  end
end

# Base class to generalize commands because OOP is awful like this
class CeilingFanCommand
  # Stores reference to fan & it's current speed
  def initialize(fan)
    @fan = fan
    @last = fan.speed
  end

  # Returns to the last speed before being executed
  def undo
    return @fan.low if @last == CeilingFan::LOW
    return @fan.medium if @last == CeilingFan::MEDIUM
    @fan.high
  end
end

# Specification for the fan high command
class CeilingFanHighCommand < CeilingFanCommand
  def execute
    @last = @fan.speed
    @fan.high
  end
end

# Specification for the fan medium command
class CeilingFanMediumCommand < CeilingFanCommand
  def execute
    @last = @fan.speed
    @fan.medium
  end
end

# Specification for the fan off command
class CeilingFanOffCommand < CeilingFanCommand
  # Stores reference to fan it's current speed
  def execute
    @last = @fan.speed
    @fan.off
  end
end

# imo, this is not a scalable pattern
# having 50 different classes for each command where they all share
# a single function and by storing previous states

# A better implementation would be a transactional system where all
# commands are stored in a ledger and the state is calculated by
# computing all commands. this way, the undo action can be generalized
# and it's only a matter of having a pointer to signal the last
# command to compute. This way, we don't need so many classes and can
# store changes made to the objects.

# A crude implementation would look somthing like:

# Controller:
#   ledger: Enumerable<Function<>>
#   onCommands: Enumerable<Function<>>
#   offCommands: Enumerable<Function<>>
#   lastCommand: int
#
#   def getState
#     ledger.take(lastCommand) {|cmd| cmd.call}
#   end

# An example command would be:
#
# lamp = Lamp.new("Living room")
# onCommand = Proc.new do
#   lamp.on
# end
# offCommand = Proc.new do
#   lamp.off
# end
# controller.set_command(0, onCommand, offCommand)

# This way, we're storing functions as functions instead of building
# objects to act as functions

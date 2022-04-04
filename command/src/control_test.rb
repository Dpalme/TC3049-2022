# Command Pattern
# Date: 10-Mar-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar

require "minitest/autorun"
require "stringio"
require_relative "control"

class ControlTest < Minitest::Test
  # intercepts stdout, creates rc and sets initial conditions
  def setup
    set_stdout
    @rc = RemoteControlWithUndo.new
    set_light
    set_fan
  end

  # calls reset_stdout
  def teardown
    reset_stdout
  end

  # Intercepts stdout for unit tests
  def set_stdout
    @out = StringIO.new
    @old_stdout = $stdout
    $stdout = @out
  end

  # Returns stdout to stdout
  def reset_stdout
    $stdout = @old_stdout
  end

  # Sets initial conditions for living room light
  def set_light
    light = Light.new("Living Room")
    light_on = LightOnCommand.new(light)
    light_off = LightOffCommand.new(light)
    @rc.set_command(0, light_on, light_off)
  end

  # Sets initial conditions for living room ceiling fan commands
  def set_fan
    fan = CeilingFan.new("Living Room")
    fan_medium = CeilingFanMediumCommand.new(fan)
    fan_high = CeilingFanHighCommand.new(fan)
    fan_off = CeilingFanOffCommand.new(fan)
    @rc.set_command(1, fan_medium, fan_off)
    @rc.set_command(2, fan_high, fan_off)
  end

  # Unit test for the implementation of LightOn and LightOff Command
  def test_light
    @rc.on_button_was_pushed(0)
    @rc.off_button_was_pushed(0)
    p @rc
    @rc.undo_button_was_pushed
    @rc.off_button_was_pushed(0)
    @rc.on_button_was_pushed(0)
    p @rc
    @rc.undo_button_was_pushed
    assert_equal \
      "Light is on\n" \
      "Light is off\n" \
      "\n------ Remote Control -------\n" \
      "[slot 0] LightOnCommand  LightOffCommand\n" \
      "[slot 1] CeilingFanMediumCommand  CeilingFanOffCommand\n" \
      "[slot 2] CeilingFanHighCommand  CeilingFanOffCommand\n" \
      "[slot 3] NoCommand  NoCommand\n" \
      "[slot 4] NoCommand  NoCommand\n" \
      "[slot 5] NoCommand  NoCommand\n" \
      "[slot 6] NoCommand  NoCommand\n" \
      "[undo] LightOffCommand\n\n" \
      "Light is on\n" \
      "Light is off\n" \
      "Light is on\n" \
      "\n------ Remote Control -------\n" \
      "[slot 0] LightOnCommand  LightOffCommand\n" \
      "[slot 1] CeilingFanMediumCommand  CeilingFanOffCommand\n" \
      "[slot 2] CeilingFanHighCommand  CeilingFanOffCommand\n" \
      "[slot 3] NoCommand  NoCommand\n" \
      "[slot 4] NoCommand  NoCommand\n" \
      "[slot 5] NoCommand  NoCommand\n" \
      "[slot 6] NoCommand  NoCommand\n" \
      "[undo] LightOnCommand\n\n" \
      "Light is off\n", @out.string
  end

  # Unit test for the Fan High, Medium and Off commands
  def test_fan
    @rc.on_button_was_pushed(1)
    @rc.off_button_was_pushed(1)
    p @rc
    @rc.undo_button_was_pushed
    @rc.on_button_was_pushed(2)
    p @rc
    @rc.undo_button_was_pushed
    assert_equal \
      "Living Room ceiling fan is on medium\n" \
      "Living Room ceiling fan is off\n" \
      "\n------ Remote Control -------\n" \
      "[slot 0] LightOnCommand  LightOffCommand\n" \
      "[slot 1] CeilingFanMediumCommand  CeilingFanOffCommand\n" \
      "[slot 2] CeilingFanHighCommand  CeilingFanOffCommand\n" \
      "[slot 3] NoCommand  NoCommand\n" \
      "[slot 4] NoCommand  NoCommand\n" \
      "[slot 5] NoCommand  NoCommand\n" \
      "[slot 6] NoCommand  NoCommand\n" \
      "[undo] CeilingFanOffCommand\n\n" \
      "Living Room ceiling fan is on medium\n" \
      "Living Room ceiling fan is on high\n" \
      "\n------ Remote Control -------\n" \
      "[slot 0] LightOnCommand  LightOffCommand\n" \
      "[slot 1] CeilingFanMediumCommand  CeilingFanOffCommand\n" \
      "[slot 2] CeilingFanHighCommand  CeilingFanOffCommand\n" \
      "[slot 3] NoCommand  NoCommand\n" \
      "[slot 4] NoCommand  NoCommand\n" \
      "[slot 5] NoCommand  NoCommand\n" \
      "[slot 6] NoCommand  NoCommand\n" \
      "[undo] CeilingFanHighCommand\n\n" \
      "Living Room ceiling fan is on medium\n", @out.string
  end
end

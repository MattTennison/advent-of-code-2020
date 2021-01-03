# frozen_string_literal: true

class Command
  def initialize
    @has_ran = false
  end

  attr_reader :has_ran

  def run(current_accumulator, current_command_position)
    @has_ran = true
    execute_command(current_accumulator, current_command_position)
  end

  def execute_command(_current_accumulator, _current_command_position)
    raise 'execute_command should be overriden in child class'
  end
end

class NoOp < Command
  def execute_command(current_accumulator, current_command_position)
    {
      accumulator: current_accumulator,
      command_position: current_command_position + 1
    }
  end
end

class Accumulator < Command
  def initialize(accumulator_delta)
    @accumulator_delta = accumulator_delta
  end

  def execute_command(current_accumulator, current_command_position)
    {
      accumulator: current_accumulator + @accumulator_delta,
      command_position: current_command_position + 1
    }
  end
end

class Jump < Command
  def initialize(jump_delta)
    @jump_delta = jump_delta
  end

  def execute_command(current_accumulator, current_command_position)
    {
      accumulator: current_accumulator,
      command_position: current_command_position + @jump_delta
    }
  end
end

class CommandFactory
  def self.for(operation, argument)
    case operation
    when 'acc'
      Accumulator.new(argument)
    when 'jmp'
      Jump.new(argument)
    else
      NoOp.new
    end
  end
end

class Boot
  def initialize(instructions)
    @instructions = instructions
  end

  def execute
    position = 0
    accumulator = 0

    commands = @instructions.map(&:command)
    while next_command(commands, position) != nil && !next_command(commands, position).has_ran
      command_to_execute = next_command(commands, position)

      result = command_to_execute.run(accumulator, position)
      position = result[:command_position]
      accumulator = result[:accumulator]
    end

    { accumulator: accumulator, has_terminated: next_command(commands, position).nil? }
  end

  def next_command(commands, position)
    commands.at(position)
  end
end

class CorruptBootRepair
  def initialize(instructions)
    @instructions = instructions
  end

  def valid_instructions
    initial_result = Boot.new(@instructions).execute
    return @instructions if initial_result[:has_terminated]

    swap_instruction = 0
    swappable_instructions = @instructions.select { |i| i.operation.eql?('jmp') || i.operation.eql?('nop') }

    while swap_instruction < swappable_instructions.count
      instruction_to_swap = swappable_instructions.at(swap_instruction)
      instructions = @instructions.map do |i|
        if i.eql?(instruction_to_swap)
          new_operation = i.operation.eql?('jmp') ? 'nop' : 'jmp'
          Instruction.replace_operation(i, new_operation)
        else
          i
        end
      end

      result = Boot.new(instructions).execute
      return instructions if result[:has_terminated]

      swap_instruction += 1
    end
  end
end

class Instruction
  def initialize(instruction)
    operation, argument = instruction.split
    @operation = operation
    @argument = argument.to_i
  end

  attr_reader :operation, :argument

  def command
    CommandFactory.for(operation, argument)
  end

  def self.replace_operation(instruction, new_operation)
    Instruction.new("#{new_operation} #{instruction.argument}")
  end
end

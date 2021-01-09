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
    super()
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
    super()
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
    while !next_command(commands, position).nil? && !next_command(commands, position).has_ran
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

    swappable_instructions = @instructions.select { |i| i.operation.eql?('jmp') || i.operation.eql?('nop') }
    swappable_instructions.each do |instruction|
      instructions = swap_instruction(instructions: @instructions, instruction_to_swap: instruction)

      result = Boot.new(instructions).execute
      return instructions if result[:has_terminated]
    end
  end

  private

  def swap_instruction(instructions:, instruction_to_swap:)
    clone_of_instructions = instructions.clone
    new_operation = instruction_to_swap.operation.eql?('jmp') ? 'nop' : 'jmp'
    index_of_instruction = instructions.index(instruction_to_swap)

    clone_of_instructions[index_of_instruction] = Instruction.replace_operation(instruction_to_swap, new_operation)

    clone_of_instructions
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

module DigdagUtils
  class Task
    attr_reader :id, :name

    def initialize(
      id: nil,
      name: nil
    )
      @id = id
      @name = name
    end

    def self.from_command_output(block)
      id = nil
      name = nil

      if m = block.match(/  id: (\d+)/)
        id = m[1].to_i
      end
      if m = block.match(/  name: (.+)/)
        name = m[1]
      end

      Task.new(
        id: id,
        name: name,
      )
    end
  end
end

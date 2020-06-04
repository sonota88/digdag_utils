module DigdagUtils
  class Task
    attr_reader :id, :name, :state

    def initialize(
      id: nil,
      name: nil,
      state: nil
    )
      @id = id
      @name = name
      @state = state
    end

    def self.from_command_output(block)
      id = nil
      name = nil
      state = nil

      if m = block.match(/  id: (\d+)/)
        id = m[1]
      end
      if m = block.match(/  name: (.+)/)
        name = m[1]
      end
      if m = block.match(/  state: (.+)/)
        state = m[1]
      end

      Task.new(
        id: id,
        name: name,
        state: state
      )
    end
  end
end

module DigdagUtils
  class Session
    attr_reader :id, :time, :attempt_id

    def initialize(
      id: nil,
      time: nil,
      attempt_id: nil
    )
      @id = id
      @time = time
      @attempt_id = attempt_id # last attempt id
    end

    def self.from_command_output(block)
      id = nil
      time = nil
      attempt_id = nil

      if m = block.match(/  session id: (\d+)/)
        id = m[1].to_i
      end
      if m = block.match(/  session time: (.+)/)
        time = Time.parse(m[1])
      end
      if m = block.match(/  attempt id: (\d+)/)
        attempt_id = m[1].to_i
      end

      Session.new(
        id: id,
        time: time,
        attempt_id: attempt_id,
      )
    end
  end
end

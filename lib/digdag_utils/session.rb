require_relative "attempt"

module DigdagUtils
  class Session
    attr_reader :id, :time, :attempts

    def initialize(
      id: nil,
      time: nil,
      attempts: nil
    )
      @id = id
      @time = time
      @attempts = attempts
    end

    def self.from_command_output(block)
      id = nil
      time = nil
      attempt_id = nil

      if m = block.match(/  session id: (\d+)/)
        id = m[1]
      end
      if m = block.match(/  session time: (.+)/)
        time = Time.parse(m[1])
      end
      if m = block.match(/  attempt id: (\d+)/)
        attempt_id = m[1]
      end

      attempts = [
        Attempt.new(id: attempt_id),
      ]

      Session.new(
        id: id,
        time: time,
        attempts: attempts,
      )
    end

    def self.from_api_response(data)
      new(
        id:   data["id"],
        time: data["sessionTime"],
      )
    end

    def last_attempt
      if @attempts.size == 1
        @attempts[0]
      else
        raise "not yet impl"
      end
    end

    def to_plain
      {
        id: @id,
        time: @time,
        attempts: @attempts,
      }
    end
  end
end

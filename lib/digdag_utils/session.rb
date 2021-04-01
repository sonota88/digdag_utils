require_relative "attempt"

module DigdagUtils
  class Session
    attr_reader :id, :time, :attempts
    attr_reader :workflow

    def initialize(
      id: nil,
      time: nil,
      attempts: nil,
      last_attempt: nil,
      workflow: nil
    )
      @id = id
      @time = time
      @attempts = attempts
      @last_attempt = last_attempt
      @workflow = workflow
    end

    def self.from_command_output(block)
      id = nil
      time = nil
      attempt_id = nil

      if (m = block.match(/  session id: (\d+)/))
        id = m[1]
      end
      if (m = block.match(/  session time: (.+)/))
        time = Time.parse(m[1])
      end
      if (m = block.match(/  attempt id: (\d+)/))
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
        time: Time.parse(data["sessionTime"]),
        last_attempt: data["lastAttempt"]
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
      plain = {
        id: @id,
        time: @time,
        attempts: @attempts,
        last_attempt: @last_attempt
      }

      if @time
        plain[:time] = @time.getlocal.iso8601
      end

      if @workflow
        plain[:workflow] = @workflow.to_plain
      end

      plain
    end
  end
end

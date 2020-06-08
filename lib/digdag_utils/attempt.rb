module DigdagUtils
  class Attempt
    attr_reader :id

    def initialize(
      id: nil,
      done:             nil,
      success:          nil,
      cancel_requested: nil
    )
      @id = id
      @done             = done
      @success          = success
      @cancel_requested = cancel_requested
    end
  end
end

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

    def self.from_api_response(data)
      new(
        id:               data["id"],
        done:             data["done"],
        success:          data["success"],
        cancel_requested: data["cancelRequested"]
      )
    end

    def to_plain
      {
        id:               @id,
        done:             @done,
        success:          @success,
        cancel_requested: @cancel_requested,
      }
    end
  end
end

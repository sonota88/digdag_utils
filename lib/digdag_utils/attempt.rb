module DigdagUtils
  class Attempt
    attr_reader :id
    attr_reader :session

    def initialize(
      id: nil,
      done:             nil,
      success:          nil,
      cancel_requested: nil,
      session:          nil
    )
      @id = id
      @done             = done
      @success          = success
      @cancel_requested = cancel_requested
      @session          = session
    end

    def self.from_api_response(data)
      wf = Workflow.new(
        id:   data["workflow"]["id"],
        name: data["workflow"]["name"]
      )

      sess = Session.new(
        id: data["sessionId"],
        time: Time.parse(data["sessionTime"]),
        workflow: wf
      )

      new(
        id:               data["id"],
        done:             data["done"],
        success:          data["success"],
        cancel_requested: data["cancelRequested"],
        session:          sess
      )
    end

    def to_plain
      {
        id:               @id,
        done:             @done,
        success:          @success,
        cancel_requested: @cancel_requested,
        session:          @session.to_plain,
      }
    end
  end
end

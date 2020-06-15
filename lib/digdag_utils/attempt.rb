module DigdagUtils
  class Attempt
    attr_reader :id
    attr_reader :session

    def initialize(
      id: nil,
      done:             nil,
      success:          nil,
      cancel_requested: nil,
      created_at:       nil,
      finished_at:      nil,
      session:          nil
    )
      @id = id
      @done             = done
      @success          = success
      @cancel_requested = cancel_requested
      @created_at       = created_at
      @finished_at      = finished_at
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
        created_at:       DigdagUtils.from_plain_time(data["createdAt"]),
        finished_at:      DigdagUtils.from_plain_time(data["finishedAt"]),
        session:          sess
      )
    end

    def to_plain
      {
        id:               @id,
        done:             @done,
        success:          @success,
        cancel_requested: @cancel_requested,
        created_at:       DigdagUtils.to_plain_time(@created_at),
        finished_at:      DigdagUtils.to_plain_time(@finished_at),
        session:          @session.to_plain,
      }
    end
  end
end

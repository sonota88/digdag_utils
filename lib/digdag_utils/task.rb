module DigdagUtils
  class Task
    attr_reader :id, :state
    attr_reader :full_name
    attr_reader :parent_id, :upstreams
    attr_reader :is_group
    attr_reader :cancel_requested

    def initialize(
      id: nil,
      state: nil,
      full_name:        nil,
      cancel_requested: nil,
      parent_id:        nil,
      upstreams:        nil,
      is_group:         nil
    )
      @id = id
      @state = state
      @full_name        = full_name
      @cancel_requested = cancel_requested
      @parent_id        = parent_id
      @upstreams        = upstreams
      @is_group         = is_group
    end

    def self.from_command_output(block)
      id = nil
      full_name = nil
      state = nil

      if m = block.match(/  id: (\d+)/)
        id = m[1]
      end
      if m = block.match(/  name: (.+)/)
        full_name = m[1]
      end
      if m = block.match(/  state: (.+)/)
        state = m[1]
      end

      Task.new(
        id: id,
        full_name: full_name,
        state: state
      )
    end

    def self.from_api_response(data)
      new(
        id:               data["id"],
        full_name:        data["fullName"],
        state:            data["state"],
        cancel_requested: data["cancelRequested"],
        parent_id:        data["parentId"],
        upstreams:        data["upstreams"],
        is_group:         data["isGroup"]
      )
    end
  end
end

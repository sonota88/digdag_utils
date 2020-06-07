module DigdagUtils
  class Workflow
    attr_reader :id, :name

    def initialize(
          id: nil,
          name: nil
        )
      @id = id
      @name = name
    end

    def self.from_api_data(data)
      new(
        id:   data["id"],
        name: data["name"],
      )
    end

    def to_plain
      {
        id:   @id,
        name: @name,
      }
    end
  end
end

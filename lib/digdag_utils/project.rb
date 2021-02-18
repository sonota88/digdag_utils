module DigdagUtils
  class Project
    attr_reader :id, :name, :revision

    def initialize(
          id: nil,
          name: nil,
          revision: nil
        )
      @id = id
      @name = name
      @revision = revision
    end

    def self.from_api_response(data)
      new(
        id:   data["id"],
        name: data["name"]
      )
    end

    def to_plain
      {
        id:   @id,
        name: @name,
        revision: @revision,
      }
    end
  end
end

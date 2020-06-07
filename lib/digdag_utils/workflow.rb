module DigdagUtils
  class Workflow
    attr_reader :id, :name, :project

    def initialize(
          id: nil,
          name: nil,
          project: nil
        )
      @id = id
      @name = name
      @project = project
    end

    def self.from_api_response(data)
      project = DigdagUtils::Project.new(
        id: data["project"]["id"]
      )

      new(
        id:   data["id"],
        name: data["name"],
        project: project
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

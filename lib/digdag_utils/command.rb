module DigdagUtils
  class Command
    def initialize(endpoint: nil)
      @endpoint = endpoint
    end

    def get_sessions(pj, wf)
      out =
        DigdagUtils.system(
          "digdag",
          "sessions",
          pj, wf,
          "-e", @endpoint
        )

      blocks = out.split("\n\n")
      blocks.map { |block|
        DigdagUtils::Session.from_command_output(block)
      }
    end
  end
end

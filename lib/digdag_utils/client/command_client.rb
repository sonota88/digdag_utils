require_relative "../../digdag_utils"
require_relative "client_base"

module DigdagUtils
  class Client
    class CommandClient < ClientBase
      def initialize(endpoint: nil)
        @endpoint = endpoint
      end

      def sessions(pj, wf)
        args = []
        args += ["digdag", "sessions", pj, wf]
        args += ["-e", @endpoint]

        out = DigdagUtils.system(*args)

        blocks = out.split("\n\n")
        blocks.map { |block|
          DigdagUtils::Session.from_command_output(block)
        }
      end

      # revision: :latest | :keep
      # resume: :resume | :all
      def retry(
        attempt_id,
        revision: :keep,
        resume: :resume
      )
        args = ["digdag", "retry", attempt_id]

        if revision
          args <<
            case revision
            when :keep then "--keep-revision"
            when :latest then "--latest-revision"
            else
              raise "invalid"
            end
        end

        if resume
          args <<
            case resume
            when :resume then "--resume"
            when :all then "--all"
            else
              raise "invalid"
            end
        end

        args += ["-e", @endpoint]

        DigdagUtils.system(*args)
      end
    end
  end
end

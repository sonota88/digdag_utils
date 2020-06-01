require_relative "../../digdag_utils"

module DigdagUtils
  class Client
    class CommandClient
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

      # revision: :latest | :keep
      # resume: :resume | :all
      def retry(
        attempt_id,
        revision: :keep,
        resume: :resume
      )
        args = ["digdag", "retry", attempt_id]

        args <<
          case revision
          when :keep then "--keep-revision"
          when :latest then "--latest-revision"
          else
            raise "invalid"
          end

        args <<
          case resume
          when :resume then "--resume"
          when :all then "--all"
          else
            raise "invalid"
          end

        args += ["-e", @endpoint]
        pp args

        # DigdagUtils.system(*args)
      end
    end
  end
end

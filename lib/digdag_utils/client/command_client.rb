require_relative "../../digdag_utils"
require_relative "client_base"

module DigdagUtils
  class Client
    class CommandClient < ClientBase
      def initialize(endpoint: nil)
        @endpoint = endpoint
      end

      def sessions(pj, wf, page_size: nil)
        args = []
        args += ["digdag", "sessions", pj, wf]

        if page_size
          args += ["--page-size", page_size]
        end

        args += ["-e", @endpoint]

        out = DigdagUtils.system(*args)

        blocks = out.split("\n\n")
        blocks.map { |block|
          DigdagUtils::Session.from_command_output(block)
        }
      end

      def _retry_resume_from(
          attempt_id,
          resume_from,
          revision: revision
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

        args += ["-e", @endpoint]

        DigdagUtils.system(*args)
      end

      # revision: :latest | :keep
      # resume: :resume | :all
      # rescume_from: "{task_name}"
      def retry(
        attempt_id,
        revision: :keep,
        resume: :resume,
        resume_from: nil
      )
        if resume_from
          _retry_resume_from(
            attempt_id,
            resume_from,
            revision: revision
          )
          return
        end

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

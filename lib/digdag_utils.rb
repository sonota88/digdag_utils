require "shellwords"

require "digdag_utils/session"

module DigdagUtils
  def system(*args)
    cmd = Shellwords.shelljoin(args)
    out = `#{cmd}`
    status = $? # Process::Status
    if not status.success?
      raise "abnormal exit status (status=#{status.to_i} pid=#{status.pid})"
    end
    out
  end
end

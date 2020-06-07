require "shellwords"

require "digdag_utils/session"
require "digdag_utils/attempt"
require "digdag_utils/project"
require "digdag_utils/workflow"

module DigdagUtils
  def self.system(*args)
    cmd = Shellwords.shelljoin(args)
    out = `#{cmd}`
    status = $? # Process::Status
    if not status.success?
      raise "abnormal exit status (status=#{status.to_i} pid=#{status.pid})"
    end
    out
  end
end

if $0 == __FILE__
  puts DigdagUtils.system("ls")
end

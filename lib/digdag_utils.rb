require "shellwords"
require "time"

require "digdag_utils/session"
require "digdag_utils/attempt"
require "digdag_utils/project"
require "digdag_utils/workflow"
require "digdag_utils/task"

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

  def self.system_v2(args, check: true)
    if check
      return DigdagUtils.system(*args)
    end

    cmd = Shellwords.shelljoin(args)
    out = `#{cmd}`
    status = $? # Process::Status

    [out, status]
  end

  def self.from_plain_time(str)
    if str
      Time.parse(str)
    else
      nil
    end
  end

  def self.to_plain_time(t)
    if t
      t.getlocal.iso8601
    else
      nil
    end
  end
end

if $0 == __FILE__
  puts DigdagUtils.system("ls")
end

require "json"
require "shellwords"

$LOAD_PATH.unshift "../lib"
require "digdag_utils"
require "digdag_utils/client/curl_client"

module DigdagUtils
  module Client
    class CommandClient < ClientBase
      def start(pj, wf, session_time: nil)
        cmd = ["digdag", "start", pj, wf]
        if session_time
          cmd += ["--session", session_time]
        end
        cmd += ["-e", @endpoint]

        DigdagUtils.system_v2(cmd, check: false)
      end
    end
  end
end

$endpoint = "http://localhost:65432"

$command_client = DigdagUtils::Client::CommandClient.new(
  endpoint: $endpoint
)
$curl_client = DigdagUtils::Client::CurlClient.new(
  endpoint: $endpoint
)

def start
  pj = "pj_test_sample2"
  wf = "wf_4"

  $command_client.start(
    pj, wf,
    sess_time: "2021-02-25 00:00:00"
  )
end

# TODO timeout config
def wait_attempt(aid)
  10.times do
    # cmd = %(curl #{$endpoint}/api/attempts/#{aid})
    # out = `#{cmd}`
    # unless $?.success?
    #   raise "curl failed"
    # end

    # resp = JSON.parse(out)

    resp = $curl_client.get_attempt(aid)

    pp resp
    att = DigdagUtils::Attempt.from_api_response(resp)
    pp att

    if att.done
      if att.success
        return "OK"
      else
        return "NG"
      end
    end

    sleep 60
  end
end

# out = start()
# puts out

aid = "1"

wait_attempt(aid)

require "json"

$LOAD_PATH.unshift "../lib"
require "digdag_utils"
require "digdag_utils/client/curl_client"

$endpoint = "http://localhost:65432"

$client = DigdagUtils::Client::CurlClient.new(
  endpoint: $endpoint
)

def start
  pj = "pj_test_sample2"
  wf = "wf_4"
  sess_time = "2021-02-25 00:00:00"
  cmd = %(digdag start "#{pj}" "#{wf}" --session "#{sess_time}" -e "#{$endpoint}")
  puts cmd

  out = `#{cmd}`
  unless $?.success?
    raise "curl failed"
  end

  out
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

    resp = $client.get_attempt(aid)

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

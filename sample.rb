require "digdag_utils/client/command_client"

client = DigdagUtils::Client::CommandClient.new(endpoint: "localhost:6543")

ss = client.get_sessions(
  "proj",
  "wf"
)

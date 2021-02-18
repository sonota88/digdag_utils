require "json"

require_relative "../../digdag_utils"
require_relative "client_base"

module DigdagUtils
  module Client
    class CurlClient < ClientBase
      def initialize(endpoint: nil, proxy_url: nil)
        @endpoint = endpoint
        @proxy_url = proxy_url
      end

      def _system(*args)
        DigdagUtils.system(*args)
      end

      def _curl(path, method: :get, params: {})
        args = ["curl", "--silent", "-X", method.to_s.upcase]
        if @proxy_url
          args += ["--proxy", @proxy_url]
        end

        path_with_params =
          if method == :get
            if params.empty?
              path
            else
              path + "?" + params.to_a
                .map{ |k, v| "#{k}=#{v}"} # TODO encode
                .join("&")
            end
          else
            path
          end

        args << @endpoint + "/api/" + path_with_params

        sleep 0.5
        json = _system(*args)
        JSON.parse(json)
      end

      # Project

      def get_projects
        _curl("projects")
      end

      def get_project(id)
        _curl("projects/#{id}")
      end

      # Workflow

      # TODO revision
      # TODO name
      def get_project_workflows(id, params = {})
        _curl("projects/#{id}/workflows", params: params)
      end

      def get_workflow(id: nil)
        if id
          _curl("workflows/#{id}")
        end
      end

      # Session

      # TODO workflow
      # TODO last_id
      # TODO page_size
      def get_project_sessions(id, params = {})
        _curl("projects/#{id}/sessions", params: params)
      end

      def get_session(id)
        _curl("sessions/#{id}")
      end

      # Attempt

      # TODO last_id
      # TODO page_size
      def get_session_attempts(id)
        _curl("sessions/#{id}/attempts")
      end

      def get_attempt(id)
        _curl("attempts/#{id}")
      end

      # Task

      def get_attempt_tasks(id)
        _curl("attempts/#{id}/tasks")
      end
    end
  end
end

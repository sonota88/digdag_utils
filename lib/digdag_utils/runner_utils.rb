module DigdagUtils
  module RunnerUtils
    module Sleep
      class << self
        def _fmt_time(t)
          t.strftime("%T")
        end

        def _fmt_duration(sec)
          if sec < 60
            return format("%ds", sec.round)
          end

          min = (sec / 60).floor
          mod_sec = sec % 60
          format("%dm%ds", min, mod_sec)
        end

        def print_progress(total_sec, t0, limit, msg)
          rest_sec = limit - Time.now

          ratio = [
            (Time.now - t0) / total_sec,
            1.0
          ].min

          percent = ratio * 100.0

          bar_size = 40
          num_elapsed = (bar_size * ratio).floor
          bar = "=" * num_elapsed
          bar << ">"
          bar << "." * (bar_size - num_elapsed)
          bar

          line = "(sleep) "
          line << "rest: #{_fmt_duration(rest_sec)}"
          line << " (#{_fmt_time(t0)}~#{_fmt_time(limit)} #{_fmt_duration(total_sec)})"
          # line << format(" / %.1f%%", percent)
          line << " [#{bar}]"
          line << " #{msg}"
          line << " "

          print "\r"
          print line
        end

        def sec(sec, msg=nil)
          t0 = Time.now
          limit = t0 + sec

          print "\n"

          while Time.now < limit
            print_progress(sec, t0, limit, msg)
            sleep 1
          end

          print_progress(sec, t0, limit, msg)
          print "\n"
        end

        def min(min, msg=nil)
          puts "sleep #{min} min"
          sec(min * 60.0, msg)
        end
      end
    end

    class << self
      def print_text_block(msg, arg)
        lines =
          if arg.is_a?(Array)
            arg
          elsif arg.is_a?(String)
            arg.split("\n", -1)
          else
            raise "not yet supported"
          end

        puts "  ---- [#{msg}] ----"
        puts lines.map{ |line| "  |" + line }.join("\n")
        puts "  ---- [/#{msg}] ----"
      end
    end
  end
end

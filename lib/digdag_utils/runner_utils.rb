require "date"

module DigdagUtils
  module RunnerUtils
    class DateHour
      attr_reader :date, :hour

      def initialize(date, hour)
        @date =
          if date.is_a?(String)
            Date.parse(date)
          else
            date
          end
        @hour = hour
      end

      def succ
        if @hour == 23
          DateHour.new(@date + 1, 0)
        else
          DateHour.new(@date, @hour + 1)
        end
      end

      def before?(other)
        if @date < other.date
          true
        elsif @date == other.date
          @hour < other.hour
        else
          false
        end
      end

      def to_s
        format("%s_%02d", @date.strftime("%F"), @hour)
      end
    end

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
        puts lines.map { |line| "  |" + line }.join("\n")
        puts "  ---- [/#{msg}] ----"
      end

      def fmt_time(t)
        t.strftime("%F %T")
      end

      def gen_date_list(date_from, date_to)
        d_from = Date.parse(date_from)
        d_to   = Date.parse(date_to)
        if d_to < d_from
          raise "date_to must be >= date_from"
        end

        (d_from .. d_to).to_a
      end

      def gen_date_hour_list(date_hour_from, date_hour_to)
        d = date_hour_from

        list = []
        while d.before?(date_hour_to)
          list << d
          d = d.succ
        end
        list << date_hour_to

        list
      end

      def print_status(t0, num_all, num_done)
        if num_done == 0
          print_text_block("status", "N/A")
          return
        end

        t_now = Time.now
        elapsed_sec = (t_now - t0).to_f

        v_sec = elapsed_sec / num_done
        v_min = v_sec / 60.0
        v_h   = v_min / 60.0

        all_sec = v_sec * num_all
        all_h   = all_sec / 60.0 / 60.0

        lines = []
        lines << format("t0:  %s", fmt_time(t0))
        lines << format("now: %s", fmt_time(t_now))
        lines << format("velocity: %.02f (min/count)", v_min)
        lines << format("all:  %.02f h", all_h)
        lines << format("rest: %.02f h", v_h * (num_all - num_done))
        lines << format("num rest: %d", (num_all - num_done))
        lines << format("completion (estimated): %s", fmt_time(t0 + all_sec))

        print_text_block("status", lines.join("\n"))
      end
    end
  end
end

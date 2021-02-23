# coding: utf-8

require "date"
require "fileutils"

require_relative "../lib/digdag_utils/runner_utils"

class Runner
  def initialize(config)
    @config = config
  end

  def utils
    DigdagUtils::RunnerUtils
  end

  def _sleep
    DigdagUtils::RunnerUtils::Sleep
  end

  def fmt_date(d)
    d.strftime("%F")
  end

  def fmt_time(t)
    t.strftime("%F %T")
  end

  def print_dates(ds)
    lines = []

    if ds.size <= 4
      lines << ds.map{ |d| fmt_date(d) }.inspect
    else
      liens << "date from: " + ds[0..1].map{ |d| fmt_date(d) }.inspect
      liens << "date to:   " + ds[-2..-1].map{ |d| fmt_date(d) }.inspect
    end

    utils.print_text_block("dates", lines.join("\n"))
  end

  def print_status(t0, num_all, num_done)
    if num_done == 0
      utils.print_text_block("status", "N/A")
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

    utils.print_text_block("status", lines.join("\n"))
  end

  def run_step(d)
    puts ">> step date=#{d}"
    sleep 3
    puts "<< step"
  end

  def prepare_dates(date_from, date_to)
    d_from = Date.parse(date_from)
    d_to   = Date.parse(date_to)
    if d_to < d_from
      raise "date_to must be >= date_from"
    end

    (d_from .. d_to).to_a
  end

  def run(date_from:, date_to:)
    ds = prepare_dates(date_from, date_to)
    print_dates(ds)

    # 開始前の sleep
    _sleep.sec 5, "before start 1"
    _sleep.min 1.5, "before start 2"
    _sleep.sec 30, "before start 1"

    FileUtils.mkdir_p(@config[:work_dir])

    t0 = Time.now
    num_all = ds.size
    num_done = 0

    ds.each { |d|
      print_status(t0, ds.size, num_done)

      flag_paths = {
        running: File.join(@config[:work_dir], fmt_date(d) + ".running"),
        ok:      File.join(@config[:work_dir], fmt_date(d) + ".ok"    ),
        failed:  File.join(@config[:work_dir], fmt_date(d) + ".failed"),
      }

      do_skip = false
      flag_paths.each { |_, path|
        if File.exist?(path)
          do_skip = true
          break
        end
      }
      if do_skip
        _sleep.sec 5
        next
      end

      FileUtils.touch flag_paths[:running]

      begin
        run_step(d)
        FileUtils.mv flag_paths[:running], flag_paths[:ok]
      rescue => e
        FileUtils.mv flag_paths[:running], flag_paths[:failed]
      end

      num_done += 1
    }
  end
end

CONFIG_MAP = {
  devel: {
    endpoint: "http://localhost:65432/",
    work_dir: "z_work_devel",
  },
  prod: {
    endpoint: "http://localhost:65432/",
    work_dir: "z_work_prod",
  },
}

config = CONFIG_MAP[:devel]

runner = Runner.new(config)

runner.run(
  date_from: "2019-12-30",
  date_to:   "2020-01-02"
)

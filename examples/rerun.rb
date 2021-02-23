# coding: utf-8

require "date"
require "fileutils"

require_relative "../lib/digdag_utils/runner_utils"

class Runner
  def initialize(config)
    @config = config
  end

  def ru
    DigdagUtils::RunnerUtils
  end

  def _sleep
    DigdagUtils::RunnerUtils::Sleep
  end

  def fmt_date(d)
    d.strftime("%F")
  end

  def print_dates(ds)
    lines = []

    if ds.size <= 4
      lines << ds.map{ |d| fmt_date(d) }.inspect
    else
      liens << "date from: " + ds[0..1].map{ |d| fmt_date(d) }.inspect
      liens << "date to:   " + ds[-2..-1].map{ |d| fmt_date(d) }.inspect
    end

    ru.print_text_block("dates", lines.join("\n"))
  end

  def run_step(d)
    puts ">> step date=#{d}"
    sleep 3
    puts "<< step"
  end

  def run(date_from:, date_to:)
    ds = ru.gen_date_list(date_from, date_to)
    print_dates(ds)

    # 開始前の sleep
    _sleep.sec 5, "before start 1"
    _sleep.min 1.5, "before start 2"
    _sleep.sec 30, "before start 1"

    FileUtils.mkdir_p(@config[:work_dir])

    t0 = Time.now
    num_all = ds.size
    num_done = 0

    ds.each do |d|
      ru.print_status(t0, ds.size, num_done)

      flags = {
        running: File.join(@config[:work_dir], fmt_date(d) + ".running"),
        ok:      File.join(@config[:work_dir], fmt_date(d) + ".ok"    ),
        failed:  File.join(@config[:work_dir], fmt_date(d) + ".failed"),
      }

      do_skip = flags.values.any? { |path| File.exist?(path) }
      if do_skip
        _sleep.sec 5
        next
      end

      FileUtils.touch flags[:running]

      begin
        run_step(d)
        FileUtils.mv flags[:running], flags[:ok]
      rescue => e
        FileUtils.mv flags[:running], flags[:failed]
      end

      num_done += 1
    end
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

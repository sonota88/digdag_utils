require "minitest/autorun"

require_relative "helper"
require "digdag_utils/runner_utils"

class Test < Minitest::Test
  def _dh(d_str, hour)
    DigdagUtils::RunnerUtils::DateHour.new(d_str, hour)
  end

  def test_gen_date_hour_list_01
    dh_list = DigdagUtils::RunnerUtils.gen_date_hour_list(
      _dh("2021-04-01",  9),
      _dh("2021-04-01", 10)
    )

    exp = <<~EXP
      2021-04-01_09
      2021-04-01_10
    EXP

    assert_equal(
      exp,
      dh_list.map { |dh| dh.to_s + "\n" }.join()
    )
  end

  def test_gen_date_hour_list_02
    dh_list = DigdagUtils::RunnerUtils.gen_date_hour_list(
      _dh("2021-04-01", 23),
      _dh("2021-04-03",  0)
    )

    exp = <<~EXP
      2021-04-01_23
      2021-04-02_00
      2021-04-02_01
      2021-04-02_02
      2021-04-02_03
      2021-04-02_04
      2021-04-02_05
      2021-04-02_06
      2021-04-02_07
      2021-04-02_08
      2021-04-02_09
      2021-04-02_10
      2021-04-02_11
      2021-04-02_12
      2021-04-02_13
      2021-04-02_14
      2021-04-02_15
      2021-04-02_16
      2021-04-02_17
      2021-04-02_18
      2021-04-02_19
      2021-04-02_20
      2021-04-02_21
      2021-04-02_22
      2021-04-02_23
      2021-04-03_00
    EXP

    assert_equal(
      exp,
      dh_list.map { |dh| dh.to_s + "\n" }.join()
    )
  end
end

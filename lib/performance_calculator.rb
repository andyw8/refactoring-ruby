class PerformanceCalculator
  def initialize(performance, play)
    @a_performance = performance
    @play = play
  end

  attr_reader :a_performance, :play

  def amount
    result = 0
    case play["type"]
    when "tragedy"
      result = 40_000
      if a_performance["audience"] > 30
        result += 1000 * (a_performance["audience"] - 30)
      end
    when "comedy"
      result = 30_000
      if a_performance["audience"] > 20
        result += 10_000 + 500 * (a_performance["audience"] - 20)
      end
      result += 300 * a_performance["audience"]
    else
      raise "unknown type: #{play["type"]}"
    end
    result
  end

  def volume_credits
    result = 0
    result += [a_performance["audience"] - 30, 0].max
    if "comedy" == play["type"]
      result += (a_performance["audience"] / 5).floor
    end
    result
  end
end

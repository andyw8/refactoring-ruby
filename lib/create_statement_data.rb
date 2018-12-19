require "performance_calculator"

def create_statement_data(invoice, plays)

  play_for = lambda do |a_performance|
    plays[a_performance["playID"]]
  end

  amount_for = lambda do |a_performance|
    PerformanceCalculator.new(a_performance, play_for.call(a_performance)).amount
  end

  total_amount = lambda do |data|
    data["performances"].inject(0) do |total, a_performance|
      total += amount_for.call(a_performance)
    end
  end

  total_volume_credits = lambda do |data|
    data["performances"].inject(0) do |total, a_performance|
      total += a_performance["volume_credits"]
    end
  end

  enrich_performance = lambda do |a_performance|
    calculator = PerformanceCalculator.new(a_performance, play_for.call(a_performance))
    a_performance.merge(
      "play" => calculator.play,
      "amount" => calculator.amount,
      "volume_credits" => calculator.volume_credits
    )
  end

  result = {}
  result['customer'] = invoice["customer"]
  result['performances'] = invoice["performances"].map(&enrich_performance)
  result['total_amount'] = total_amount.call(result)
  result['total_volume_credits'] = total_volume_credits.call(result)
  result
end

def create_statement_data(invoice, plays)
  play_for = lambda do |a_performance|
    plays[a_performance["playID"]]
  end

  amount_for = lambda do |a_performance; result|
    case play_for.call(a_performance)["type"]
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

  volume_credits_for = lambda do |a_performance|
    volume_credits = 0
    volume_credits += [a_performance["audience"] - 30, 0].max
    if "comedy" == play_for.call(a_performance)["type"]
      volume_credits += (a_performance["audience"] / 5).floor
    end
    volume_credits
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
    a_performance.merge(
      "play" => play_for.call(a_performance),
      "amount" => amount_for.call(a_performance),
      "volume_credits" => volume_credits_for.call(a_performance)
    )
  end

  statement_data = {}
  statement_data['customer'] = invoice["customer"]
  statement_data['performances'] = invoice["performances"].map(&enrich_performance)
  statement_data['total_amount'] = total_amount.call(statement_data)
  statement_data['total_volume_credits'] = total_volume_credits.call(statement_data)
  statement_data
end

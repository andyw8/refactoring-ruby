require "intl/number_format"

def statement(invoice, plays)
  total_amount = 0
  volume_credits = 0
  result = "Statement for #{invoice["customer"]}\n"
  format = Intl::NumberFormat.new("en-US",
                                  style: "currency", currency: "USD",
                                  minimum_fraction_digits: 2).format

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

  volume_credits_for = lambda do |perf|
    volume_credits = 0
    volume_credits += [perf["audience"] - 30, 0].max
    if "comedy" == play_for.call(perf)["type"]
      volume_credits += (perf["audience"] / 5).floor
    end
    volume_credits
  end

  invoice["performances"].each do |a_performance|
    volume_credits += volume_credits_for.call(a_performance)

    # print line for this order
    result += "  #{play_for.call(a_performance)["name"]}: #{format.call(amount_for.call(a_performance) / 100)} (#{a_performance["audience"]} seats)\n"
    total_amount += amount_for.call(a_performance)
  end
  result += "Amount owed is #{format.call(total_amount / 100)}\n"
  result += "You earned #{volume_credits} credits\n"
  result
end

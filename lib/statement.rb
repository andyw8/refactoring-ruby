require "intl/number_format"

def statement(invoice, plays)
  result = "Statement for #{invoice["customer"]}\n"

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

  usd = lambda do |a_number|
    Intl::NumberFormat.new("en-US",
                           style: "currency", currency: "USD",
                           minimum_fraction_digits: 2).format.call(a_number / 100)
  end

  invoice["performances"].each do |a_performance|
    # print line for this order
    result += "  #{play_for.call(a_performance)["name"]}: #{usd.call(amount_for.call(a_performance))} (#{a_performance["audience"]} seats)\n"
  end

  total_amount = lambda do
    result = 0
    invoice["performances"].each do |a_performance|
      result += amount_for.call(a_performance)
    end
    result
  end

  total_volume_credits = lambda do
    volume_credits = 0
    invoice["performances"].each do |a_performance|
      volume_credits += volume_credits_for.call(a_performance)
    end
    volume_credits
  end

  result += "Amount owed is #{usd.call(total_amount.call)}\n"
  result += "You earned #{total_volume_credits.call} credits\n"
  result
end

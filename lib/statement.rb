require "intl/number_format"

def statement(invoice, plays)
  total_amount = 0
  volume_credits = 0
  result = "Statement for #{invoice["customer"]}\n"
  format = Intl::NumberFormat.new("en-US",
                                  style: "currency", currency: "USD",
                                  minimum_fraction_digits: 2).format
  amount_for = lambda do |a_performance, play; result|
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

  invoice["performances"].each do |perf|
    play = plays[perf["playID"]]
    this_amount = amount_for.call(perf, play)

    # add volume credits
    volume_credits += [perf["audience"] - 30, 0].max
    # add extra credit for every ten comedy attendees
    if "comedy" == play["type"]
      volume_credits += (perf["audience"] / 5).floor
    end

    # print line for this order
    result += "  #{play["name"]}: #{format.call(this_amount / 100)} (#{perf["audience"]} seats)\n"
    total_amount += this_amount
  end
  result += "Amount owed is #{format.call(total_amount / 100)}\n"
  result += "You earned #{volume_credits} credits\n"
  result
end

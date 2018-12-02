require "intl/number_format"

def statement(invoice, plays)
  total_amount = 0
  volume_credits = 0
  result = "Statement for #{invoice["customer"]}\n"
  format = Intl::NumberFormat.new("en-US",
                                  style: "currency", currency: "USD",
                                  minimum_fraction_digits: 2).format
  invoice["performances"].each do |perf|
    play = plays[perf["playID"]]
    this_amount = 0

    case play["type"]
    when "tragedy"
      this_amount = 40_000
      if perf["audience"] > 30
        this_amount += 1000 * (perf["audience"] - 30)
      end
    when "comedy"
      this_amount = 30_000
      if perf["audience"] > 20
        this_amount += 10_000 + 500 * (perf["audience"] - 20)
      end
      this_amount += 300 * perf["audience"]
    else
      raise "unknown type: #{play["type"]}"
    end

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

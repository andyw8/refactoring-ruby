require "intl/number_format"

def statement(invoice, plays)
  usd = lambda do |a_number|
    Intl::NumberFormat.new("en-US",
                           style: "currency", currency: "USD",
                           minimum_fraction_digits: 2).format.call(a_number / 100)
  end

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
    result = 0
    data["performances"].each do |a_performance|
      result += amount_for.call(a_performance)
    end
    result
  end

  total_volume_credits = lambda do |data|
    volume_credits = 0
    data["performances"].each do |a_performance|
      volume_credits += a_performance["volume_credits"]
    end
    volume_credits
  end

  render_plain_text = lambda do |data, plays|
    result = "Statement for #{data["customer"]}\n"

    data["performances"].each do |a_performance|
      # print line for this order
      result += "  #{a_performance["play"]["name"]}: #{usd.call(a_performance["amount"])} (#{a_performance["audience"]} seats)\n"
    end

    result += "Amount owed is #{usd.call(data["total_amount"])}\n"
    result += "You earned #{data["total_volume_credits"]} credits\n"
    result
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

  render_plain_text.call(statement_data, plays)
end

require "intl/number_format"
require "create_statement_data"

def statement(invoice, plays)
  render_plain_text(create_statement_data(invoice, plays))
end

def html_statement(invoice, plays)
  render_html(create_statement_data(invoice, plays))
end

def render_plain_text(data)
  result = "Statement for #{data["customer"]}\n"

  data["performances"].each do |a_performance|
    # print line for this order
    result += "  #{a_performance["play"]["name"]}: #{usd(a_performance["amount"])} (#{a_performance["audience"]} seats)\n"
  end

  result += "Amount owed is #{usd(data["total_amount"])}\n"
  result += "You earned #{data["total_volume_credits"]} credits\n"
  result
end

def render_html(data)
  result = "<h1>Statement for #{data["customer"]}</h1>\n"
  result += "<table>\n"
  result += "  <tr><th>play</th><th>seats</th><th>cost</th></tr>\n"

  data["performances"].each do |perf|
    result += "  <tr><td>#{perf["play"]["name"]}</td><td>#{perf["audience"]}</td>"
    result += "<td>#{usd(perf["amount"])}</td></tr>\n"
  end

  result += "</table>\n"
  result += "<p>Amount owed is <em>#{usd(data["total_amount"])}</em></p>\n"
  result += "<p>You earned <em>#{data["total_volume_credits"]}</em> credits</p>\n"
  result
end

def usd(a_number)
  Intl::NumberFormat.new("en-US",
                         style: "currency", currency: "USD",
                         minimum_fraction_digits: 2).format.call(a_number / 100)
end

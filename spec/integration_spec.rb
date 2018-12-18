require "json"
require "statement"

RSpec.describe "#statement" do
  specify do
    plays = JSON.parse(File.read("data/plays.json"))
    invoices = JSON.parse(File.read("data/invoices.json"))

    result = statement(invoices.first, plays)

    expect(result).to eq(
      <<~STATEMENT
        Statement for BigCo
          Hamlet: $650.00 (55 seats)
          As You Like It: $580.00 (35 seats)
          Othello: $500.00 (40 seats)
        Amount owed is $1,730.00
        You earned 47 credits
      STATEMENT
    )
  end
end

RSpec.describe "#html_statement" do
  specify do
    plays = JSON.parse(File.read("data/plays.json"))
    invoices = JSON.parse(File.read("data/invoices.json"))

    result = statement(invoices.first, plays)

    expect(result).to eq(
      <<~STATEMENT
        <h1>Statement for BigCo</h1>
        <table>
          <tr><th>play</th><th>seats</th><th>cost</th></tr>
          <tr><td>Hamlet</td><td>55</td><td>$650.00</td></tr>
          <tr><td>As You Like It</td><td>35</td><td>$580.00</td></tr>
          <tr><td>Othello</td><td>40</td><td>$500.00</td></tr>
        </table>
        <p>Amount owed is <em>$1,730.00</em>
        <p>You earned <em>47</em> credits</p>
      STATEMENT
    )
  end
end

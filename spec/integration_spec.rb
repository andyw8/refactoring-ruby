require "json"
require "statement"

RSpec.describe "statement" do
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

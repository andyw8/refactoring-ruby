module Intl
  class NumberFormat
    def initialize(*); end

    def format
      lambda do |amount|
        "$" + Kernel.format("%0.2f", amount).gsub(/(\d)(?=\d{3}+\.)/, '\1,')
      end
    end
  end
end

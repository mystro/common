class Mystro::Dsl::Listener < Mystro::Dsl::Base
  attribute :from, value: 'HTTP:80'
  attribute :to, value: 'HTTP:80'
  attribute :cert
end
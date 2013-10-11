class Mystro::Dsl::Health < Mystro::Dsl::Base
  attribute :healthy, value: 10
  attribute :unhealthy, value: 2
  attribute :interval, value: 5
  attribute :target, value: 'HTTP:80/'
  attribute :time, value: 30   #TODO: timeout doesn't work, doesn't override Timeout#timeout
end
class Mystro::Dsl::TemplateFile < Mystro::Dsl::Base
  has_one :template
  def actions
    @data[:template].actions
  end

  def compute(name)
    n = name.to_sym
    dsl = computes.detect {|e| e[:name] == n}
    act = dsl.actions.first
    act.to_model
  end

  def computes
    @data[:template] && @data[:template][:compute]
  end
end

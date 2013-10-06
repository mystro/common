class Mystro::Dsl::TemplateFile < Mystro::Dsl::Base
  has_one :template
  def actions
    @data[:template].actions
  end
end

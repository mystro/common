class Mystro::Dsl::TemplateFile < Mystro::Dsl::Base
  has_one :template
  def to_cloud
    @data[:template][:value].to_cloud
  end
end
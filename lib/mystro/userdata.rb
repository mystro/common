require 'erubis'

module Mystro
  class Userdata
    class << self
      def create(name, roles, environment, opts={ })
        package      = opts.delete(:package)
        dependencies = opts.delete(:dependencies)
        gems         = opts.delete(:gems)
        files        = opts.delete(:files)
        templates    = opts.delete(:templates)

        directory    = "#{Mystro.directory}/userdata/#{package}"
        file         = "#{directory}/userdata.yml"
        raise "userdata error: package not specified" unless package
        raise "userdata error: pacakge #{package} directory does not exist (#{directory})" unless File.directory?(directory)
        raise "userdata error: configuration file does not exist (#{file})" unless File.exists?(file)
        config = YAML.load_file(file)

        data = {
            :name         => name,
            :roles        => roles,
            :environment  => environment,
            :nickname     => name,
            :account      => "unknown",
            :zone         => "unknown.local",
            :dependencies => [],
            :gems         => [],
            :files        => [],
            :templates    => [],
            :directory    => directory,
            :template     => "userdata.sh.erb",
        }.deep_merge(config.symbolize_keys!).deep_merge(opts.symbolize_keys!)

        data[:data] = data

        data[:gems] += gems if gems
        data[:dependencies] += dependencies if dependencies
        data[:files] += files if files
        data[:templates] += templates if templates

        template = File.open("#{directory}/#{data[:template]}").read
        erb      = Erubis::Eruby.new(template)
        out      = erb.evaluate(data)
      end
    end
  end
end
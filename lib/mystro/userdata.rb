require 'erubis'

module Mystro
  class Userdata
    class << self
      def create(name, roles, environment, opts={ })
        package      = opts.delete(:package)
        dependencies = opts.delete(:dependencies)
        gems         = opts.delete(:gems)
        files        = opts.delete(:files)
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
            :zone         => Mystro.account.dns.zone,
            :dependencies => [],
            :gems         => [],
            :files        => [],
            :directory    => directory,
            :template     => "userdata.sh.erb",
        }.deep_merge(config.symbolize_keys!).deep_merge(opts.symbolize_keys!)

        data[:gems] += gems if gems
        data[:dependencies] += dependencies if dependencies
        data[:files] += files if files

        template = File.open("#{directory}/#{data[:template]}").read
        erb      = Erubis::Eruby.new(template)
        out      = erb.evaluate(data)
      end
    end
  end
end
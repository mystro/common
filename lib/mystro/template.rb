module Mystro
  module Template
    class << self
      def load(name_or_file)
        @templates    ||= {}
        template_name = nil
        template_file = nil
        if File.exists?(name_or_file)
          template_name = File.basename(name_or_file).gsub(/\.rb$/, "").to_sym
          template_file = name_or_file
        elsif File.exists?("#{dir}/#{name_or_file}.rb")
          template_name = name.to_sym
          template_file = "#{dir}/#{name}.rb"
        end
        raise "could not load template #{template_name} (#{template_file})" unless template_file && File.file?(template_file)
        #raise "template already loaded #{template_name}" if @templates[template_name]

        @templates[template_name] ||= begin
          d = File.read(template_file)
          t = Mystro::DSL::TemplateFile.new
          t.instance_eval(d, "TemplateFile(#{template_file})")
          t.to_hash
        end
      end

      #def load_yaml_file(path)
      #  file = File.expand_path(path)
      #  raise "Configuration not found: #{path} (#{file})" unless File.exists?(file)
      #  yaml = YAML.load_file(file)
      #  yaml = yaml[yaml.keys.first] if yaml.keys.count == 1
      #
      #  yaml
      #end

      def list
        Dir["#{dir}/*"].inject({}) do |h, e|
          f           = e.gsub("#{dir}/", "")
          f           = File.basename(f, ".yml")
          h[f.to_sym] = e
          h
        end
      end

      private
      def dir
        "#{Mystro.directory}/templates"
      end
    end
  end
end

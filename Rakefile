require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'mystro-common'
require 'terminal-table'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec
def table(head, rows=nil)
  if rows
    t = Terminal::Table.new :headings => head, :rows => rows
  else
    t = Terminal::Table.new :rows => rows
  end
  t
end

def list(keys, list)
  #ap list
  rows = []
  list.each do |l|
    row = []
    keys.each do |k|
      row << (l[k] || l[k.downcase] || l[k.to_sym] || l[k.downcase.to_sym])
    end
    rows << row
  end
  table(keys, rows)
end

def show(obj)
  keys = obj.keys
  rows = []
  keys.each do |k|
    list = [obj[k]].flatten
    list.each do |v|
      if v.is_a?(Hash)
        v = v.inject([]) {|s, e| s << e.join(": ")}.join("\n")
      end
      v
      rows << [k, v]
    end
  end
  table(%w{key value}, rows)
end

def options
  {aws_access_key_id: 'AKIAIVMUCDVWWZFFLVGA', aws_secret_access_key: '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'}
end

Mystro::Log.console_debug
Mystro::Log.debug "logging ... "

desc 'get and show compute'
task :compute do
  x = Mystro.compute
  o = x.find("i-69d32404")
  e = o.to_hash
  e.merge!(name: o.name)
  puts show(e)
end

desc 'get and show balancer'
task :balancer do
  x = Mystro.balancer
  o = x.find 'RG-EVENTS-1'
  e = o.to_hash
  puts show(e)
end

desc 'get and show zone'
task :record do
  x = Mystro.record
  o = x.find 'mystro.dev.ops.rgops.com'
  e = o.to_hash
  puts show(e)
end

desc 'show default organization'
task :org do
  puts Mystro.organization.to_hash.to_yaml
end

desc 'show configuration'
task :config do
  puts Mystro.config.to_hash.to_yaml
end

def changelog(last=nil, single=false)
  command="git --no-pager log --format='%an::::%h::::%s'"

  list = `git tag`

  puts "# Changelog"
  puts

  ordered = list.lines.sort_by {|e| (a,b,c) = e.gsub(/^v/,"").split("."); "%3d%3d%3d" % [a, b, c]}

  ordered.reject{|e| (a,b,c,d) = e.split("."); !d.nil?}.reverse_each do |t|
    tag = t.chomp

    if last
      check = { }
      out   = []
      log   = `#{command} #{last}...#{tag}`
      log.lines.each do |line|
        (who, hash, msg) = line.split('::::')
        unless check[msg]
          unless msg =~ /^Merge branch/ || msg =~ /CHANGELOG/ || msg =~ /^(v|version|changes for|preparing|ready for release|ready to release|bump version)*\s*(v|version)*\d+\.\d+\.\d+/
            msg.gsub(" *", "\n*").gsub(/^\*\*/, "  *").lines.each do |l|
              line = l =~ /^(\s+)*\*/ ? l : "* #{l}"
              out << line
            end
            check[msg] = hash
          end
        end
      end
      puts "## #{last}:"
      out.each { |e| puts e }
      #puts log
      puts
    end

    last = tag
    exit if single
  end
end

desc "generate changelog output"
task :changelog do
  changelog
end

desc "show current changes (changelog output from HEAD to most recent tag)"
task :current do
  changelog("HEAD",true)
end

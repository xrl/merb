require File.expand_path("../merb-core/lib/merb-core/version.rb", __FILE__)

require 'fileutils'

ROOT = File.dirname(__FILE__)

yard_options = [
  ['--output-dir',  'doc/yard'               ],
  ['--tag',         'overridable:Overridable'],
  ['--markup',      'markdown'               ],
  ['--exclude',     '/generators/'           ],
  ['-e',            'yard/merbext.rb'        ],
  ['-p',            'yard/templates'         ],
]

merb_stack_gems = [
  { :name => 'merb-core',             :path => "#{ROOT}/merb-core",             :doc => :yard },
  { :name => 'merb-action-args',      :path => "#{ROOT}/merb-action-args",      :doc => :yard },
  { :name => 'merb-assets',           :path => "#{ROOT}/merb-assets",           :doc => :yard },
  { :name => 'merb-slices',           :path => "#{ROOT}/merb-slices",           :doc => :yard },
  { :name => 'merb-cache',            :path => "#{ROOT}/merb-cache",            :doc => :yard },
  { :name => 'merb-gen',              :path => "#{ROOT}/merb-gen",              :doc => :yard },
  { :name => 'merb-haml',             :path => "#{ROOT}/merb-haml",             :doc => :yard },
  { :name => 'merb-helpers',          :path => "#{ROOT}/merb-helpers",          :doc => :yard },
  { :name => 'merb-mailer',           :path => "#{ROOT}/merb-mailer",           :doc => :yard },
  { :name => 'merb-param-protection', :path => "#{ROOT}/merb-param-protection", :doc => :yard },
  { :name => 'merb-exceptions',       :path => "#{ROOT}/merb-exceptions",       :doc => :yard },
  { :name => 'merb-auth',             :path => "#{ROOT}/../merb-auth",          :doc => :rdoc },
  { :name => 'merb_datamapper',       :path => "#{ROOT}/../merb_datamapper",    :doc => :rdoc },
  { :name => 'merb',                  :path => "#{ROOT}/merb",                  :doc => :rdoc }
]


def gem_command(command)
  sh "#{RUBY} -S gem #{command}"
end

def rake_command(command)
  sh "#{RUBY} -S rake #{command}"
end


desc "Install all merb stack gems"
task :install do
  merb_stack_gems.each do |gem_info|
    Dir.chdir(gem_info[:path]) { rake_command "install" }
  end
end

desc "Uninstall all merb stack gems"
task :uninstall do
  merb_stack_gems.each do |gem_info|
    gem_command "uninstall #{gem_info[:name]} --version=#{Merb::VERSION}"
  end
end

desc "Build all merb stack gems"
task :build do
  merb_stack_gems.each do |gem_info|
    Dir.chdir(gem_info[:path]) { rake_command "build" }
  end
end

desc "Generate gemspecs for all merb stack gems"
task :gemspec do
  merb_stack_gems.each do |gem_info|
    Dir.chdir(gem_info[:path]) { rake_command "gemspec" }
  end
end

desc "Run specs for all merb stack gems"
task :spec do
  # Omit the merb metagem, no specs there
  merb_stack_gems[0..-2].each do |gem_info|
    Dir.chdir(gem_info[:path]) { rake_command "spec" }
  end
end

doc_files = []

task :docfile_gen do
  paths = merb_stack_gems.select {|g| g[:doc] == :yard}

  # add source files to documentation generation
  doc_files += paths.collect {|g| File.join(g[:name], 'lib', '**', '*.rb')}

  # add auxiliary documentation files (in gems "docs" directory)
  doc_files << '-'
  doc_files << paths.collect { |g|
    docs_path = File.join(g[:name], 'docs')
    begin
      if File.stat(docs_path).directory?
        File.join(docs_path, '*.mkd')
      else
        ''
      end
    rescue
      # skip over gems without a "docs" directory
      ''
    end
  }.join(' ')
end


desc "Write .yardoc file for YARD"
task :yardopts => [:docfile_gen] do
  File.open(File.join(ROOT, '.yardopts'), 'w') do |yardfile|
    yard_options.each do |yo|
      case yo
      when Array then yardfile.puts yo.join(' ')
      else yardfile.puts yo
      end
    end

    yardfile.puts doc_files.join($/)
  end
end

task :doc => [:yard]
begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files = doc_files
    t.options = yard_options.flatten
  end
rescue LoadError
  # just skip the Rake task if YARD is not installed
end

task :yard => [:docfile_gen]

task :default => 'spec'

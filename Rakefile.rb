require 'rubygems'
require 'pathname'
require 'spec'

__DIR__ = path = Pathname.new(__FILE__).dirname.expand_path


task :default => "spec:all"

namespace :spec do
  task :default => :all

  task :prepare do 
    @specs= Dir.glob(__DIR__ +"rspec"+"**"+"*.rb").join(' ')
    p @specs
  end
  
  task :all => :prepare do
    system "spec #{@specs}"
  end
  
  task :doc => :prepare do
    system "spec #{@specs} --format specdoc"
  end
end

task :cleanup do 
  Dir.glob("**/*.*~")+Dir.glob("**/*~").each{|swap|FileUtils.rm(swap, :force => true)}
end

namespace :gem do
  task :version do
    @version = "0.0.1"
  end

  task :build => :spec do
    load __DIR__ + "jass.gemspec"
    Gem::Builder.new(@jass_gemspec).build
  end

  task :install => :build do
    cmd = "gem install jass -l"
    system cmd unless system "sudo #{cmd}"
    FileUtils.rm(__DIR__ + "jass-#{@version}.gem")
  end

  task :spec => :version do
    file = File.new(__DIR__ + "jass.gemspec", 'w+')
    FileUtils.chmod 0755, __DIR__ + "jass.gemspec"
    spec = %{
Gem::Specification.new do |s|
  s.name             = "jass"
  s.date             = "2008-07-21"
  s.version          = "#{@version}"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.has_rdoc         = false
  s.summary          = "A whitespace active min-language for writing javascript specs."
  s.authors          = ["Collin Miller"]
  s.email            = "collintmiller@gmail.com"
  s.homepage         = "http://github.com/collin/jass"
  s.files            = %w{#{(%w(README Rakefile.rb) + Dir.glob("{lib,rspec}/**/*")).join(' ')}}
  
  s.add_dependency  "rake"
  s.add_dependency  "rspec"
  s.add_dependency  "collin-fold"
end
}

  @jass_gemspec = eval(spec)
  file.write(spec)
  end
end
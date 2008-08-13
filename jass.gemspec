
Gem::Specification.new do |s|
  s.name             = "jass"
  s.date             = "2008-07-21"
  s.version          = "0.0.1"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.has_rdoc         = false
  s.summary          = "Toolkit for creating whitespace active mini-languages. Inspired by Haml. Feature light."
  s.authors          = ["Collin Miller"]
  s.email            = "collintmiller@gmail.com"
  s.homepage         = "http://github.com/collin/jass"
  s.files            = %w{README Rakefile.rb lib/jass.rb lib/jsspec lib/jsspec/layout.html.haml lib/jsspec/example.html.jass rspec/jass rspec/jass/jass_precompiler_spec.rb rspec/jass/jass_engine_spec.rb rspec/jass_spec.rb rspec/spec_helper.rb}
  
  s.add_dependency  "rake"
  s.add_dependency  "rspec"
  s.add_dependency  "collin-fold"
end

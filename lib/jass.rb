require 'fold'
require 'haml'
require 'johnson'
require 'pathname'
require 'fileutils'

__DIR__ = Pathname.new(__FILE__).dirname.expand_path

module Jass
  class Precompiler < Fold::Precompiler
    include Johnson::Nodes
    JsSpecRoot =  (__DIR__ + ".." + "vendor" + "jsspec").expand_path

    attr_accessor :scripts
  
    def initialize
      super
      
      @scripts = []
      inject_jsspec_scripts
    end

    def self.write_jsspec_scripts_to path
      jsspec_scripts.each do |script|
        FileUtils.cp script, path 
      end
    end

    def inject_jsspec_scripts
      @scripts << *jsspec_scripts
    end

    def jsspec_scripts
      [JsSpecRoot + "JSSpec.js", JsSpecRoot + "diff_match_patch.js"]
    end

    folds :Line, // do
      children.inject(text) do |script, child|
        "#{script}#{child.text}#{child.render_children}"
      end
    end

    folds :ExampleGroup, /^describe / do
      call = FunctionCall.new(0,0)
      call << Name.new(0,0, 'describe')
      call << String.new(0,0, text)
      call << ObjectLiteral.new(0,0, render_children)
      call
    end

    folds :Example,      /^it / do
      js = render_children.join

      Property.new(0,0, String.new(0,0, text),
        Function.new(0,0, nil, [], Johnson::Parser.parse(js)))
    end

    folds :Require,      /^require / do
      @scripts << eval(text)
      ""
    end
  end
  
  class Engine < Fold::Engine
    template = Pathname.new(__DIR__) + "jsspec" + "layout.html.haml"
    Layout= Haml::Engine.new(template.read)
    
    def render context=nil
      @p = precompiler_class.new
      value = @p.fold(lines).children.map{|child| child.render}
      sexp = Johnson::Nodes::SourceElements.new(0,0)

      value.each{|line| sexp << line unless line.blank?}

      Layout.render Object.new, {
        :test => sexp.to_ecma, 
        :scripts => @p.scripts
      }    
    end
  end
end

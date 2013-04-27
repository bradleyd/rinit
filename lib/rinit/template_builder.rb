require "erb"
module Rinit
  class TemplateBuilder
    def initialize(opts={})
      @template = opts.fetch(:template) { 'init' }
      @name = opts.fetch(:name) { 'foobar' }
    end

    def build
      @erb_temp = ERB.new(File.read(template_file)) #.result(binding)
      write_out_file
    end

    def write_out_file 
      File.open(example_name, 'w') do |f|
        f.write @erb_temp.result(binding)
      end
    end

    def bind
      build.result(binding)
    end

    def example_name
      "#{@name}.#{@template}"
    end

    def template_file
      File.join(File.expand_path(File.dirname(__FILE__)), "../../", "examples", @template)
    end
  end
end

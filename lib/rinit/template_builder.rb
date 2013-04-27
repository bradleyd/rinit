require "erb"
module Rinit
  class TemplateBuilder
    def initialize(opts={})
      @template = opts.fetch(:template) { 'init' }
      @name = opts.fetch(:name) { 'foobar' }
    end

    def build
      erb_temp = ERB.new(File.read(template_file)) #.result(binding)
      File.open('text2.txt', 'w') do |f|
          f.write erb_temp.result(binding)
      end
    end

    def bind
      build.result(binding)
    end

    def template_file
      File.join(File.expand_path(File.dirname(__FILE__)), "../../", "examples", @template)
    end
  end
end

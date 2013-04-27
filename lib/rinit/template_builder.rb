require "erb"
module Rinit
  # simple template generator 
  #
  # @note only supports init and monit right now
  class TemplateBuilder

    def initialize(opts={})
      @template = opts.fetch(:template) { 'init' }
      @name = opts.fetch(:name) { 'foobar' }
    end

    # @params nil [nil]
    # @return  [nil]
    def build
      @erb_temp = ERB.new(File.read(template_file)) #.result(binding)
      write_out_file
    end

    private
    # @private
    def write_out_file 
      File.open(example_name, 'w') do |f|
        f.write @erb_temp.result(binding)
      end
    end
    
    # @private
    def example_name
      "#{@name}.#{@template}"
    end

    # @private
    def template_file
      File.join(File.expand_path(File.dirname(__FILE__)), "../../", "examples", @template)
    end
  end
end

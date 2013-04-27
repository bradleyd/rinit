require_relative "test_helper"
require_relative './test_helper'

class RinitTemplateBuilderTest < MiniTest::Unit::TestCase
 
  def setup
    @name = 'foobar'
    @template = 'init'
    @example_file = File.join(File.expand_path(File.dirname(__FILE__)), "../", 
                              "#{@name}.#{@template}")   
    @generator = Rinit::TemplateBuilder.new(template: @template, name: @name)
  end

  def test_should_respond_to_build
    assert_respond_to(@generator, :build)
  end

  def test_should_create_template
    @generator.build
    assert(File.exist?(@example_file), "cant find file")
  end

  def teardown
    begin
      FileUtils.rm(@example_file)
    rescue
    end
  end
end

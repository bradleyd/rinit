require_relative "test_helper"
require 'tempfile'
require 'sys/proctable'
require "ostruct"

class RinitTemplateBuilderTest < MiniTest::Unit::TestCase
 
  def setup
    @generator = Rinit::TemplateBuilder.new(template: 'init', name: 'foobar')
  end

  def test_should_respond_to_build
    assert_respond_to(@generator, :build)
  end

  def test_should_print_out_template
    assert_match(@generator.build, /APP_NAME foobar/)
  end
end

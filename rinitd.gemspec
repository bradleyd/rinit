Gem::Specification.new do |s|
  s.name = %q{rinitd}
  s.version = "0.0.3"
  s.date = %q{2009-11-03}
  s.authors = ["Brad Smith"]
  s.email = %q{brad.smith@fullspectrum.net}
  s.summary = %q{rinitd provides simple init.d type structure to control scripts.}
  s.homepage = %q{http://www.me.org/}
  s.description = %q{rinitd provides simple init.d type structure to control scripts.}
  s.files = [ "README.rdoc", "TODO", "LICENSE", "examples/init.d_example.rb", "lib/rinitd.rb"]
  s.add_dependency "sys-proctable", ">=0.8.1"
  s.add_dependency "fileutils", ">=0"
  s.require_path = 'lib'
end



lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "phaserunner_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "phaserunner_cli"
  spec.version       = PhaserunnerCli::VERSION
  spec.authors       = ["Robert J. Berger"]
  spec.email         = ["rberger@ibd.com"]

  spec.summary       = %q{Read values from the Grin PhaseRunner Controller for logging}
  spec.description   = %q{Read values from the Grin PhaseRunner Controller via Modbus RTU suitable for logging}
  spec.homepage      = "https://github.com/rberger/phaserunner_cli"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.has_rdoc = true
  spec.extra_rdoc_files = ['README.rdoc','phaserunner_cli.rdoc']
  spec.rdoc_options << '--title' << 'phaserunner_cli' << '--main' << 'README.rdoc' << '-ri'

  spec.add_runtime_dependency "gli","~> 2.17"
  spec.add_runtime_dependency "rmodbus",  "~> 1.3"
  spec.add_runtime_dependency "serialport",    "~> 1.3"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "aruba", "~> 0.14"
  spec.add_development_dependency "yard", "~> 0.9"

end

# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','phaserunner_cli','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'phaserunner_cli'
  s.version = PhaserunnerCli::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','phaserunner_cli.rdoc']
  s.rdoc_options << '--title' << 'phaserunner_cli' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'phaserunner_cli'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.17.1')
end

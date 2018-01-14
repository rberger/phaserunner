
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "phaserunner/version"

Gem::Specification.new do |spec|
  spec.name          = "phaserunner"
  spec.version       = Phaserunner::VERSION
  spec.authors       = ["Robert J. Berger"]
  spec.email         = ["rberger@ibd.com"]

  spec.summary       = %q{Read values from the Grin PhaseRunner Controller for logging}
  spec.description   = %q{Read values from the Grin PhaseRunner Controller via Modbus RTU suitable for logging}
  spec.homepage      = "https://github.com/rberger/phaserunner"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.has_rdoc = true
  spec.extra_rdoc_files = ['README.rdoc', 'phaserunner.rdoc']
  spec.rdoc_options << '--title' << 'phaserunner' << '--main' << 'README.rdoc' << '-ri'

  spec.add_runtime_dependency 'gli', '~> 2.17'
  spec.add_runtime_dependency 'rmodbus', '~> 1.3'
  spec.add_runtime_dependency 'serialport', '~> 1.3'
  spec.add_runtime_dependency 'asi_bod', '~> 0.1.3'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rdoc'
  spec.add_development_dependency 'aruba', '~> 0.14'
  spec.add_development_dependency 'yard', '~> 0.9'
end

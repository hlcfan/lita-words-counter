Gem::Specification.new do |spec|
  spec.name          = "lita-words-counter"
  spec.version       = "0.1.0"
  spec.authors       = ["Alex S"]
  spec.email         = ["hlcfan.yan@gmail.com.com"]
  spec.description   = 'count user words'
  spec.summary       = 'user words counter plugin for lita'
  spec.homepage      = "https://github.com/hlcfan/lita-words-counter"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 3.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
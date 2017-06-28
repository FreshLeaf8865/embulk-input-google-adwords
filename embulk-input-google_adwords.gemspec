
Gem::Specification.new do |spec|
  spec.name          = "embulk-input-google_adwords"
  spec.version       = "0.1.0"
  spec.authors       = ["topdeveloper"]
  spec.summary       = "Google Adwords input plugin for Embulk"
  spec.description   = "Loads records from Google Adwords."
  # TODO set this: spec.email         = [""]
  spec.licenses      = ["MIT"]
  # TODO set this: spec.homepage      = ""

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'google-adwords-api', ['>= 0.25.0']

  spec.add_development_dependency 'embulk', ['>= 0.8.25']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
end

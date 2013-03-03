# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ledger/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mal Curtis"]
  gem.email         = ["mal@sitepoint.com"]
  gem.description   = %q{Redis backed account activity streams}
  gem.summary       = %q{Creates a per account activity stream for your Saas Ruby app}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ledger"
  gem.require_paths = ["lib"]
  gem.version       = Ledger::VERSION

  # Declaritive Redis Keys
  gem.add_runtime_dependency "nest"
end

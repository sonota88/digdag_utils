lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "digdag_utils/version"

Gem::Specification.new do |spec|
  spec.name          = "digdag_utils"
  spec.version       = DigdagUtils::VERSION
  spec.authors       = ["sonota88"]
  spec.email         = ["yosiot8753@gmail.com"]

  spec.summary       = %q{My Digdag utilities.}
  spec.description   = %q{My Digdag utilities.}
  spec.homepage      = "https://github.com/sonota88/digdag_tools"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sonota88/digdag_utils"
  spec.metadata["changelog_uri"] = "https://github.com/sonota88/digdag_utils"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rufo", "~>0.12.0"
end

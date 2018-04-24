
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ssm_env/version"

Gem::Specification.new do |spec|
  spec.name          = "ssm_env"
  spec.version       = SsmEnv::VERSION
  spec.authors       = ["Mikko Kokkonen"]
  spec.email         = ["mikko@mikian.com"]

  spec.summary       = %q{Store environment varaibles to Amazon SSM Parameter Store}
  spec.description   = %q{
    Simple tool to keep secrets in SSM Parameter Store for example for Jenkins to use
  }
  spec.homepage      = "https://github.com/mikian/ssm_env"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'aws-sdk-ssm'
  spec.add_dependency 'thor'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pact/messages/version'

Gem::Specification.new do |spec|
  spec.name          = 'pact-messages'
  spec.version       = Pact::Messages::VERSION
  spec.authors       = ['Alex Malkov', 'David Sevcik']
  spec.email         = ['alex.a.malkov@gmail.com', 'david.sevcik@reevoo.com']

  spec.summary       = 'Enables consumer driven contract testing for asynchronous message driven systems.'
  spec.description   = 'Enables consumer driven contract testing for asynchronous message driven systems.'
  spec.homepage      = 'https://github.com/reevoo/pact-messages'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://github.com/reevoo/pact-messages'
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(/^(test|spec|features)\//) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'pact', '~> 1.9'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rubocop', '~> 0.28'
end

Gem::Specification.new do |s|
  s.name = 'http_client_detector'
  s.version = '0.2.1'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Taras Struk']
  s.date = '2013-12-16'
  s.extra_rdoc_files = [
      'README.md'
  ]
  s.files = %w{
      README.md
      Gemfile
      Gemfile.lock
      spec/spec_helper.rb
      spec/lib/http_client_detector_spec.rb
      lib/http_client_detector.rb
      lib/http_client_info.rb
  }
  s.homepage = 'http://github.com/experteer/http_client_detector'
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.26'
  s.summary = 'Rack Middleware for querying http client info'

  s.specification_version = 3

  s.add_runtime_dependency "rack", "~> 1.4"
  s.add_runtime_dependency "rack-contrib", "~> 1.2.0"
  s.add_runtime_dependency "rest-client", "1.6.7"
  s.add_runtime_dependency "json", "~> 1.7"

  s.add_development_dependency "rake", "0.8.7"
  s.add_development_dependency "rack-test", "~> 0.6"
  s.add_development_dependency "rspec", "~> 2.14"
  s.add_development_dependency "mime-types", "~> 1.25"
  s.add_development_dependency "webmock", "~> 1.13"


end

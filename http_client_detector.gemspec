Gem::Specification.new do |s|
  s.name = 'http_client_detector'
  s.version = '0.0.1'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Taras Struk']
  s.date = '2013-12-16'
  s.extra_rdoc_files = [
      'README.txt'
  ]
  s.files = [
      'lib/http_client_detector.rb'
  ]
  s.homepage = 'http://github.com/experteer/http_client_detector'
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.26'
  s.summary = 'Rack Middleware for querying http client info'

  s.specification_version = 3

  s.add_runtime_dependency(%q<rack>, ['1.4.5'])
  s.add_runtime_dependency(%q<rest-client>, ['1.6.7'])
  s.add_runtime_dependency(%q<json>, ['~> 1.7'])

  s.add_development_dependency(%q<rake>, ['0.8.7'])
  s.add_development_dependency(%q<rack-test>, ['~> 0.6'])
  s.add_development_dependency(%q<rspec>, ['~> 2.14'])
  s.add_development_dependency(%q<mime-types>, ['~> 1.25'])
  s.add_development_dependency(%q<webmock>, ['~> 1.13'])


end
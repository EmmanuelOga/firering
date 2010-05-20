Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'firering'
  s.version           = '0.1.0'
  s.date              = '2010-05-20'
  s.rubyforge_project = 'firering'

  s.summary     = "Campfire API interface powered by EventMachine and Yajl."
  s.description = "Campfire API interface powered by EventMachine and Yajl."

  s.authors  = ["Emmanuel Oga"]
  s.email    = 'EmmanuelOga@gmail.com'
  s.homepage = 'http://github.com/EmmanuelOga/firering'

  s.require_paths = %w[lib]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.rdoc LICENSE]

  s.add_dependency('eventmachine', [">= 0.12.10"])
  s.add_dependency('em-http-request', [">= 0.2.7"])
  s.add_dependency('yajl', [">= 0.7.6"])

  s.add_development_dependency('rspec', [">= 1.3.0"])

  # = MANIFEST =
  s.files = %w[
    LICENSE
    README.rdoc
    Rakefile
    examples/events.rb
    examples/recent_messages.rb
    examples/rooms.rb
    examples/update_room.rb
    firering.gemspec
    lib/firering.rb
    lib/firering/data.rb
    lib/firering/data/message.rb
    lib/firering/data/room.rb
    lib/firering/data/upload.rb
    lib/firering/data/user.rb
    lib/firering/http.rb
    lib/firering/requests.rb
    lib/firering/streaming.rb
    spec/data_spec.rb
    spec/firering_spec.rb
    spec/spec_helper.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^spec/ }
end

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'firering'
  s.version           = '1.2.2'
  s.date              = '2011-10-26'
  s.rubyforge_project = 'firering'

  s.summary     = "Campfire API interface powered by eventmachine em-http-request and yajl-ruby."
  s.description = "Campfire API interface powered by eventmachine em-http-request and yajl-ruby."

  s.authors  = ["Emmanuel Oga"]
  s.email    = 'EmmanuelOga@gmail.com'
  s.homepage = 'http://github.com/EmmanuelOga/firering'

  s.require_paths = %w[lib]

  s.executables = ["campf-notify"]
  s.default_executable = 'campf-notify'

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.rdoc LICENSE]

  s.add_dependency('eventmachine', ["~> 0.12.10"])
  s.add_dependency('em-http-request', ["~> 0.3.0"])
  s.add_dependency('yajl-ruby', ["~> 0.7.6"])

  s.add_development_dependency('rspec', ["~> 2.6.0"])
  s.add_development_dependency('rack', [">= 1.2.0"])
  s.add_development_dependency('thin', ["~> 1.2.0"])
  s.add_development_dependency('rake')

  # = MANIFEST =
  s.files = %w[
    Gemfile
    LICENSE
    README.rdoc
    Rakefile
    bin/campf-notify
    examples/authenticate.rb
    examples/events.rb
    examples/recent_messages.rb
    examples/rooms.rb
    examples/update_room.rb
    firering.gemspec
    lib/firering.rb
    lib/firering/connection.rb
    lib/firering/data/message.rb
    lib/firering/data/room.rb
    lib/firering/data/upload.rb
    lib/firering/data/user.rb
    lib/firering/instantiator.rb
    lib/firering/requests.rb
    log/.gitignore
    spec/firering/connection_spec.rb
    spec/firering/data/message_spec.rb
    spec/firering/data/room_spec.rb
    spec/firering/data/user_spec.rb
    spec/firering/data_spec.rb
    spec/fixtures/headers/delete_messages_ID_star.json
    spec/fixtures/headers/get_room_ID.json
    spec/fixtures/headers/get_room_ID_live.json
    spec/fixtures/headers/get_room_ID_recent.json
    spec/fixtures/headers/get_room_ID_transcript.json
    spec/fixtures/headers/get_room_ID_transcript_ID_ID_ID.json
    spec/fixtures/headers/get_room_ID_uploads.json
    spec/fixtures/headers/get_rooms.json
    spec/fixtures/headers/get_search_harmless.json
    spec/fixtures/headers/get_users_ID.json
    spec/fixtures/headers/get_users_me.json
    spec/fixtures/headers/post_messages_ID_star.json
    spec/fixtures/headers/post_room_ID_join.json
    spec/fixtures/headers/post_room_ID_leave.json
    spec/fixtures/headers/post_room_ID_speak.json
    spec/fixtures/headers/post_room_ID_unlock.json
    spec/fixtures/headers/put_room_ID.json
    spec/fixtures/json/delete_messages_ID_star.json
    spec/fixtures/json/get_room_ID.json
    spec/fixtures/json/get_room_ID_live.json
    spec/fixtures/json/get_room_ID_recent.json
    spec/fixtures/json/get_room_ID_transcript.json
    spec/fixtures/json/get_room_ID_transcript_ID_ID_ID.json
    spec/fixtures/json/get_room_ID_uploads.json
    spec/fixtures/json/get_rooms.json
    spec/fixtures/json/get_search_harmless.json
    spec/fixtures/json/get_users_ID.json
    spec/fixtures/json/get_users_me.json
    spec/fixtures/json/post_messages_ID_star.json
    spec/fixtures/json/post_room_ID_join.json
    spec/fixtures/json/post_room_ID_leave.json
    spec/fixtures/json/post_room_ID_lock.json
    spec/fixtures/json/post_room_ID_speak.json
    spec/fixtures/json/post_room_ID_unlock.json
    spec/fixtures/json/put_room_ID.json
    spec/fixtures/load_server.rb
    spec/fixtures/retrieve.rb
    spec/spec_helper.rb
    spec/support/helpers.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^spec/ }
end

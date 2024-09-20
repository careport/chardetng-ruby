# frozen_string_literal: true

require_relative "lib/char_det_ng/version"

Gem::Specification.new do |spec|
  spec.name = "char_det_ng"
  spec.version = CharDetNg::VERSION
  spec.authors = ["Jon Zeppieri"]
  spec.email = ["zeppieri@gmail.com"]

  spec.summary = "Character encoding detector"
  spec.description = "Uses chardetng to detect character encodings"
  spec.homepage = "https://github.com/careport/chardetng-ruby"
  spec.required_ruby_version = ">= 3.0.0"
  spec.required_rubygems_version = ">= 3.3.11"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/careport/chardetng-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions = ["ext/char_det_ng/Cargo.toml"]
end

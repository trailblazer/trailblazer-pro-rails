require_relative "lib/trailblazer/pro/rails/version"

Gem::Specification.new do |spec|
  spec.name = "trailblazer-pro-rails"
  spec.version = Trailblazer::Pro::Rails::VERSION
  spec.authors = ["Nick Sutterer"]
  spec.email = ["apotonick@gmail.com"]

  spec.summary = "Rails support for Trailblazer PRO."
  spec.homepage = "https://trailblazer.to/2.1/pro"
  spec.required_ruby_version = ">= 2.5.0"
  spec.license = "LGPL-3.0"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "trailblazer-pro", "0.0.2"
end

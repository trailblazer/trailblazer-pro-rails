require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task default: :test


# test_uninitialized_generator
Rake::TestTask.new(:test_1) do |t|
  t.test_files = FileList["test/dummies/uninitialized/test/generator_test.rb"]
end

# test wtf? in different scenarios
Rake::TestTask.new(:test_2) do |t|
  t.test_files = FileList["test/dummies/uninitialized/test/railtie_test.rb"]
end

# test diagram import in different scenarios
Rake::TestTask.new(:test_3) do |t|
  t.test_files = FileList["test/dummies/uninitialized/test/import_test.rb"]
end

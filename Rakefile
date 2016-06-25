require 'bundler/setup'
require 'dotenv/tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = %w(lib spec)
  t.name = 'spec'
  # t.warning = true
  # t.verbose = true
  t.test_files = FileList['spec/**/*_spec.rb']
end

Rake::TestTask.new do |t|
  t.libs = %w(lib spec)
  t.name = 'spec:stories'
  t.test_files = FileList['spec/stories/**/*_spec.rb']
end

Rake::TestTask.new do |t|
  t.libs = %w(lib spec)
  t.name = 'spec:units'
  t.test_files = FileList['spec/unit/**/*_spec.rb']
end

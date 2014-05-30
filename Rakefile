require 'bundler'

begin
  require 'rspec/core/rake_task'
rescue LoadError
  puts "Please install rspec (bundle install)"
  exit
end

begin
  require 'rdoc/task'
  Rake::RDocTask.new do |rdoc|
    version = MooMoo::VERSION

    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "solusvm #{version}"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
  task :rdoc do
    abort "rdoc is not available. In order to run rdoc, you must: sudo gem install rdoc"
  end
end

desc "Sanitize sensitive info from cassettes"
task :sanitize_cassettes do
  if ENV['OPENSRS_TEST_KEY'] && ENV['OPENSRS_TEST_URL'] && ENV['OPENSRS_TEST_USER']
    path = File.join(File.dirname(__FILE__), 'spec', 'vcr_cassettes')
    files = Dir.glob("#{path}/**/*.yml")
    if files.any?
      files.each do |file|
        old = File.read(file)
        puts "Sanitizing #{file}"
        old.gsub!(ENV['OPENSRS_TEST_KEY'], '123key')
        old.gsub!(ENV['OPENSRS_TEST_URL'], 'server.com')
        old.gsub!(ENV['OPENSRS_TEST_USER'], 'opensrs_user')
        old.gsub!(/x-signature.*?\n.*?\w{32}/, "x-signature:\n      - 00000000000000000000000000000000")
        old.gsub!(/\w{16}:\w{6}:\w{2,8}/, '0000000000000000:000000:00000')
        File.open(file, 'w') do |f|
          f.write old
        end
      end
    else
      puts "Nothing to sanitize"
    end
  else
    puts "I can't sanitize without setting up OPENSRS_TEST_KEY, OPENSRS_TEST_URL, OPENSRS_TEST_USER"
  end
end

RSpec::Core::RakeTask.new :spec
Bundler::GemHelper.install_tasks

task :default => [:spec]

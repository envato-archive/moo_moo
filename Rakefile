require 'bundler'

begin
  require 'rspec/core/rake_task'
rescue LoadError
  puts "Please install rspec (bundle install)"
  exit
end 


desc "Sanitize sensitive info from cassettes"
task :sanitize_cassettes do
  if ENV['OPENSRS_TEST_KEY'] && ENV['OPENSRS_TEST_URL'] && ENV['OPENSRS_TEST_USER'] && ENV['OPENSRS_TEST_PASS']
    path = File.join(File.dirname(__FILE__), 'spec', 'vcr_cassettes')
    files = Dir.glob("#{path}/**/*.yml")
    if files.any?
      files.each do |file|
        old = File.read(file)
        if old.match(/#{ENV['OPENSRS_TEST_KEY']}|#{ENV['OPENSRS_TEST_URL']}|#{ENV['OPENSRS_TEST_USER']}|#{ENV['OPENSRS_TEST_PASS']}/)
          puts "Sanitizing #{file}"
          old.gsub!(ENV['OPENSRS_TEST_KEY'], '123key')
          old.gsub!(ENV['OPENSRS_TEST_URL'], 'horizon.opensrs.net')
          old.gsub!(ENV['OPENSRS_TEST_USER'], 'opensrs_user')
          old.gsub!(ENV['OPENSRS_TEST_PASS'], 'password')
          File.open(file, 'w') do |f|
            f.write old
          end
        end
      end
    else
      puts "Nothing to sanitize"
    end
  else
    puts "I can't sanitize without setting up OPENSRS_TEST_KEY, OPENSRS_TEST_URL, OPENSRS_TEST_USER, and OPENSRS_TEST_PASS"
  end
end

Bundler::GemHelper.install_tasks

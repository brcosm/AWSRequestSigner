include FileUtils::Verbose

namespace :test do

  desc "Run the Tests for iOS"
  task :ios  do
    run_tests('Unit Tests', 'iphonesimulator')
    tests_failed('iOS') unless $?.success?
  end
end

desc "Run the Tests for iOS"
task :test do
  Rake::Task['test:ios'].invoke
end

task :default => 'test'


private

def run_tests(scheme, sdk)
  sh("xcodebuild -workspace AWSRequestSigner.xcworkspace -scheme '#{scheme}' -sdk '#{sdk}' -configuration Release clean test | xcpretty -c ; exit ${PIPESTATUS[0]}") rescue nil
end

def tests_failed(platform)
  puts red("#{platform} unit tests failed")
  exit $?.exitstatus
end

def red(string)
 "\033[0;31m! #{string}"
end
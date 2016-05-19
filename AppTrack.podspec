#
# Be sure to run `pod lib lint AppTrack.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AppTrack"
  s.version          = "0.1.0"
  s.summary          = "A short description of AppTrack."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/AppTrack"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Malcolm Hall" => "malcolmhall@users.noreply.github.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/AppTrack.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'MHData/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MHData' => ['MHData/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreData'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.preserve_paths = "AppTrack/Frameworks"
  s.frameworks = 'AppTrack/Frameworks'
  s.xcconfig            = { 'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/AppTrack/AppTrack/Frameworks' }


end


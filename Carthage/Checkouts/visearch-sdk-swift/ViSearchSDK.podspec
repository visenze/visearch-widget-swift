#
#  Be sure to run `pod spec lint ViSearchSwift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  
  s.name         = "ViSearchSDK"
  s.version      = "1.2.0"
  s.summary      = "A Visual Search API solution (Swift SDK)"

  s.description  = <<-DESC
                    ViSearch is a Visual Recognition Service API developed by ViSenze Pte. Ltd.
                    This Swift SDK provides a quick way to integrate with the ViSearch API.
                   DESC

  s.homepage     = "https://github.com/visenze/visearch-sdk-swift"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license          = {:type => "MIT", :file => "LICENSE"}
 
  s.author             = { "Ngo Hung" => "hung@visenze.com" }
 
  # Or just: s.author    = "Ngo Hung"
  # s.authors            = { "Ngo Hung" => "hung@visenze.com" }
  # s.social_media_url   = "http://twitter.com/Ngo Hung"

  s.source = { :git => 'https://github.com/visenze/visearch-sdk-swift.git', :tag => s.version }
  s.ios.deployment_target = '8.0'

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "ViSearchSDK/ViSearchSDK/**/*.{h,swift}"
  #s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  s.xcconfig    = { 'SWIFT_VERSION' => '3.0' }
 
end

Pod::Spec.new do |s|

  
  s.name         = "ViSearchWidgets"
  s.version      = "0.4.0"
  s.summary      = "ViSenze mobile widgets"

  s.description  = <<-DESC
                   ViSenze mobile widgets SDK (Swift)
                   DESC

  s.homepage     = "https://github.com/visenze/visearch-widget-swift"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license          = {:type => "MIT", :file => "LICENSE"}
 
  s.author             = { "Ngo Hung" => "hung@visenze.com" }
  

  s.platform     = :ios, "8.0"

  
  s.source       = { :git => "https://github.com/visenze/visearch-widget-swift.git", :tag => "#{s.version}" }


  s.source_files  = "ViSearchWidgets/ViSearchWidgets/**/*.{h,swift}"
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
  s.resource_bundles = {
      'com.visenze.icons' => ['ViSearchWidgets/ViSearchWidgets/**/*.xcassets'],
      'com.visenze.fonts' => ['ViSearchWidgets/ViSearchWidgets/**/*.ttf'],
      'com.visenze.string' => ['ViSearchWidgets/ViSearchWidgets/String/*.strings'] ,
      'com.visenze.ui' => ['ViSearchWidgets/ViSearchWidgets/**/*.xib']
      

  }

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  s.frameworks = "Photos" , "AVFoundation", "MediaPlayer"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "ViSearchSDK", "~> 1.2.1"
  s.dependency "Kingfisher", "~> 3.2.1"
  #s.dependency "SnapKit", "~> 3.0.2"
  s.dependency "LayoutKit", "~> 4.0.0"
  s.xcconfig    = { 'SWIFT_VERSION' => '3.0' }
 

end

Pod::Spec.new do |spec|
  spec.name         = "TabPagerX"
  spec.version      = "1.0.0"
  spec.summary      = "A SwiftUI-based tab pager library for iOS."
  spec.description  = <<-DESC
                      TabPager is a SwiftUI-based library that provides a customizable tab pager for iOS applications. It supports both fixed and scrollable tab layouts, with extensive styling options for tab buttons and indicators.
                    DESC
  spec.homepage     = "https://github.com/camosss/TabPagerX"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "HoSung Kang" => "camosss777@gmail.com" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/camosss/TabPagerX.git", :tag => spec.version.to_s }
  spec.swift_version = "5.5"
  spec.source_files  = "Sources/TabPagerX/**/*.{swift}"
  spec.frameworks    = "SwiftUI"
  spec.requires_arc = true
end

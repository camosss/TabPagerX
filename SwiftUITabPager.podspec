Pod::Spec.new do |spec|
  spec.name         = "SwiftUITabPager"
  spec.version      = "4.1.2"
  spec.summary      = "A SwiftUI tab paging library for iOS."
  spec.description  = <<-DESC
                      SwiftUITabPager provides a customizable tab pager for SwiftUI applications. It supports both fixed and scrollable tab layouts, id-based selection with per-tab state preservation, and extensive styling options for tab buttons and indicators.
                    DESC
  spec.homepage     = "https://github.com/camosss/SwiftUITabPager"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "HoSung Kang" => "camosss777@gmail.com" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/camosss/SwiftUITabPager.git", :tag => spec.version.to_s }
  spec.swift_version = "5.5"
  spec.source_files  = "Sources/SwiftUITabPager/**/*.{swift}"
  spec.frameworks    = "SwiftUI"
  spec.requires_arc = true
end

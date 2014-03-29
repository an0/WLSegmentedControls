Pod::Spec.new do |s|
  s.name         = "WLSegmentedControls"
  s.version      = "0.0.1"
  s.summary      = "Custom implementation of UISegmentedControl"

  s.description  = <<-DESC
                   WLHorizontalSegmentedControl is a custom implementation of UISegmentedControl with multiple-selection support.
                   WLVerticalSegmentedControl is the corresponding vertical version.
                   DESC

  s.homepage     = "https://github.com/an0/WLSegmentedControls"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Ling Wang" => "", "Yusuke Ohashi" => "yusuke@junkpiano.me" }
  s.source       = { :git => "https://github.com/yuchan/WLSegmentedControls.git", :commit => "5ba9ffb8ee45bec32b224ca3eb96f1b38f15bfcc" }
  s.source_files  = 'Classes', 'Classes/*.{h,m}'
  s.framework = 'UIKit'
  s.platform = :ios, '5.0'
end

Pod::Spec.new do |s|
  s.name         = "WLSegmentedControls"
  s.version      = "0.0.1"
  s.summary      = "A short description of WLSegmentedControls."

  s.description  = <<-DESC
                   WLHorizontalSegmentedControl is a custom implementation of UISegmentedControl with multiple-selection support.
                   WLVerticalSegmentedControl is the corresponding vertical version.
                   DESC

  s.homepage     = "https://github.com/an0/WLSegmentedControls"
  s.license      = { :file => 'LICENSE' }
  s.author       = { "Ling Wang" => "", "Yusuke Ohashi" => "yusuke@junkpiano.me" }
  s.source       = { :git => "https://github.com/yuchan/WLSegmentedControls.git" }
  s.source_files  = 'Classes', 'Classes/*.{h,m}'
end

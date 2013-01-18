Pod::Spec.new do |s|
  s.name     = 'PAPeek'
  s.version  = '0.1'
  s.license  = 'MIT'
  s.summary  = 'A simple universal photo browser'
  s.homepage = 'https://github.com/doPanic/PAPeek'
  s.author   = { 'Daniel Dengler' => 'ddengler@dopanic.com' }
  s.source   = { :git => 'https://github.com/doPanic/PAPeek.git', :tag => '0.1' }
  s.platform = :ios
  s.requires_arc = true
   
  s.source_files = 'Classes'
end
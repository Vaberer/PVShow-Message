Pod::Spec.new do |s|
  s.name = 'PVShow-Message'
  s.version = '1.2.1'
  s.license = 'MIT'
  s.summary = 'Simple library to show custom message with a touch event'
  s.homepage = 'https://github.com/Vaberer/PVShow-Message'
  s.screenshots = "https://raw.githubusercontent.com/Vaberer/PVShow-Message/master/resources/pvshow_message.gif"
  s.social_media_url = 'http://twitter.com/vaberer'
  s.authors = { "Patrik Vaberer" => "patrik.vaberer@gmail.com" }
  s.source = { :git => 'https://github.com/Vaberer/PVShow-Message.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.source_files   = 'Source/PVShowMessage.swift'
  s.requires_arc = true
end

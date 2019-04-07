#
#  Be sure to run `pod spec lint SimpleJSON.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "RDFNetworking"
  s.version      = "1.0.0"
  s.summary      = "makes getting and posting JSON super easy"

  s.description  = "call SimpleJSON.get to fetch json data and SimpleJSON.post to post JSON data"

  s.homepage     = "https://github.com/rdforte/SimpleJSON"


  s.license      = "MIT"


  s.author             = { "ryan forte" => "forte.ryan@hotmail.com" }

  s.source       = { :git => "https://github.com/rdforte/SimpleJSON", :tag => "#{s.version}" }

  s.source_files  = "RDFNetworking"
  s.exclude_files = "Classes/Exclude"



end

Pod::Spec.new do |s|

  s.name         = 'VCRouter'
  s.version      = '0.0.4'
  s.summary      = 'VCRouter - prototype'

  s.description  = <<-DESC
  					VCRouter - Prototype View Controller router for iOS/macOS/tvOS (Swift). 
            DESC

  s.homepage     = 'https://github.com/ivlevAstef/VCRouter'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.documentation_url = 'https://github.com/ivlevAstef/VCRouter'

  s.author       = { 'Alexander.Ivlev' => 'ivlev.stef@gmail.com' }
  s.source       = { :git => 'https://github.com/ivlevAstef/VCRouter.git', :tag => "v#{s.version}" }

  s.requires_arc = true
  
  header_file = 'VCRouter/VCRouter/VCRouter.h'
  core_files = 'VCRouter/VCRouter/Sources/**/*.swift'

  s.source_files = core_files, header_file
  
  s.ios.deployment_target = '8.0'
end
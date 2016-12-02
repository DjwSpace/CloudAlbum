Pod::Spec.new do |s|
  s.name         = "CloudAlbum"
  s.version      = "0.0.1"
  s.summary      = "A short description of CloudAlbum."
  s.description  = <<-DESC
                   DESC
  s.homepage     = "http://EXAMPLE/CloudAlbum"
  s.license      = "MIT (example)"
  s.author             = { "Zhiaohun" => "1151946268@qq.com" }
  s.source       = { :git => "https://github.com/Zhiaohun/CloudAlbum.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
end

Pod::Spec.new do |s|
  s.name         = "KTAnimator"
  s.version      = "1.1"
  s.summary      = "A scrollview that can animate its contents, and paginate them as slides."

  s.description  = <<-DESC
  A scrollview that can animate its contents, and paginate them as slides.
                   DESC

  s.homepage     = "https://github.com/laplacesdemon/KTAnimator"
  s.license      = { :type => "MIT License", :file => "LICENSE" }
  s.author       = { "Suleyman Melikoglu" => "suleyman@katu.com.tr", "Batu Orhanalp" => "batu@katu.com.tr" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/laplacesdemon/KTAnimator.git", :tag => "1.0" }
  s.source_files = 'KTAnimator/*.{h,m}'
  s.requires_arc = true
end

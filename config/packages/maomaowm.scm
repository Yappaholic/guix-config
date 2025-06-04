(define-module (config packages maomaowm)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages ninja)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system meson)
  #:use-module (guix licenses)
  #:use-module (config packages xkeyboard-config)
  #:export (maomao)
  )
;; TODO rename packages to respect versioning
(define-public maomao
  (let ((commit "b0851866ab644452bfec0cc2c73c14ed31266423"))
    (package
     (name "maomao")
     (version "0.5.4")
     (source (origin
              (method git-fetch)
              (uri
               (git-reference
                (url "https://github.com/DreamMaoMao/maomaowm")
                (commit commit)))
              (sha256
               (base32
                "0nwny9k1m12m4dvdxsbfjqn3l060y4fjhnll2f1m43dz0iccmn7s"))))
     (build-system meson-build-system)
     (native-inputs
      (list
       pkg-config
       ninja
       cmake
       wlroots-0.19.0
       pixman-0.46.0
       pcre2
       xorg-server-xwayland
       libxcb
       xcb-util-wm
       xcb-util-renderutil))
     (inputs
      (list wlroots-0.19.0))
     (synopsis "Wayland compositor, based on DWL")
     (description "DWL with animations and scroller layout")
     (home-page "https://github.com/DreamMaoMao/maomaowm.git")
     (license gpl3+))))

(define-public wlroots-0.19.0
  (package
   (inherit wlroots)
   (version "0.19.0")
   (source (origin
            (method git-fetch)
            (uri
             (git-reference
              (url "https://github.com/DreamMaoMao/wlroots")
              (commit "afbb5b7c2b14152730b57aa11119b1b16a299d5b")))
            (sha256
             (base32
              "11lxbimp8wr559bnjps7mkd9higqzxshq9wv9s6dpgdax053wmd5"))))
   (build-system meson-build-system)
   (inputs (modify-inputs (package-inputs wlroots)
                          (delete "pixman")
                          (delete "wayland-protocols")
                          (delete "libxkbcommon")
                          (prepend pixman-0.46.0)
                          (prepend libxkbcommon-1.10.0)
                          (prepend wayland-protocols-1.44)
                          ))
   ))

(define-public libxkbcommon-1.10.0
  (package
   (inherit libxkbcommon)
   (version "1.10.0")
   (source
    (origin (method url-fetch)
            (uri "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.10.0.tar.gz")
            (sha256
             (base32
              "0ccn18vvq0r583mcaw5gh288wd03yfdm6jxcq6gpr8bc9md5h9q4"))))
   (arguments
    '(#:tests? #f))
   ))

(define-public pixman-0.46.0
  (package
   (inherit pixman)
   (version "0.46.0")
   (source (origin
            (method url-fetch)
            (uri
             (string-append
              "https://www.cairographics.org/releases/pixman-" version ".tar.xz"))
            (sha256
             (base32
              "0rwimb762aqiiy6arj420fbqp5x64vbzrcyfz28yk7g73izbbsnj"))))
   (arguments
    '(#:configure-flags
      (list
       "-Dtimers=true"
       "-Dgnuplot=true")))
   (build-system meson-build-system)))

(define-public wayland-protocols-1.44
  (package
   (inherit wayland-protocols)
   (version "1.44")
   (source (origin
            (method url-fetch)
            (uri
             (string-append
              "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/"
              version
              "/wayland-protocols-"
              version
              ".tar.gz"))
            (sha256
             (base32
              "1sw3lz5nmb0ylk5mgf58qnv1ka7sb9r7nyknzzg0hw9am60hlrx8")))))
  )

(define-module (config packages maomaowm)
  #:use-module (guix packages)
  #:use-module (guix download)
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
  (package
   (name "maomao")
   (version "0.5.3")
   (source (origin
            (method url-fetch)
            (uri
             (string-append
              "https://github.com/DreamMaoMao/maomaowm/archive/refs/tags/"
              version ".tar.gz"))
            (sha256
             (base32
              "08mvykga45kachj5w5x5g03jqa9a6abpwbjqi7pa0lv3000p19fg"))))
   (build-system meson-build-system)
   (native-inputs
    (list
     pkg-config
     ninja
     cmake
     wlroots19
     pixman46
     pcre2
     xorg-server-xwayland
     libxcb
     xcb-util-wm
     xcb-util-renderutil))
   (inputs
    (list wlroots19))
   (synopsis "Wayland compositor, based on DWL")
   (description "DWL with animations and scroller layout")
   (home-page "https://github.com/DreamMaoMao/maomaowm.git")
   (license gpl3+)))
(define-public wlroots19
  (package
   (inherit wlroots)
   (version "0.19.0")
   (source (origin
            (method url-fetch)
            (uri
             (string-append
              "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/"
              version "/wlroots-" version ".tar.gz"))
            (sha256
             (base32
              "15mbdz3140zqrzqkdf1zmngwq35kjqhy44y5pn6a33ifr0932zwn"))))
   (build-system meson-build-system)
   (inputs (modify-inputs (package-inputs wlroots)
                          (delete "pixman")
                          (delete "wayland-protocols")
                          (prepend pixman46)
                          (prepend wayland-protocols144)
                          ))
   ))
(define-public pixman46
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

(define-public wayland-protocols144
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

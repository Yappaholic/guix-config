(define-module (config packages xkeyboard-config)
  #:use-module (gnu)
  #:use-module (gnu packages xorg)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:export (xkeyboard-config-2.44))

;; Adds colemak_dh_wide_iso variant
(define-public xkeyboard-config-2.44
  (package
   (inherit xkeyboard-config)
   (version "2.44")
   (properties '((upstream-name . "xkeyboard-config")))
   (source (origin
            (method url-fetch)
            (uri
             (string-append
              "http://www.x.org/releases/individual/data/xkeyboard-config/xkeyboard-config-"
              version
              ".tar.xz"))
            (sha256
             (base32
              "0aillh6pmx5ji5jbqviq007vvg69ahz5832rz941s0xvxqzc7ljl"))))))

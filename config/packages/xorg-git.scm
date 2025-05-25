(define-module (config packages xorg-git)
  #:use-module (config packages xkeyboard-config)
  #:use-module (gnu packages xorg)
  #:export (xorg-server-git))

;; TODO remove this in preference to grafting xorg-server
(define-public xorg-server-git
  (package
   (inherit xorg-server)
   (inputs (modify-inputs
            (package-inputs xorg-server)
            (delete "xkeyboard-cofig")
            (prepend xkeyboard-config-2.44)))))

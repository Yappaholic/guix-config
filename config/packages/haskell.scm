(define-module (config packages haskell)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages wm)
  #:use-module (guix packages)
  #:export (ghc-9999)
  #:export (my-xmonad))

;; TODO remove these packages
(define-public ghc-9999
  (package
   (inherit ghc)
   (inputs (modify-inputs
            (package-inputs ghc)
            (prepend ghc-xmonad-contrib)))))

(define-public my-xmonad
  (package
   (inherit xmonad)
   (inputs (modify-inputs
            (package-inputs xmonad)
            (prepend ghc-xmonad-contrib)))))

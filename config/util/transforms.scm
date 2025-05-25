(define-module (config util transforms)
  #:use-module (guix transformations)
  ;;#:use-module (config packages haskell)
  #:export (transform)
  #:export (ghctransform)
  #:export (xtransform))

(define-public transform
  (options->transformation
   '((with-graft . "mesa=nvda"))))

(define-public xtransform
  (options->transformation
   '((with-graft . "xkeyboard-config=xkeyboard-config@2.44"))))

;; (define-public ghctransform
;;   (options->transformation
;;    '((with-graft . "ghc=ghc@9999"))))

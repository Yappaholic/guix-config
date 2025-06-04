(define-module (config util transforms)
  #:use-module (guix transformations)
  #:use-module (config packages xkeyboard-config)
  #:use-module (guix packages)
  #:export (update-keyboard)
  #:export (update-keyboard-nob))

(define-public update-keyboard
  (package-input-rewriting/spec `(("xkeyboard-config" . ,(const xkeyboard-config-git)))))

(define update-keyboard-nob
  (options->transformation
   '((with-graft . "xkeyboard-config=xkeyboard-config@2.44"))))


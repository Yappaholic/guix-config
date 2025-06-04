(define-module (config services sway)
  #:use-module (srfi srfi-1)
  #:use-module (gnu home services sway)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu system keyboard)
  #:use-module (config packages xkeyboard-config)
  #:use-module (gnu packages wm)
  #:use-module (config util transforms)
  #:use-module (nongnu packages nvidia)
  #:export (home-sway-config))

(define (remove-keybinds list keybinds)
  (define newlist list)
  (for-each (lambda (x)
              (set! newlist
                    (remove (lambda (bind)
                              (equal? (car bind) x)) newlist)))
            keybinds)
  newlist)

(define %my-keybinds
  (remove-keybinds %sway-default-keybindings
                   `($mod+d
                     $mod+Shift+q
                     $mod+e
                     $mod+r)))

(define home-sway-config
  (service home-sway-service-type
           (sway-configuration
            (packages '())
            (outputs
             (list (sway-output
                    (identifier '*)
                    (background "/home/savvy/Pictures/background.png"))))

            (variables '((mod . "Mod4")
                         (term . "ghostty")
                         (left . "h")
                         (right . "l")
                         (up . "k")
                         (down . "j")
                         (launcher . "bemenu-run")))

            (modes '())

            (keybindings
             `(($mod+p . "exec $launcher")
               ($mod+c . "kill")
               ($mod+e . "exec emacsclient -c")
               ,@%my-keybinds))

            (inputs
             (list
              (sway-input
               (identifier "type:keyboard")
               (extra-content '("repeat_rate 30" "repeat_delay 300"))
               (layout
                (keyboard-layout "us,ru" "colemak_dh_wide_iso," #:options '("grp:toggle,ctrl:nocaps"))))))

            (startup-programs (list
                               "emacs --daemon"
                               "wlsunset -s 21:30 -S 06:30 -t 2500 -T 6500"))

            (extra-content '("blur enable\n"
                             "shadows enable\n"
                             "gaps inner 10\n"
                             "gaps outer 10\n"
                             "smart_borders no_gaps\n"
                             "smart_gaps on\n"
                             "default_dim_inactive 0.1\n"
                             "corner_radius 8\n"))

            (bar
             (sway-bar
              (position 'top)
              (status-command "i3status-rs")))
            )))

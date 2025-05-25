;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.
(define-module (config system home)
  #:use-module (gnu home)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services shells))
(home-environment
 (services
  (append (list
           ;; (simple-service 'home-envvars-service
           ;;                 home-environment-variables-service-type
           ;;                 '())
           (service home-bash-service-type
                    (home-bash-configuration
                     (environment-variables (list
                                             '("PATH" . "$PATH:/opt/bin:/home/savvy/.cargo/bin:/home/savvy/go/bin")
                                             '("__GLX_VENDOR_LIBRARY_NAME" . "nvidia")
                                             '("LIBVA_DRIVER_NAME" . "nvidia")))
                     (bashrc (list (local-file
                                    "/home/savvy/.config/guix-config/files/.bashrc"
                                    "bashrc")))
                     (bash-profile (list (local-file
                                          "/home/savvy/.config/guix-config/files/.bash_profile"
                                          "bash_profile")))))
           (service home-dbus-service-type)
           (service home-pipewire-service-type))
          %base-home-services)))

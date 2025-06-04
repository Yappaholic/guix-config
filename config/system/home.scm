;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.
(define-module (config system home)
  #:use-module (gnu home)
  #:use-module (gnu packages)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages image)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages xorg)
  #:use-module (nongnu packages nvidia)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix transformations)
  ;; Personal
  #:use-module (config packages xkeyboard-config)
  #:use-module (config packages maomaowm)
  #:use-module (config util transforms)
  #:use-module (config services sway)
  #:use-module (config packages neovim)
  ;; Services
  #:use-module (gnu services)
  #:use-module (gnu services xorg)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services fontutils)
  #:use-module (gnu home services shells))



(home-environment
 (packages (list
            ;; Everything else
            libvterm
            ;; Desktop utilities
            tealdeer
            gammastep
            wlsunset
            grim
            slurp
            wl-clipboard
            swww
            xdg-desktop-portal
            xdg-desktop-portal-gtk
            xdg-utils
            ncurses
            ;; Fonts
            font-google-noto
            font-google-noto-emoji
            ;; Apps
            (update-keyboard (replace-mesa swayfx))
            (replace-mesa waybar)
            neovim-0.11.1
            (update-keyboard-nob (replace-mesa qtile))
            (update-keyboard-nob (replace-mesa maomao))
            (replace-mesa emacs-pgtk)))

 (services
  (append (list
           ;;home-sway-config
           (service home-startx-command-service-type
                    (xorg-configuration
                     (modules (cons* nvda %default-xorg-modules))
                     (server (update-keyboard (replace-mesa xorg-server)))
                     (drivers '("nvidia"))))

           (service home-bash-service-type
                    (home-bash-configuration
                     (environment-variables (list
                                             '("__GLX_VENDOR_LIBRARY_NAME" . "nvidia")
                                             '("LIBVA_DRIVER_NAME" . "nvidia")))
                     (bashrc (list (local-file
                                    "/home/savvy/.config/guix-config/files/.bashrc"
                                    "bashrc")))
                     (bash-profile (list (local-file
                                          "/home/savvy/.config/guix-config/files/.bash_profile"
                                          "bash_profile")))))
           (service home-dbus-service-type)
           (simple-service 'additional-fonts-service
                           home-fontconfig-service-type
                           (list "~/.nix-profile/share/fonts"
                                 "~/.local/share/fonts"))

           (service home-pipewire-service-type))
          %base-home-services)))

(define-module (config system system)
  ;; Util
  #:use-module (srfi srfi-1)
  ;; Gnu
  #:use-module (gnu)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages haskell)
  ;; Personal
  #:use-module (config packages maomaowm)
  #:use-module (config packages xkeyboard-config)
  #:use-module (config packages xorg-git)
  #:use-module (config util transforms)
  #:use-module (config packages haskell)
  ;; Nongnu
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu services nvidia)
  #:use-module (nongnu system linux-initrd)
  #:use-module (nongnu packages linux))

(use-service-modules cups desktop sddm networking ssh xorg)
(define %my-desktop-services
  (modify-services %desktop-services
                   (gdm-service-type config =>
                                     (gdm-configuration
                                      (inherit config)
                                      (gdm (replace-mesa gdm))
                                      (wayland? #true))
                                     )))

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (kernel-arguments
  '("modprobe.blacklist=nouveau" "nvidia_drm.fbdev=1" "nvidia_drm.modeset=1"))
 (firmware (list linux-firmware nvidia-firmware))
 (locale "en_US.utf8")
 (timezone "Europe/Minsk")
 (keyboard-layout (keyboard-layout "us" "colemak_dh_wide_iso"))
 (host-name "guixx")
 (groups (cons*
          (user-group
           (name "pipewire")
           (system? #t))
          %base-groups))
 ;; The list of user accounts ('root' is implicit).
 (users (cons* (user-account
                (name "savvy")
                (comment "Savvy")
                (group "users")
                (home-directory "/home/savvy")
                (supplementary-groups '("wheel" "netdev" "video" "input" "pipewire" "audio")))
               %base-user-accounts))

 ;; Packages installed system-wide.  Users can also install packages
 ;; under their own account: use 'guix search KEYWORD' to search
 ;; for packages and 'guix install PACKAGE' to install a package.
 (packages (append (list
                    ;; X11
                    (replace-mesa xmonad)
                    ghc ghc-xmonad-contrib
                    xmobar
                    pipewire
                    wireplumber
                    (xtransform xinit)
                    (xtransform setxkbmap)
                    ;; Wayland
                    (xtransform (replace-mesa maomao)))
                   %base-packages))

 ;; Below is the list of system services.  To search for available
 ;; services, run 'guix system search KEYWORD' in a terminal.
 (services
  (cons* (service nvidia-service-type)
         (set-xorg-configuration
          (xorg-configuration
           (modules (cons* nvda %default-xorg-modules))
           (server (xtransform (replace-mesa xorg-server)))
           (drivers '("nvidia"))))
         %my-desktop-services))

 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets (list "/boot/efi"))
              (keyboard-layout keyboard-layout)))
 (swap-devices (list (swap-space
                      (target (uuid
                               "f07dbf7d-8d85-4954-b6db-6157af2e2a0a")))))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.
 (file-systems (cons* (file-system
                       (mount-point "/boot/efi")
                       (device (uuid "5C69-CF56"
                                     'fat32))
                       (type "vfat"))
                      (file-system
                       (mount-point "/")
                       (device (uuid
                                "da9f423e-a1c9-4c4f-b408-731ac84fef39"
                                'ext4))
                       (type "ext4")) %base-file-systems)))

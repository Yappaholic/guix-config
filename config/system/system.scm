(define-module (config system system)
  ;; Scheme
  #:use-module (srfi srfi-1)
  ;; Gnu
  #:use-module (gnu)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages package-management)
  #:use-module (guix transformations)
  #:use-module (guix packages)
  ;; Personal
  #:use-module (config packages maomaowm)
  #:use-module (config packages xkeyboard-config)
  ;; Nongnu
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu services nvidia)
  #:use-module (nongnu system linux-initrd)
  #:use-module (nongnu packages linux))

(use-service-modules cups desktop nix sddm networking ssh xorg)
(define %my-desktop-services
  (modify-services %desktop-services
                   (guix-service-type config =>
                                      (guix-configuration
                                       (inherit config)
                                       (substitute-urls
                                        (append (list
                                                 "https://mirrors.sjtug.sjtu.edu.cn/guix"
                                                 "https://bordeaux-us-east-mirror.cbaines.net/")
                                                %default-substitute-urls))))
                   (delete gdm-service-type)
                   ))

(operating-system
 (kernel linux-6.14)
 (initrd microcode-initrd)
 (kernel-arguments
  '("modprobe.blacklist=nouveau" "nvidia_drm.fbdev=1" "nvidia_drm.modeset=1"))
 (firmware (list linux-firmware nvidia-firmware))
 (locale "en_US.utf8")
 (timezone "Europe/Minsk")
 (keyboard-layout (keyboard-layout "us" "colemak_dh_iso"))
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
                    ghc-xmonad-contrib
                    xmobar
                    ghc
                    nvda
                    libvterm
                    clang-toolchain
                    (replace-mesa nix)
                    (update-keyboard setxkbmap))
                   %base-packages))

 ;; Below is the list of system services.  To search for available
 ;; services, run 'guix system search KEYWORD' in a terminal.
 (services
  (cons* (service nvidia-service-type)
         (service nix-service-type
                  (nix-configuration
                   (extra-config '("experimental-features = nix-command flakes"))))
         %my-desktop-services))

 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets (list "/boot/efi"))
              (keyboard-layout keyboard-layout)))
 (swap-devices (list (swap-space
                      (target (uuid
                               "1250673d-4417-41a8-b75c-d8e4a18b0dac")))))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.
 (file-systems (cons* (file-system
                       (mount-point "/boot/efi")
                       (device (uuid "15A4-FA1A"
                                     'fat32))
                       (type "vfat"))
                      (file-system
                       (mount-point "/")
                       (device (uuid
                                "d7ec11ca-9dff-4c4f-b1b9-1ea5b126ae0a"
                                'ext4))
                       (type "ext4")) %base-file-systems)))

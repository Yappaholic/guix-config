;; TODO finish packaging ghostty
(use-module
 (gnu packages gnome)
 (gnu packages gtk)
 (gnu packages gettext)
 (gnu packages pkg-config))

(define-global ghostty
  (package
   (name "ghostty")
   (version "1.1.3")
   (source (origin
            (method url-fetch)
            (uri
             (string-append
              "https://github.com/ghostty-org/"
              name
              "/archive/refs/tags/v"
              version
              ".tar.gz"))
            (sha256
             (base32
              "159bdq7chrvdnbjmfy3vgallqxd3nccw1z44zyrzgnbrfvnrdib6"))))
   (build-system zig-build-system)
   (native-inputs
    (list pkg-config libadwaita zig-0.14 blueprint-compiler gettext))
   )
  )
)

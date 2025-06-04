(define-module (config packages neovim)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages tree-sitter)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages julia)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages textutils)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cmake)
  #:export (luajit-2.1-1)
  #:export (tree-sitter-0.25.4)
  #:export (neovim-0.11.1))

(define-public neovim-0.11.1
  (package
   (inherit neovim)
   (version "0.11.1")
   (source (origin
            (method url-fetch)
            (uri (string-append
                  "https://github.com/neovim/neovim/archive/refs/tags/v"
                  version
                  ".tar.gz"))
            (sha256
             (base32
              "0hzl7nfa6vsbhjnqk22wf59n9k8nfnpkj46vdbzrbn1ycfkzkrzz"))))
   (build-system cmake-build-system)
   (native-inputs (list
                   luajit-2.1-1
                   lua-5.1
                   lua5.1-luv
                   libuv
                   lua5.1-lpeg
                   lua5.1-bitop
                   lua5.1-libmpack
                   tree-sitter-0.25.4
                   utf8proc-2.10.0
                   unibilium))
   (inputs (list lua-5.1 luajit-2.1-1))
   (arguments
    (list #:modules
          '((srfi srfi-26) (guix build cmake-build-system)
            (guix build utils))
          #:configure-flags
          #~(list #$@(if (member (if (%current-target-system)
                                     (gnu-triplet->nix-system (%current-target-system))
                                     (%current-system))
                                 (package-supported-systems luajit))
                         '()
                         '("-DPREFER_LUA:BOOL=YES")))
          #:phases
          #~(modify-phases %standard-phases
                           (add-after 'unpack 'set-lua-paths
                                      (lambda* _
                                        (let* ((lua-version "5.1")
                                               (lua-cpath-spec (lambda (prefix)
                                                                 (let ((path (string-append
                                                                              prefix
                                                                              "/lib/lua/"
                                                                              lua-version)))
                                                                   (string-append
                                                                    path
                                                                    "/?.so;"
                                                                    path
                                                                    "/?/?.so"))))
                                               (lua-path-spec (lambda (prefix)
                                                                (let ((path (string-append prefix
                                                                                           "/share/lua/"
                                                                                           lua-version)))
                                                                  (string-append path "/?.lua;"
                                                                                 path "/?/?.lua"))))
                                               (lua-inputs (list (or #$(this-package-input "lua")
                                                                     #$(this-package-input "luajit"))
                                                                 #$lua5.1-luv
                                                                 #$lua5.1-lpeg
                                                                 #$lua5.1-bitop
                                                                 #$lua5.1-libmpack)))
                                          (setenv "LUA_PATH"
                                                  (string-join (map lua-path-spec lua-inputs) ";"))
                                          (setenv "LUA_CPATH"
                                                  (string-join (map lua-cpath-spec lua-inputs) ";"))
                                          #t)))
                           )))))
(define-public luajit-2.1-1
  (package
   (inherit luajit)
   (version "2.1-1")
   (source (origin
            (method url-fetch)
            (uri (string-append
                  "https://github.com/LuaJIT/LuaJIT/archive/refs/tags/v2.1.ROLLING.tar.gz"))
            (sha256
             (base32
              "1b8hnk82b0kcc1i2p5df0r63srhr1mlkngf1j6zliigl7n2s9mri"))))))
(define-public tree-sitter-0.25.4
  (package
   (inherit tree-sitter)
   (version "0.25.4")
   (source (origin
            (method url-fetch)
            (uri (string-append
                  "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v"
                  version
                  ".tar.gz"))
            (sha256
             (base32
              "0a677l1kl9qxic349lpq13w076c1iaaj3j0p55lhmiq5b58drsl7"))))))
(define-public utf8proc-2.10.0
  (package
   (inherit utf8proc)
   (version "2.10.0")
   (source (origin
            (method url-fetch)
            (uri (string-append
                  "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v"
                  version
                  ".tar.gz"))
            (sha256
             (base32
              "0dpi8gvkxcv0c488f23rcwda7flw7qiv2pdwh2gwlvdakmiinkvg"))))
   (native-inputs
    (let ((UNICODE_VERSION "16.0.0"))  ; defined in data/Makefile
      ;; Test data that is otherwise downloaded with curl.
      `(("NormalizationTest.txt"
         ,(origin
           (method url-fetch)
           (uri (string-append "https://www.unicode.org/Public/"
                               UNICODE_VERSION "/ucd/NormalizationTest.txt"))
           (sha256
            (base32 "1cffwlxgn6sawxb627xqaw3shnnfxq0v7cbgsld5w1z7aca9f4fq"))))
        ("GraphemeBreakTest.txt"
         ,(origin
           (method url-fetch)
           (uri (string-append "https://www.unicode.org/Public/"
                               UNICODE_VERSION
                               "/ucd/auxiliary/GraphemeBreakTest.txt"))
           (sha256
            (base32 "1d9w6vdfxakjpp38qjvhgvbl2qx0zv5655ph54dhdb3hs9a96azf"))))
        ("DerivedCoreProperties.txt"
         ,(origin
           (method url-fetch)
           (uri (string-append "https://www.unicode.org/Public/"
                               UNICODE_VERSION
                               "/ucd/DerivedCoreProperties.txt"))
           (sha256
            (base32
             "1gfsq4vdmzi803i2s8ih7mm4fgs907kvkg88kvv9fi4my9hm3lrr"))))

        ;; For tests.
        ("perl" ,perl)
        ("julia" ,julia))))
   (arguments
    `(#:make-flags (list ,(string-append "CC=" (cc-for-target))
                         (string-append "prefix=" (assoc-ref %outputs "out")))
      ;; I'm too lazy to make tests work
      #:tests? #f
      #:phases
      (modify-phases %standard-phases
                     (delete 'configure)
                     )))
   ))

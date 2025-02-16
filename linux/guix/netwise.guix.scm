;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu))
;(use-service-modules cups desktop networking ssh xorg)
(use-service-modules networking ssh)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/Chicago")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "netwise")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "slackwise")
                  (comment "Slackwise")
                  (group "users")
                  (home-directory "/home/slackwise")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
;  (packages (append (list (specification->package "nss-certs"))
;                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
;  (services
;   (append (list (service xfce-desktop-service-type)
;
;                 ;; To configure OpenSSH, pass an 'openssh-configuration'
;                 ;; record as a second argument to 'service' below.
;                 (service openssh-service-type)
;                 (set-xorg-configuration
;                   (xorg-configuration (keyboard-layout keyboard-layout))))
;
;           ;; This is the default list of services we
;           ;; are appending to.
;           %desktop-services))
  (services
   (append (list 
                 ;; To configure OpenSSH, pass an 'openssh-configuration'
                 ;; record as a second argument to 'service' below.
		 (service dhcp-client-service-type)
                 (service openssh-service-type))

           ;; This is the default list of services we
           ;; are appending to.
           %base-services))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "23a56c2d-795a-4439-a910-730bb6b97a3c")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "6ED2-12E9"
                                       'fat16))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "5f9bfdce-0ccc-4f75-b4b9-e67a67244420"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))

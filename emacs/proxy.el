(let ((work-username "aflanczewski")
    (work-proxy-file "~/src/work-proxy.el")) ; Get from Gist
(when (and (string= (user-login-name) work-username) (file-exists-p work-proxy-file))
  (load-file work-proxy-file)))

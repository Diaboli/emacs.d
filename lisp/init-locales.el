(defun sanityinc/utf8-locale-p (v)
  "Return whether locale string V relates to a UTF-8 locale."
  (and v (string-match "UTF-8" v)))

(defun sanityinc/locale-is-utf8-p ()
  "Return t iff the \"locale\" command or environment variables prefer UTF-8."
  (or (sanityinc/utf8-locale-p (and (executable-find "locale") (shell-command-to-string "locale")))
      (sanityinc/utf8-locale-p (getenv "LC_ALL"))
      (sanityinc/utf8-locale-p (getenv "LC_CTYPE"))
      (sanityinc/utf8-locale-p (getenv "LANG"))))

(when (or window-system (sanityinc/locale-is-utf8-p))
  ;; 中文简体语言环境
  (set-language-environment 'Chinese-GB)
;;  (set-default-coding-systems 'utf-8-unix)
  (setq default-coding-system 'utf-8-unix)
  ;; default-buffer-file-coding-system变量在emacs23.2之后已被废弃，使用buffer-file-coding-system代替
  (set-default buffer-file-coding-system 'utf-8-unix)
  (setq locale-coding-system 'utf-8-unix)
  ;;(set-terminal-coding-system 'utf-8)
  ;;(modify-coding-system-alist 'process "*" 'utf-8)
  ;;(setq default-process-coding-system '(utf-8 . utf-8))
  ;;(set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system (if (eq system-type 'windows-nt) 'utf-16-le 'utf-8))
  ;; 另外建议按下面的先后顺序来设置中文编码识别方式。
  ;; 重要提示:写在最后一行的，实际上最优先使用; 最前面一行，反而放到最后才识别。
  ;; utf-16le-with-signature 相当于 Windows 下的 Unicode 编码，这里也可写成
  ;; utf-16 (utf-16 实际上还细分为 utf-16le, utf-16be, utf-16le-with-signature等多种)
  (prefer-coding-system 'utf-8)
  (prefer-coding-system 'cp950)
  (prefer-coding-system 'gb2312)
  (prefer-coding-system 'cp936)
  (prefer-coding-system 'gb18030)
  (prefer-coding-system 'utf-16)
  (prefer-coding-system 'utf-8-dos)
  (prefer-coding-system 'utf-8-unix))

(defun change-shell-mode-coding ()
  (progn
    (set-terminal-coding-system 'gbk)
    (set-keyboard-coding-system 'gbk)
    (set-selection-coding-system 'gbk)
    (set-buffer-file-coding-system 'gbk)
    (set-file-name-coding-system 'gbk)
    (modify-coding-system-alist 'process "*" 'gbk)
    (set-buffer-process-coding-system 'gbk 'gbk)
    (set-file-name-coding-system 'gbk)))

;; 更改Emacs的时间区域设置, C区域设置是C语言程序进入时的区域设置, 是标准的美国区域设置, 效果基本上跟指为“ENU”类似.
(add-hook 'org-mode-hook
          (lambda ()
	              (set (make-local-variable 'system-time-locale) "C")))
(add-hook 'shell-mode-hook 'change-shell-mode-coding)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(provide 'init-locales)

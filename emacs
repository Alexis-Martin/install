(package-initialize)

;;MELPA package repository
 (require 'package)
 (let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                     (not (gnutls-available-p))))
        (proto (if no-ssl "http" "https")))
   ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
   (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
   ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
   (when (< emacs-major-version 24)
     ;; For important compatibility libraries like cl-lib
     (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))


(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     ;; (package-installed-p 'evil)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(ensure-package-installed 'company-lua 'company 'f 'ghub 'graphql 'let-alist 'lua-mode 'magit 'git-commit 'magit-popup 'dash 'monokai-theme 's 'smart-tabs-mode 'treepy 'with-editor 'async) ;  --> (nil nil) if iedit and magit are already installed


(package-initialize)
  
;; make indentation commands use space only (never tab character)
(setq-default indent-tabs-mode nil)
;; set default tab char's display width to 4 spaces
(setq-default tab-width 2)  
(setq indent-line-function 'insert-tab)
  
(smart-tabs-advice python-indent-line-1 python-indent)
  
(add-hook 'c-mode-common-hook
					(lambda () (setq indent-tabs-mode t)))
(add-hook 'c++-mode-common-hook
					(lambda () (setq indent-tabs-mode t)))
(add-hook 'python-mode-hook
					(lambda ()
              (setq indent-tabs-mode nil)
              (setq tab-width 4)
          ))

(smart-tabs-insinuate 'c 'c++)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("bd7b7c5df1174796deefce5debc2d976b264585d51852c962362be83932873d9" default)))
 '(fringe-mode 0 nil (fringe))
 '(package-selected-packages
   (quote
    (smart-tabs-mode magit company-lua company lua-mode monokai-theme)))
 '(tab-stop-list (quote (2 4 6)))
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(whitespace-style (quote (face trailing lines-tail))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
      ("melpa" . "https://melpa.org/packages/")))

;; disable menu bar
(menu-bar-mode -1)
  
;; default font size
(set-face-attribute 'default nil :height 80)

;; default font source code
(set-face-attribute 'default t :font "source code pro" )
  
;; Set the directory where recovery files will be saved
(setq backup-directory-alist `(("." . "~/.recovery_emacs")))

;; set the default width to 90 columns
(setq fill-column 90)

;; add the column number in the line counter 
(setq column-number-mode t)

;; display line numbers
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

(global-linum-mode 1) ; always show line numbers

;; auto close bracket insertion. New in emacs 24
(electric-pair-mode 1)

;; turn on highlight matching brackets when cursor is on one
(show-paren-mode 1)

;; show trailing whitespace
(global-whitespace-mode)


;; insert ISO timestamp
(defun insert-current-time ()
  "insert the current time into the current buffer."
  (interactive)
  (insert (format-time-string "%F %T %z"))
  )
(global-set-key "\C-c\C-t" 'insert-current-time)

;;load monokai theme
(load-theme 'monokai t)

;;load autocompletion
(add-hook 'after-init-hook 'global-company-mode)

;; auto refresh buffers when they change on disk
;; (setq global-auto-revert-mode f)
  
;;add path to mu4e
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")

(global-set-key "\C-x\w" "\C-a\C- \C-n\M-w")

;;Go to next/previous function
(defun goto-closest-imenu-item (direction)
  "Jump to the closest imenu item on the current buffer.
   If direction is 1, jump to next imenu item.
   If direction is -1, jump to previous imenu item.
   See https://emacs.stackexchange.com/questions/30673
   Adapted from `which-function' in https://github.com/typester/emacs/blob/master/lisp/progmodes/which-func.el"
  (interactive)
  (imenu--cleanup)
  (setq imenu--index-alist nil)
  (imenu--make-index-alist)
  (let ((alist imenu--index-alist)
        (minoffset (point-max))
        offset pair mark imstack destination)
    ;; Elements of alist are either ("name" . marker), or
    ;; ("submenu" ("name" . marker) ... ). The list can be
    ;; arbitrarily nested.
    (while (or alist imstack)
      (if alist
          (progn
            (setq pair (car-safe alist)
                  alist (cdr-safe alist))
            (cond ((atom pair))     ; skip anything not a cons
                  ((imenu--subalist-p pair)
                   (setq imstack   (cons alist imstack)
                         alist     (cdr pair)))
                  ((number-or-marker-p (setq mark (cdr pair)))
                   (if (> (setq offset (* (- mark (point)) direction)) 0)
                       (if (< offset minoffset)  ; find the closest item
                           (setq minoffset offset
                                 destination mark))))))
        (setq alist     (car imstack)
              imstack   (cdr imstack))))
    (when destination (imenu-default-goto-function "" destination ""))))

(global-set-key "\M-n" (lambda() (interactive) (goto-closest-imenu-item 1)))
(global-set-key "\M-p" (lambda() (interactive) (goto-closest-imenu-item -1)))

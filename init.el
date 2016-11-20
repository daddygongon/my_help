;; るびきちのemacs lispテクニックバイブルに従ってdefaultの色つけを活性化
;; (require 'generic-x)
;; tabの自動生成がうっとおしいからやめた

;; elファイルの置き場所を設定
(setq load-path (cons "~/.emacs.d/inits" load-path))
(setq load-path (cons "~/.emacs.d/ruby-mode" load-path))
(setq load-path (cons "~/.emacs.d/processing-mode" load-path))
(setq load-path (cons "~/.emacs.d/haml-mode-master" load-path))
;; 起動時にスタートアップ画面を表示しない 
(setq inhibit-startup-message t)
;; 1 行ずつスムーズにスクロールする 
(setq scroll-step 1)
;; 行数を指定してジャンプする (goto-line) 
;;(global-set-key "\C-l" 'goto-line)
;; 言語を日本語に設定
(set-language-environment 'Japanese)
;; 極力UTF-8とする
(prefer-coding-system 'utf-8)

;; エンコード方式をUTF-8に
(set-default-coding-systems 'utf-8)
;; C-zでUndo
;;(global-set-key "\C-z" 'undo)
;; 行番号をデフォルトで表示
;;(require 'line-num)
;;(global-linum-mode 1)
;; 対応する括弧を光らせる
(show-paren-mode 1)
;; 最近使ったファイルの一覧
(recentf-mode 1)
;; タイトルバーに開いているバッファのパスを表示
(setq frame-title-format (format "%%f - Emacs@%s" (system-name)))
;; 現在行を目立たせる
;; (global-hl-line-mode)
;; バックアップファイルを作らない
;; (setq backup-inhibited t)
;; モードラインに時間を表示する
(display-time)
;; 現在の関数名をモードラインに表示
(which-function-mode 1)
;; 選択部分のインデント
(global-set-key "\C-x\C-i" 'indent-region)

(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (setq c-indent-level 8)
  (setq c-brace-imaginary-offset 0)
  (setq c-brace-offset -8)
  (setq c-argdecl-indent 8)
  (setq c-label-offset -8)
  (setq c-continued-statement-offset 8)
  (setq indent-tabs-mode nil)
  (setq tab-width 8)
)

;; ======================================================================
;;  Ruby mode
;; ======================================================================
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))

(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.ru$" . ruby-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.ru$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
            (inf-ruby-keys)))
(global-font-lock-mode 1)

;;;ruby-electric.el --- electric editing commands for ruby files
;;(require 'ruby-electric)
;;(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)

;; ======================================================================
;;  Processing mode
;; ======================================================================
;;(add-to-list 'load-path "/Users/bob/ruby-processing/processing2-emacs")
(autoload 'processing-mode "processing-mode" "Processing mode" t)
(add-to-list 'auto-mode-alist '("\\.pde$" . processing-mode))
(setq processing-indent-level 2)

(setq processing-location "/Users/bob/bin/processing-java")
(setq processing-application-dir "/Applications/Processing.app")
(setq processing-sketch-dir "~/Documents/Processing")

(setq-default indent-tabs-mode nil)
(setq tab-width 2)

;; =======================
;; haml mode
;; =======================
;;``` lisp
(require 'haml-mode)
;;```
(autoload 'haml-mode "haml-mode" "haml mode" t)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))
(setq-default indent-tabs-mode t)
(setq tab-width 2)


;; =========
;; hiki mode
;; =========
(setq load-path (cons "/Users/bob/.emacs.d/hiki-mode" load-path))
(require 'hiki-mode)
;;(autoload 'hiki-edit "hiki-mode" nil t)
(setq-default indent-tabs-mode nil)
(add-to-list 'auto-mode-alist '("\.hiki$" . hiki-mode))



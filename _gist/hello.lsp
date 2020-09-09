;; sbcl --script ./hello.lsp

;; C-x - C-e
;; C-u - C-x - C-e

(format t "Hello, World!")
;; (это список перед которым стоит апостроф)
;; (+ 2 (+ 3 3))

;; fill-column

;; (concat "abc" "def")
;; (substring "Четыре черненьких чумазеньких чертенка." 7 29)

;; (message "Это сообщение появится в эхо-области!")
;; (message "Имя этого буфера: %s." (buffer-name))

;; (set 'цветы '(роза фиалка маргаритка лютик))
;; цветы

;; (setq плотоядные '(лев тигр леопард))

; Назовем это инициализацией.
;; (setq counter 0)
;; (setq counter (+ counter 1))
;; counter

;; (buffer-file-name)
;; (buffer-name)
;; (current-buffer)
;; (other-buffer)
;; (switch-to-buffer (other-buffer))
;; (buffer-size)
;; (point)

;; (decribe-function (other-buffer))
;; describe-function

;; (defun tttest (number)
;;   "Умножить NUMBER на семь."
;;   (* 7 number))

;; (defun tttest (number)
;;   "Умножить NUMBER на семь."
;;   (+ number 1))

;; (tttest 3)

;; (defun tttest (number)       ; Интерактивная версия.
;;   "Умножить NUMBER на семь."
;;   (interactive "p")
;;   (message "Итог %d" (* 7 number)))

;; Tеперь вы можете использовать эту функцию, нажав C-u, затем какое-нибудь число и потом M-x умножить-на-семь,
;; а в конце ВВОД. В эхо-области появится фраза `Итог ...', где на месте ... будет стоять итоговое произведение.
;; beginning-of-buffer

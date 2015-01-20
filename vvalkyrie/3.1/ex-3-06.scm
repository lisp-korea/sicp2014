; ex 3.6

(define (rand msg)
  (let ((val 0))
    (define (reset)
      (lambda (new-value)
        (set! val new-value)
        (randomize val)))
    (cond
      ((eq? msg 'generate)
       (begin
         (set! val (random 32768))
         val))
      ((eq? msg 'reset) (reset)))))


((rand 'reset) 0) ;; (reset)

(rand 'generate)
;;=> 7948

(rand 'generate)
;;=> 441

(rand 'generate)
;;=> 12554

(rand 'generate)
;;=> 13587

(rand 'generate)
;;=> 2220

((rand 'reset) 0) ;; (reset)

(rand 'generate)
;;=> 7948

(rand 'generate)
;;=> 441

(rand 'generate)
;;=> 12554
;; ...

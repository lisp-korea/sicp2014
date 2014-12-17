(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

;; (add-1 zero)
;; =>
;; (add-1 (lambda (f) (lambda (x) x)))
;; =>
;; (lambda (f) (lambda (x) (f (((lambda (f') (lambda (x') x')) f) x))))
;; =>
;; (lambda (f) (lambda (x) (f ((lambda (x') x') x))))
;; =>
;; (lambda (f) (lambda (x) (f x)))
(define one (lambda (f) (lambda (x) (f x))))

;; (add-1 one)
;; =>
;; (add-1 (lambda (f) (lambda (x) (f x))))
;; =>
;; (lambda (f) (lambda (x) (f (((lambda (f') (lambda (x') (f' x'))) f) x))))
;; =>
;; (lambda (f) (lambda (x) (f ((lambda (x') (f x')) x))))
;; =>
;; (lambda (f) (lambda (x) (f (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; in terms of repeated application of add-1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; recursive version
(define (+ n m)
  (if (= m 0)
      n
      (add-1 (+ n (- m 1)))))

;; iterative version
(define (+ n m)
  (define (iter result count)
    (if (= count 0)
	result
	(iter (add-1 result) (- count 0))))
  (iter n m))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; not in terms of repeated application of add-1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (+ two 3)
;; =>
;; (+ (lambda (f) (lambda (x) (f (f x)))) 3)
;; =>
;; ... (???)
;; =>
;; (lambda (f) (lambda (x) (f (f (f (f (f x)))))))
;;
;; (???)
;; <=
;; (lambda (f) (lambda (x) (f (f (f ((lambda (x') (f (f x'))) x))))))
;; <=
;; (lambda (f) (lambda (x) (f (f (f (((lambda (f') (lambda (x') (f' (f' x')))) f) x))))))
;; <=
;; (lambda (f) (lambda (x) (f (f (f (((lambda (f') (lambda (x') (f' (f' x')))) f) x))))))
;; <=
;; (lambda (f) (lambda (x) (f (f (f ((n f) x))))))

(define (+ n m)
  (lambda (f)
    (lambda (x)
      (define (iter result count)
	(if (= count 0)
	    result
	    (iter (f result) (- count 1))))
      (iter ((n f) x) m))))

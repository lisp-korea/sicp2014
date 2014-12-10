;; ex 2.5

(define (^ base n)
  (if (= n 0)
      1
      (* base (^ base (- n 1)))))

(define (i-cons a b)
  (* (^ 2 a) (^ 3 b)))

;; 2^a*3^b / 2 = 2^(a-1)*3^b
;; 2^a*3^b / 2^a = 3^b

(define (get-n x base n)
  (if (= (remainder x (^ base (+ n 1))) 0)
      (get-n x base (+ n 1))
      n))

(define (i-car x)
  (get-n x 2 0))

(define (i-cdr x)
  (get-n x 3 0))

;; test

(define val (i-cons 8 3))

(i-car val)
;;=> 8

(i-cdr val)
;;=> 3

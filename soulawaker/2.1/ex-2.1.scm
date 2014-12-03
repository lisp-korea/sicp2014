연습문제2.1

(define (make-rat n d)
  (let ((g (gcd n d)))
      (cond ((< d 0) (cons (/ (- n) g) (/ (- d) g)))
            (else (cons (/ n g) (/ d g))))))
(make-rat 3 9)
 {1 . 3}
(make-rat -3 -9)
 {1 . 3}
(make-rat -3 9)
 {-1 . 3}
(make-rat 3 -9)
 {-1 . 3}



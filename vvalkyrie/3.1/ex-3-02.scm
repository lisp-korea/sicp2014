; ex 3.2

(define (make-monitored f)
  (let ((count 0))
    (lambda (x)
      (if (eq? x 'how-many-calls?)
        count
        (begin
          (set! count (+ count 1))
          (f x))))))

(define s (make-monitored sqrt))

(s 100)
;;=> 10

(s 'how-many-calls?)
;;=> 1

(s 100)
(s 100)
(s 100)

(s 'how-many-calls?)
;;=> 4


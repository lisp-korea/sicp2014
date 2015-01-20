; ex 3.5

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
            (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

(define (square x) (* x x))

(define (P x y)
  (<= (+ (square (- x 5)) (square (- y 7))) (square 3)))

(define (estimate-integral p x1 y1 x2 y2 trials)
  (define (p-exp)
    (p (random-in-range x1 x2)
       (random-in-range y1 y2)))
  (* (* (- x2 x1) (- y2 y1))
     (monte-carlo trials p-exp)))

;; circle of radius 3 => 3 * 3 * 3.14 = 28.26

(estimate-integral P 2 4 8 10 100)
;;=> 27.72

(estimate-integral P 2 4 8 10 1000000) 
;;=> 26.946

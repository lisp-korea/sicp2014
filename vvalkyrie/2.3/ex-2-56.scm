;; ex 2.56

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list '+ a1 a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (make-exponentiation e1 e2)
  (cond ((or (=number? e1 0) (=number? e2 0)) 1)
        ((=number? e2 1) e1)
        (else (list '^ e1 e2))))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (augend s) (cadr s))

(define (addend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplicand p) (cadr p))

(define (multiplier p) (caddr p))

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '^)))

(define (base e) (cadr e))

(define (exponent e) (caddr e))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        ((exponentiation? exp)
         (make-product
           (make-product (exponent exp)
                         (make-exponentiation (base exp) (- (exponent exp) 1)))
           (deriv (base exp) var)))
        (else
          (error "unknown expression type -- DERIV" exp))))

(deriv '(+ x 3) 'x)
;;=> 1

(deriv '(* x y) 'x)
;;=> y

(deriv '(* (* x y) (+ x 3)) 'x)
;;=> (+ (* (+x 3) y) (* x y))

(deriv '(^ x 5) 'x)
;;=> (* 5 (^ x 4))

(deriv '(^ x 1) 'x)
;;=> (^ x 0)
;;=> 0

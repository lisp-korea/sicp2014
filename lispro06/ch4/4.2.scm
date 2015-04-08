
(define (try a b)
(if (= a 0) 1 b))
(print (try 0 0))


;;Output:
1

;;ex 4.25

(define (factorial n)
(unless (n = 1)
        (* n (factorial (- n 1)))
        1))
(print (factorial 5))


;;Output:
;;procedure application: expected procedure, given: 5; arguments were: #<primitive:=> 1

;; === context ===
;;Line 1:0: factorial

;;In applicative-order Scheme, when call (factorial 5),
;;the call will not end. because, when call unless, even if (= n 1) is true,
;;(factorial (- n 1)) will be called.
;;so n will be 5, 4, 3, 2, 1, 0, -1 .... . In normal-order Scheme,
;;this will work, Because normal-order Scheme uses lazy evaluation,
;;when (= n 1) is true, (factorial n) will not be called. 

;; add this code in eval 
 ((unless? expr) (eval (unless->if expr) env)) 
  
 ;; unless expression is very similar to if expression. 
  
 (define (unless? expr) (tagged-list? expr 'unless)) 
 (define (unless-predicate expr) (cadr expr)) 
 (define (unless-consequnce expr) 
   (if (not (null? (cdddr expr))) 
       (cadddr expr) 
       'false)) 
 (define (unless-alternative expr) (caddr expr)) 
  
 (define (unless->if expr) 
   (make-if (unless-predicate expr) (unless-consequence expr) (unless-alternative expr))) 

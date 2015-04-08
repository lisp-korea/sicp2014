
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


;;ex4.26
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


;;ex4.27
(define w (id (id 10))) 
  
 ;;; L-Eval input: 
 count 
 ;;; L-Eval value: 
 1  
 ;;because when define w, call (id (id 10)), parameter (id 10) is delayed.
 ;;so id only call once. count = 1. 
  
 ;;; L-Eval input: 
 w 
 ;;; L-Eval value: 
 10 
 ;;when enter w in prompt, call (actual-value w), (id 10) is evaluated,
 ;;id is called once more. so now w = 10, count = 2. 
 ;;; L-Eval input: 
 count 
 ;;;; L-Eval value: 
 2 
 
 ;;ex4.28
 (define (g x) (+ x 1)) 
 (define (f g x) (g x)) 
  
 ;;when call (f g 10), if don't use actual-value which will call force-it,
 ;;g will be passed as parameter which will be delayed, then g is a thunk,
 ;;can't be used as function to call 10. 
 
 ;;ex4.29
 ;;with memoization: 
 (square (id 10)) 
 ;;=> 100 
 count 
 ;;=>1 
  
 ;;without memoization: 
 (square (id 10)) 
 ;;=>100 
 count 
 ;;=>2 
 
 
 ;;ex4.30
 ;; a 
 ;;In begin expression, every expression will be evaluated using eval, and display is primitive function, it will call force-it to get x. 
  
 ;; b 
 ;;original eval-sequence: 
 (p1 1) => (1 . 2) 
 (p2 1) => 1  . because (set! x (cons x '(2))) will be delayed, in function p, when evaluating it, it's a thunk. 
  
 ;;Cy's eval-sequence: 
 (p1 1) => (1 . 2) 
 (p2 1) => (1 . 2). thunk (set! x (cons x '(2))) will be forced to evaluate. 
  
 ;; c 
 ;;when using actual-value, it will call (force-it p),
 ;;if p is a normal value, force-it will return p, just as never call actual-value 
  
 ;; d 
 ;;I like Cy's method. 
 
 ;;ex4.31
  (define (apply procedure arguments env) 
     (cond 
         ((primitive-procedure? procedure) 
             (apply-primitive-procedure 
                 procedure 
                 (list-of-arg-values arguments env))) 
         ((compound-procedure? procedure) 
             (eval-compound-procedure procedure arguments env)) 
         (else 
             (error "Unknown procedure type -- APPLY" procedure)))) 
  
 (define (eval-compound-procedure procedure arguments env) 
     (define (iter-args formal-args actual-args) 
         (if (null? formal-args) 
             '() 
             (cons 
                 (let ((this-arg (car formal-args))) 
                     (if (and (pair? this-arg) 
                              (pair? (cdr this-arg)) ; avoid error if arg is  
                                                     ; 1 element list. 
                              (eq? (cadr this-arg) 'lazy)) 
                         (delay-it (car actual-args) env) 
                          ;force the argument if it is not lazy.  
                         (actual-value (car actual-args) env))) 
                 (iter-args (cdr formal-args) (cdr actual-args))))) 
  
     (define (procedure-arg-names parameters) 
         (map (lambda (x) (if (pair? x) (car x) x)) parameters)) 
  
     (eval-sequence 
         (procedure-body procedure) 
         (extend-environment 
             (procedure-arg-names (procedure-parameters procedure)) 
             (iter-args  
                 (procedure-parameters procedure) 
                 arguments) 
             (procedure-environment procedure)))) 
  
 (driver-loop) 
  
 ;; test ;; 
  
 ; 
 ; M-Eval input:  
 ;(define x 1) 
 ; 
 ; M-Eval value:  
 ;ok 
 ; 
 ; M-Eval input:  
 ;(define (p (e lazy)) e x) 
 ; 
 ; M-Eval value:  
 ;ok 
 ; 
 ; M-Eval input:  
 ;(p (set! x (cons x '(2)))) 
 ; 
 ; M-Eval value:  
 ;1 
 ; 
 ; M-Eval input:  
 ;(exit) 
 ; 

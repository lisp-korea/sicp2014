;;4.1.4 driver-loop
(define input-prompt " ; ; ;  M-Eval  input : ") 
(define output-prompt " ; ; ;  M-Eval  value : ") 
(define (driver-1oop)
(prompt-for-input input-prompt)
(let ((input (read)))  
(let ((output (eval input the-global-environment))) 
(announce-output output-prompt)
(user-print output))) 
(driver-1oop))
(define (prompt-for-input string) 
(newline) (newline) (display string) (newline)) 
(define (announce-output string) 
(newline) (display  string) (newline))

(define (make-frame variables values)
  (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))
(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))
(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))
(define the-global-environment (setup-environment))

;;4.2 Scheme 바꿔보기 - 제때 계산법 4.2  Variations on a Scheme -- Lazy Evaluation
;;4.2.1 식의값을 구하는 차례-정의대로계산법과 인자먼저 계산법 4.2.1  Normal Order and Applicative Order

(define (try a b)
(if (= a 0) 1 b))
(print (try 0 0))


;;Output:
1


(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))
  
(unless (= b 0)
        (/ a b)
        (begin (display "exception: returning 0")
               0))

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


;;4.2.2 제때 계산법을 따르는 실행기 4.2.2  An Interpreter with Lazy Evaluation

;;언어 실행기 고치기

((application? exp)
 (apply (actual-value (operator exp) env)
        (operands exp)
        env))

(define (actual-value exp env)
  (force-it (eval exp env)))


(define (apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-arg-values arguments env)))  ; changed
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameters procedure)
           (list-of-delayed-args arguments env) ; changed
           (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))

(define (list-of-arg-values exps env)
  (if (no-operands? exps)
      '()
      (cons (actual-value (first-operand exps) env)
            (list-of-arg-values (rest-operands exps)
                                env))))
(define (list-of-delayed-args exps env)
  (if (no-operands? exps)
      '()
      (cons (delay-it (first-operand exps) env)
            (list-of-delayed-args (rest-operands exps)
                                  env))))

(define (eval-if exp env)
  (if (true? (actual-value (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define input-prompt ";;; L-Eval input:")
(define output-prompt ";;; L-Eval value:")
(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output
           (actual-value input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define the-global-environment (setup-environment))
(driver-loop)
;;; L-Eval input:
(define (try a b)
  (if (= a 0) 1 b))
;;; L-Eval value: ok
;;; L-Eval input:
(try 0 (/ 1 0))
;;; L-Eval value: 1



;;썽크 표현
(define (force-it obj)
  (if (thunk? obj)
      (actual-value (thunk-exp obj) (thunk-env obj))
      obj))



(define (delay-it exp env)
  (list 'thunk exp env))

(define (thunk? obj)
  (tagged-list? obj 'thunk))

(define (thunk-exp thunk) (cadr thunk))

(define (thunk-env thunk) (caddr thunk))

(define (evaluated-thunk? obj)
  (tagged-list? obj 'evaluated-thunk))

(define (thunk-value evaluated-thunk) (cadr evaluated-thunk))
(define (force-it obj)
  (cond ((thunk? obj)
         (let ((result (actual-value
                        (thunk-exp obj)
                        (thunk-env obj))))
           (set-car! obj 'evaluated-thunk)
           (set-car! (cdr obj) result)  ; replace exp with its value
           (set-cdr! (cdr obj) '())     ; forget unneeded env
           result))
        ((evaluated-thunk? obj)
         (thunk-value obj))
        (else obj)))
        
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


;;4.2.3 제때셈 리스트와스트림4.2.3  Streams as Lazy Lists

(define (cons x y)
  (lambda (m) (m x y)))
(define (car z)
  (z (lambda (p q) p)))
(define (cdr z)
  (z (lambda (p q) q)))

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))
(define (map proc items)
  (if (null? items)
      '()
      (cons (proc (car items))
            (map proc (cdr items)))))
(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))
(define (add-lists list1 list2)
  (cond ((null? list1) list2)
        ((null? list2) list1)
        (else (cons (+ (car list1) (car list2))
                    (add-lists (cdr list1) (cdr list2))))))
(define ones (cons 1 ones))
(define integers (cons 1 (add-lists ones integers)))
;;; L-Eval input:
(list-ref integers 17)
;;; L-Eval value: 18

(define (integral integrand initial-value dt)
  (define int
    (cons initial-value
          (add-lists (scale-list integrand dt)
                    int)))
  int)
(define (solve f y0 dt)
  (define y (integral dy y0 dt))
  (define dy (map f y))
  y)
;;; L-Eval input:
(list-ref (solve (lambda (x) x) 1 0.001) 1000)
;;; L-Eval value: 2.716924

;;ex4.32
;;In chapter 3, the car is not lazy.
;;but here car and cdr are all lazy-evaluated.
;;then we can build a lazy tree, all the branches of the tree are lazy-evaluated. 

;;ex4.33
;; '(a b c) is equal to (quote (a b c)). so we should change the code in text-of-quotation like this. 
  
  
 (define prev-eval eval) 
  
 (define (eval expr env) 
     (if (quoted? expr) 
         (text-of-quotation expr env) 
         (prev-eval expr env))) 
  
 (define (quoted? expr) (tagged-list? expr 'quote)) 
  
 (define (text-of-quotation expr env)  
         (let ((text (cadr expr))) 
                 (if (pair? text) 
                         (evaln (make-list text) env) 
                         text))) 
 (define (make-list expr) 
         (if (null? expr) 
                 (list 'quote '()) 
                 (list 'cons 
                           (list 'quote (car expr)) 
                           (make-list (cdr expr))))) 
                           
;;ex 4.34
;; based on 4-33 
  
 (map (lambda (name obj) 
         (define-variable!  name (list 'primitive obj) the-global-environment)) 
     (list 'raw-cons 'raw-car 'raw-cdr) 
     (list cons car cdr)) 
  
 (actual-value 
     '(begin 
  
         (define (cons x y) 
             (raw-cons 'cons (lambda (m) (m x y)))) 
  
         (define (car z) 
             ((raw-cdr z) (lambda (p q) p))) 
  
         (define (cdr z) 
             ((raw-cdr z) (lambda (p q) q))) 
     ) 
     the-global-environment) 
  
 (define (disp-cons obj depth) 
     (letrec ((user-car (lambda (z) 
                 (force-it (lookup-variable-value 'x (procedure-environment (cdr z)))))) 
              (user-cdr (lambda (z) 
                 (force-it (lookup-variable-value 'y (procedure-environment (cdr z))))))) 
         (cond 
             ((>= depth 10) 
                 (display "... )")) 
             ((null? obj) 
                 (display "")) 
             (else 
                 (let ((cdr-value (user-cdr obj))) 
                     (display "(") 
                     (display (user-car obj)) 
                     (if (tagged-list? cdr-value 'cons) 
                         (begin 
                             (display " ") 
                             (disp-cons cdr-value (+ depth 1))) 
                         (begin 
                             (display " . ") 
                             (display cdr-value))) 
                     (display ")")))))) 
  

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))
(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))
  
 (driver-loop)

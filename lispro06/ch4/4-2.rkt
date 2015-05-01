#lang racket
(require (planet neil/sicp:1:13))
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
(define (make-frame2 variables values)
  (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))
(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame2 vars vals) base-env)
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
(define (primitive-procedure-names)
  (map car
       primitive-procedures))
(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        ))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))
(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))
(define the-global-environment (setup-environment))

;;; L-Eval input:
(define (try a b)
  (if (= a 0) 1 b))
;;; L-Eval value: ok
;;; L-Eval input:
;(try 0 (/ 1 0))
;;; L-Eval value: 1

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

(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))
  
 ;; unless expression is very similar to if expression. 
  
 (define (unless? expr) (tagged-list? expr 'unless)) 
 (define (unless-predicate expr) (cadr expr)) 
 (define (unless-consequent expr) 
   (if (not (null? (cdddr expr))) 
       (cadddr expr) 
       'false)) 
 (define (unless-alternative expr) (caddr expr)) 
  
 (define (unless->if expr) 
   (make-if (unless-predicate expr) (unless-consequent expr) (unless-alternative expr))) 

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))
          1))
(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

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
(define (actual-value exp env)
  (force-it (eval exp env)))


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
(define (true? x)
  (not (eq? x false)))
(define (false? x)
  (eq? x false))
(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))



(define (eval-if exp env)
  (if (true? (actual-value (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output
           (actual-value input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

;;(driver-loop)
;;; L-Eval value: ok
;;; L-Eval input:
;;(try 0 (/ 1 0))
;;; L-Eval value: 1
(define count 0)
(define (id x)
(set! count (+ count 1)) x)
(define w (id (id 10))) 

(define (square x) (* x x))
 (square (id 10)) 

(define (for-each1 proc items)
  (if (null? items)
      'done
      (begin (proc (car items))
             (for-each proc (cdr items)))))

(for-each1 (lambda (x) (newline) (display x))
          (list 57 321 88))

(define (p1 x)
  (set! x (cons x '(2)))
  x)

(define (p2 x)
  (define (p e)
    e
    x)
  (p (set! x (cons x '(2)))))

  
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
  (define (eval-sequence exps env)
    (define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (actual-value (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))
     (eval-sequence 
         (procedure-body procedure) 
         (extend-environment 
             (procedure-arg-names (procedure-parameters procedure)) 
             (iter-args  
                 (procedure-parameters procedure) 
                 arguments) 
             (procedure-environment procedure)))) 


(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))
(define (add-lists list1 list2)
  (cond ((null? list1) list2)
        ((null? list2) list1)
        (else (cons (+ (car list1) (car list2))
                    (add-lists (cdr list1) (cdr list2))))))


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

 (define (text-of-quotation expr) 
  
     (define (new-list pair) 
         (if (null? pair) 
             '() 
             (make-procedure 
                 '(m) 
                 (list (list 'm 'car-value 'cdr-value)) 
                 (extend-environment 
                     (list 'car-value 'cdr-value) 
                     (list (car pair) (new-list (cdr pair))) 
                     the-empty-environment)))) 
  
     (let ((text (cadr expr))) 
         (if (not (pair? text)) 
             text 
             (new-list text)))) 

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
    (define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

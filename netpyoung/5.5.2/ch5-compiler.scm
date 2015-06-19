#lang planet neil/sicp
(#%provide (all-defined))
(#%require "ch5-syntax.scm")
;; (#%require "ch5-regsim.scm")


;;;;COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch5.scm

;;;;This file can be loaded into Scheme as a whole.
;;;;**NOTE**This file loads the metacircular evaluator's syntax procedures
;;;;  from section 4.1.2
;;;;  You may need to change the (load ...) expression to work in your
;;;;  version of Scheme.

;;;;Then you can compile Scheme programs as shown in section 5.5.5

;;**implementation-dependent loading of syntax procedures
;; (load "ch5-syntax.scm")			;section 4.1.2 syntax procedures


;;;SECTION 5.5.1

(define (compile exp target linkage)
  (cond ((self-evaluating? exp)
         (compile-self-evaluating exp target linkage))
        ((quoted? exp) (compile-quoted exp target linkage))
        ((variable? exp)
         (compile-variable exp target linkage))
        ((assignment? exp)
         (compile-assignment exp target linkage))
        ((definition? exp)
         (compile-definition exp target linkage))
        ((if? exp) (compile-if exp target linkage))
        ((lambda? exp) (compile-lambda exp target linkage))
        ((begin? exp)
         (compile-sequence (begin-actions exp)
                           target
                           linkage))
        ((cond? exp) (compile (cond->if exp) target linkage))
        ((application? exp)
         (compile-application exp target linkage))
        (else
         (error "Unknown expression type -- COMPILE" exp))))


(define (make-instruction-sequence needs modifies statements)
  (list needs modifies statements))

(define (empty-instruction-sequence)
  (make-instruction-sequence '() '() '()))


;;;SECTION 5.5.2

;;;linkage code

(define (compile-linkage linkage)
  (cond ((eq? linkage 'return)
         (make-instruction-sequence '(continue) '()
          '((goto (reg continue)))))
        ((eq? linkage 'next)
         (empty-instruction-sequence))
        (else
         (make-instruction-sequence '() '()
          `((goto (label ,linkage)))))))


;; > (compile-linkage 'return)
;; {{continue} () {{goto {reg continue}}}}
;; > (compile-linkage 'next)
;; {() () ()}
;; > (compile-linkage 'else)
;; {() () {{goto {label else}}}}
;; > 


(define (end-with-linkage linkage instruction-sequence)
  (preserving '(continue)
   instruction-sequence
   (compile-linkage linkage)))


;;;simple expressions

(define (compile-self-evaluating exp target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '() (list target)
    `((assign ,target (const ,exp))))))
	

;; > (compile-self-evaluating '+ 'target 'return)
;; {{continue} {target} {{assign target {const +}} {goto {reg continue}}}}

(define (compile-quoted exp target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '() (list target)
    `((assign ,target (const ,(text-of-quotation exp)))))))

;; > (compile-quoted '(quoted a) 'target 'return)
;; {{continue} {target} {{assign target {const a}} {goto {reg continue}}}}
	
	
(define (compile-variable exp target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '(env) (list target)
    `((assign ,target
              (op lookup-variable-value)
              (const ,exp)
              (reg env))))))

;; > (compile-variable 'symbol-a 'target 'return)
;; {{env continue}
;;  {target}
;;  {{assign target {op lookup-variable-value} {const symbol-a} {reg env}}
;;   {goto {reg continue}}}}
			  
(define (compile-assignment exp target linkage)
  (let ((var (assignment-variable exp))
        (get-value-code
         (compile (assignment-value exp) 'val 'next)))
    (end-with-linkage linkage
     (preserving '(env)
      get-value-code
      (make-instruction-sequence '(env val) (list target)
       `((perform (op set-variable-value!)
                  (const ,var)
                  (reg val)
                  (reg env))
         (assign ,target (const ok))))))))

;; > (compile-assignment '(set! a 10) 'target 'return)
;; {{env continue}
;;  {val target}
;;  {{assign val {const 10}}
;;   {perform {op set-variable-value!} {const a} {reg val} {reg env}}
;;   {assign target {const ok}}
;;   {goto {reg continue}}}}
		 
(define (compile-definition exp target linkage)
  (let ((var (definition-variable exp))
        (get-value-code
         (compile (definition-value exp) 'val 'next)))
    (end-with-linkage linkage
     (preserving '(env)
      get-value-code
      (make-instruction-sequence '(env val) (list target)
       `((perform (op define-variable!)
                  (const ,var)
                  (reg val)
                  (reg env))
         (assign ,target (const ok))))))))

;; > (compile-definition '(define a 10) 'target 'return)
;; {{env continue}
;;  {val target}
;;  {{assign val {const 10}}
;;   {perform {op define-variable!} {const a} {reg val} {reg env}}
;;   {assign target {const ok}}
;;   {goto {reg continue}}}}
  
;; > (compile-definition '(define (hello a) (+ a 10)) 'target 'return)
;; {{env continue}
;;  {val target}
;;  {{assign val {op make-compiled-procedure} {label entry1} {reg env}}
;;   {goto {label after-lambda2}}
;;   entry1
;;   {assign env {op compiled-procedure-env} {reg proc}}
;;   {assign env {op extend-environment} {const {a}} {reg argl} {reg env}}
;;   {assign proc {op lookup-variable-value} {const +} {reg env}}
;;   {assign val {const 10}}
;;   {assign argl {op list} {reg val}}
;;   {assign val {op lookup-variable-value} {const a} {reg env}}
;;   {assign argl {op cons} {reg val} {reg argl}}
;;   {test {op primitive-procedure?} {reg proc}}
;;   {branch {label primitive-branch3}}
;;   compiled-branch4
;;   {assign val {op compiled-procedure-entry} {reg proc}}
;;   {goto {reg val}}
;;   primitive-branch3
;;   {assign val {op apply-primitive-procedure} {reg proc} {reg argl}}
;;   {goto {reg continue}}
;;   after-call5
;;   after-lambda2
;;   {perform {op define-variable!} {const hello} {reg val} {reg env}}
;;   {assign target {const ok}}
;;   {goto {reg continue}}}}



;;;conditional expressions

;;;labels (from footnote)
(define label-counter 0)

(define (new-label-number)
  (set! label-counter (+ 1 label-counter))
  label-counter)

(define (make-label name)
  (string->symbol
    (string-append (symbol->string name)
                   (number->string (new-label-number)))))
;; end of footnote

(define (compile-if exp target linkage)
  (let ((t-branch (make-label 'true-branch))
        (f-branch (make-label 'false-branch))                    
        (after-if (make-label 'after-if)))
    (let ((consequent-linkage
           (if (eq? linkage 'next) after-if linkage)))
      (let ((p-code (compile (if-predicate exp) 'val 'next))
            (c-code
             (compile
              (if-consequent exp) target consequent-linkage))
            (a-code
             (compile (if-alternative exp) target linkage)))
        (preserving '(env continue)
         p-code
         (append-instruction-sequences
          (make-instruction-sequence '(val) '()
           `((test (op false?) (reg val))
             (branch (label ,f-branch))))
          (parallel-instruction-sequences
           (append-instruction-sequences t-branch c-code)
           (append-instruction-sequences f-branch a-code))
          after-if))))))
		  
		  
;; > (compile-if '(if (test? 10) 'true) 'target 'return)
;; {{env continue}
;;  {proc argl val target}
;;  {{save continue}
;;   {save env}
;;   {assign proc {op lookup-variable-value} {const test?} {reg env}}
;;   {assign val {const 10}}
;;   {assign argl {op list} {reg val}}
;;   {test {op primitive-procedure?} {reg proc}}
;;   {branch {label primitive-branch4}}
;;   compiled-branch5
;;   {assign continue {label after-call6}}
;;   {assign val {op compiled-procedure-entry} {reg proc}}
;;   {goto {reg val}}
;;   primitive-branch4
;;   {assign val {op apply-primitive-procedure} {reg proc} {reg argl}}
;;   after-call6
;;   {restore env}
;;   {restore continue}
;;   {test {op false?} {reg val}}
;;   {branch {label false-branch2}}
;;   true-branch1
;;   {assign target {const true}}
;;   {goto {reg continue}}
;;   false-branch2
;;   {assign target {op lookup-variable-value} {const false} {reg env}}
;;   {goto {reg continue}}
;;   after-if3}}


;; > (compile-if '(if (test? 10) 'true 'false) 'target 'return)
;; {{env continue}
;;  {env proc argl val target}
;;  {{save continue}
;;   {assign proc {op lookup-variable-value} {const test?} {reg env}}
;;   {assign val {const 10}}
;;   {assign argl {op list} {reg val}}
;;   {test {op primitive-procedure?} {reg proc}}
;;   {branch {label primitive-branch10}}
;;   compiled-branch11
;;   {assign continue {label after-call12}}
;;   {assign val {op compiled-procedure-entry} {reg proc}}
;;   {goto {reg val}}
;;   primitive-branch10
;;   {assign val {op apply-primitive-procedure} {reg proc} {reg argl}}
;;   after-call12
;;   {restore continue}
;;   {test {op false?} {reg val}}
;;   {branch {label false-branch8}}
;;   true-branch7
;;   {assign target {const true}}
;;   {goto {reg continue}}
;;   false-branch8
;;   {assign target {const false}}
;;   {goto {reg continue}}
;;   after-if9}}
;; 
;;; sequences

(define (compile-sequence seq target linkage)
  (if (last-exp? seq)
      (compile (first-exp seq) target linkage)
      (preserving '(env continue)
       (compile (first-exp seq) target 'next)
       (compile-sequence (rest-exps seq) target linkage))))

;; > (compile-sequence '(begin '(println 1 1) '(+ 2 2)) 'target 'return)
;; {{env continue}
;;  {target}
;;  {{assign target {op lookup-variable-value} {const begin} {reg env}}
;;   {assign target {const {println 1 1}}}
;;   {assign target {const {+ 2 2}}}
;;   {goto {reg continue}}}}

;;;lambda expressions

(define (compile-lambda exp target linkage)
  (let ((proc-entry (make-label 'entry))
        (after-lambda (make-label 'after-lambda)))
    (let ((lambda-linkage
           (if (eq? linkage 'next) after-lambda linkage)))
      (append-instruction-sequences
       (tack-on-instruction-sequence
        (end-with-linkage lambda-linkage
         (make-instruction-sequence '(env) (list target)
          `((assign ,target
                    (op make-compiled-procedure)
                    (label ,proc-entry)
                    (reg env)))))
        (compile-lambda-body exp proc-entry))
       after-lambda))))

(define (compile-lambda-body exp proc-entry)
  (let ((formals (lambda-parameters exp)))
    (append-instruction-sequences
     (make-instruction-sequence '(env proc argl) '(env)
      `(,proc-entry
        (assign env (op compiled-procedure-env) (reg proc))
        (assign env
                (op extend-environment)
                (const ,formals)
                (reg argl)
                (reg env))))
     (compile-sequence (lambda-body exp) 'val 'return))))


;; > (compile-lambda '(lambda (x) (+ x 10)) 'target 'return)
;; {{env continue}
;;  {target}
;;  {{assign target {op make-compiled-procedure} {label entry7} {reg env}}
;;   {goto {reg continue}}
;;   entry7
;;   {assign env {op compiled-procedure-env} {reg proc}}
;;   {assign env {op extend-environment} {const {x}} {reg argl} {reg env}}
;;   {assign proc {op lookup-variable-value} {const +} {reg env}}
;;   {assign val {const 10}}
;;   {assign argl {op list} {reg val}}
;;   {assign val {op lookup-variable-value} {const x} {reg env}}
;;   {assign argl {op cons} {reg val} {reg argl}}
;;   {test {op primitive-procedure?} {reg proc}}
;;   {branch {label primitive-branch9}}
;;   compiled-branch10
;;   {assign val {op compiled-procedure-entry} {reg proc}}
;;   {goto {reg val}}
;;   primitive-branch9
;;   {assign val {op apply-primitive-procedure} {reg proc} {reg argl}}
;;   {goto {reg continue}}
;;   after-call11
;;   after-lambda8}}

;;;SECTION 5.5.3

;;;combinations

(define (compile-application exp target linkage)
  (let ((proc-code (compile (operator exp) 'proc 'next))
        (operand-codes
         (map (lambda (operand) (compile operand 'val 'next))
              (operands exp))))
    (preserving '(env continue)
     proc-code
     (preserving '(proc continue)
      (construct-arglist operand-codes)
      (compile-procedure-call target linkage)))))

(define (construct-arglist operand-codes)
  (let ((operand-codes (reverse operand-codes)))
    (if (null? operand-codes)
        (make-instruction-sequence '() '(argl)
         '((assign argl (const ()))))
        (let ((code-to-get-last-arg
               (append-instruction-sequences
                (car operand-codes)
                (make-instruction-sequence '(val) '(argl)
                 '((assign argl (op list) (reg val)))))))
          (if (null? (cdr operand-codes))
              code-to-get-last-arg
              (preserving '(env)
               code-to-get-last-arg
               (code-to-get-rest-args
                (cdr operand-codes))))))))

(define (code-to-get-rest-args operand-codes)
  (let ((code-for-next-arg
         (preserving '(argl)
          (car operand-codes)
          (make-instruction-sequence '(val argl) '(argl)
           '((assign argl
              (op cons) (reg val) (reg argl)))))))
    (if (null? (cdr operand-codes))
        code-for-next-arg
        (preserving '(env)
         code-for-next-arg
         (code-to-get-rest-args (cdr operand-codes))))))

;;;applying procedures

(define (compile-procedure-call target linkage)
  (let ((primitive-branch (make-label 'primitive-branch))
        (compiled-branch (make-label 'compiled-branch))
        (after-call (make-label 'after-call)))
    (let ((compiled-linkage
           (if (eq? linkage 'next) after-call linkage)))
      (append-instruction-sequences
       (make-instruction-sequence '(proc) '()
        `((test (op primitive-procedure?) (reg proc))
          (branch (label ,primitive-branch))))
       (parallel-instruction-sequences
        (append-instruction-sequences
         compiled-branch
         (compile-proc-appl target compiled-linkage))
        (append-instruction-sequences
         primitive-branch
         (end-with-linkage linkage
          (make-instruction-sequence '(proc argl)
                                     (list target)
           `((assign ,target
                     (op apply-primitive-procedure)
                     (reg proc)
                     (reg argl)))))))
       after-call))))

;;;applying compiled procedures

(define (compile-proc-appl target linkage)
  (cond ((and (eq? target 'val) (not (eq? linkage 'return)))
         (make-instruction-sequence '(proc) all-regs
           `((assign continue (label ,linkage))
             (assign val (op compiled-procedure-entry)
                         (reg proc))
             (goto (reg val)))))
        ((and (not (eq? target 'val))
              (not (eq? linkage 'return)))
         (let ((proc-return (make-label 'proc-return)))
           (make-instruction-sequence '(proc) all-regs
            `((assign continue (label ,proc-return))
              (assign val (op compiled-procedure-entry)
                          (reg proc))
              (goto (reg val))
              ,proc-return
              (assign ,target (reg val))
              (goto (label ,linkage))))))
        ((and (eq? target 'val) (eq? linkage 'return))
         (make-instruction-sequence '(proc continue) all-regs
          '((assign val (op compiled-procedure-entry)
                        (reg proc))
            (goto (reg val)))))
        ((and (not (eq? target 'val)) (eq? linkage 'return))
         (error "return linkage, target not val -- COMPILE"
                target))))

;; footnote
(define all-regs '(env proc val argl continue))


;;;SECTION 5.5.4

(define (registers-needed s)
  (if (symbol? s) '() (car s)))

(define (registers-modified s)
  (if (symbol? s) '() (cadr s)))

(define (statements s)
  (if (symbol? s) (list s) (caddr s)))

(define (needs-register? seq reg)
  (memq reg (registers-needed seq)))

(define (modifies-register? seq reg)
  (memq reg (registers-modified seq)))


(define (append-instruction-sequences . seqs)
  (define (append-2-sequences seq1 seq2)
    (make-instruction-sequence
     (list-union (registers-needed seq1)
                 (list-difference (registers-needed seq2)
                                  (registers-modified seq1)))
     (list-union (registers-modified seq1)
                 (registers-modified seq2))
     (append (statements seq1) (statements seq2))))
  (define (append-seq-list seqs)
    (if (null? seqs)
        (empty-instruction-sequence)
        (append-2-sequences (car seqs)
                            (append-seq-list (cdr seqs)))))
  (append-seq-list seqs))

(define (list-union s1 s2)
  (cond ((null? s1) s2)
        ((memq (car s1) s2) (list-union (cdr s1) s2))
        (else (cons (car s1) (list-union (cdr s1) s2)))))

(define (list-difference s1 s2)
  (cond ((null? s1) '())
        ((memq (car s1) s2) (list-difference (cdr s1) s2))
        (else (cons (car s1)
                    (list-difference (cdr s1) s2)))))

(define (preserving regs seq1 seq2)
  (if (null? regs)
      (append-instruction-sequences seq1 seq2)
      (let ((first-reg (car regs)))
        (if (and (needs-register? seq2 first-reg)
                 (modifies-register? seq1 first-reg))
            (preserving (cdr regs)
             (make-instruction-sequence
              (list-union (list first-reg)
                          (registers-needed seq1))
              (list-difference (registers-modified seq1)
                               (list first-reg))
              (append `((save ,first-reg))
                      (statements seq1)
                      `((restore ,first-reg))))
             seq2)
            (preserving (cdr regs) seq1 seq2)))))

(define (tack-on-instruction-sequence seq body-seq)
  (make-instruction-sequence
   (registers-needed seq)
   (registers-modified seq)
   (append (statements seq) (statements body-seq))))

(define (parallel-instruction-sequences seq1 seq2)
  (make-instruction-sequence
   (list-union (registers-needed seq1)
               (registers-needed seq2))
   (list-union (registers-modified seq1)
               (registers-modified seq2))
   (append (statements seq1) (statements seq2))))

'(COMPILER LOADED)

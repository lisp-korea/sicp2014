메타서큘러 실행기



## 4.1 meta-circular evaluator

* Lisp로 Lisp 언어 실행기를 만들어 보자.
* 언어 실행기가 처리하려는 언어로 다시 그 실행기를 만들때, 그런 실행기를 meracircular실행기라고 한다.


* 규칙
1. 식의 값을 구하려면, 부분식의 값으로부터 모두 구해야 한다. 그런 다음에, 연산자를 피연산자에 적용한다.
2. 프로시저를 인자에 적용하려면, 프로시저의 식을 계산하기 위하여 새 환경으로부터 만든다. 새 환경은, 인자 이름에 해당하는 인자 값을 찾아 쓸 수 있도록 새로운 일람표를 만들어서, 이미 있던 환경에다 덧댄 것이다.






### 4.1.1 언어 실행기의 알짜배기 - 473
* 식의 값을 구하는 프로세스는 eval과 apply라는 두 프로시저가 맞물려 돌아 가는 것이라 볼 수 있다.
* eval
  - 식과 환경을 안자로 받은 다음, 식의 종류에 따라 알맞은 계산 방법을 고른다.
* primitive expression
  - number와 같이 곧바로 값을 표현하는 식을 만나면, 식 자체를 돌려준다.
  - 변수가 오면, 환경을 뒤져 변수 값을 찾는다.
* special form
  - 표현식에 따옴표가 되어있으면, 따옴표를 없앤 식을 돌려준다.
  - 변수 값을 덮어쓰거나 정의하는 식이 오면, 새 변수 값을 계산하기 위해 다시 eval을 호출한다. 환경을 고쳐 새로운 변수 정의를 추가하거나, 변수 값을 바꾼다.
  - if 식은 숙어가 참이면, consequent expression을 계산하고, 그렇지 않으면 alternative expression을 계산해야 하므로, 보통 식과 값을 구하는 방법이 다르다. 따라서 if 식을 따로 처리하는 과정이 필요하다.
  - lambda식을 만나면, lambda 식 속의 인자, 몸, 그 몸을 정의할 때 참고한 환경을 묶어서 프로시저로 바꿔야 한다.
  - begin을 만나면, begin속에 있는 식을 적어놓은 차례대로 계산한다.
  - cond가 나오면, 이것을 if문이 중첩된 형태로 바꾸고 계산한다.
* combination
  - eval을 여러번 하면서, 연산자 부분과 피연산자 부분 값을 모두 구하고, apply인자로 넘긴다. 실제 프로시저에 인자를 주고 계산하는 일은 apply가 맡아서 한다.


```lisp
(define (eval exp env)
  (condp #(%1 %2) exp
	self-evaluating? exp
	variable?        (lookup-variable-value exp env)

  ;; tagged list
	quoted?          (text-of-quotation     exp)
	assignment?      (eval-assignment       exp env)

	definition?      (eval-definition       exp env)
	if?              (eval-if               exp env)


	lambda?          (make-procedure
                       (lambda-parameters exp)
                       (lambda-body exp)
                       env)


	begin?           (eval-sequence (begin-actions exp) env)
	cond?            (eval          (cond->if exp)      env)


	application?     (apply
                       (eval (operator exp) env)
                       (list-of-values (operands exp) env))

	(error "Unknown expression type -- EVAL" exp)))
;; 프로시저에서 다룰 수 있는 갯수가 고정되어 버리므로, data-directed technique를 쓰면 eval에 대한 정의를 손대지 않고도, 새로운 식을 처리할 수 있도록 만들 수 있다.
```



* apply

```lisp
(define (apply procedure arguments)
  (condp #(%1 %2) procedure

    primitive-procedure?
	(apply-primitive-procedure procedure arguments)

	compound-procedure?
	(eval-sequence
		(procedure-body procedure)
		(extend-environment
			(procedure-parameters procedure)
			arguments
			(procedure-environment procedure)))


	(error "Unknown procedure type -- APPLY" procedure)))
```


* procedure argument

```lisp
(define (list-of-values exps env)
	(if (no-operands? exps)
		'()
		(cons (eval (first-operand exps) env)
				(list-of-values (rest-operands exps) env))))
;; 값을 계산하여 리스트로 반환
```





```lisp
(define (eval-if exp env)
	(if (true? (eval (if-predicate exp) env))
		(eval (if-consequent exp) env)
		(eval (if-alternative exp) env)))
;; true?의 필요성에 대해 생각
```


```lisp
(define (eval-sequence exps env)
	(cond ((last-exp? exp)
			(eval (first-exp exps) env))
		  (else
			(eval (first-exp exps) env)
				  (eval-sequence (rest-exps exps) env))))
;; 연달아 연산할때, 혹은 begin이 나올때
```

* 환경 덮어쓰기(변수 값)

```lisp
(define (eval-assignment exp env)
	(set-variable-value! (assignment-variable exp)
						 (eval (assignment-value exp) env)
						 env)
	'ok)
```

* 환경 덮어쓰기(변수 정의)

```lisp
(define (eval-definition exp env)
	(define-variable! (definition-variable exp)
					  (eval (definition-value exp) env)
					  env)
	'ok)
```


#### 연습문제 4.1

```lisp
(define (list-of-values exps env)
	(if (no-operands? exps)
		'()
		(let [l (eval (first-operand exps) env)
			  r (list-of-values (rest-operands exps) env)
		(cons l r))))
```



```lisp
(define (list-of-values exps env)
	(if (no-operands? exps)
		'()
		(let [r (list-of-values (rest-operands exps) env)
			  l (eval (first-operand exps) env)
		(cons l r))))
```



### 4.1.2 식을 나타내는 방법 - 481
```lisp
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true))
        (else false))

(define (variable? exp)
  (symbol? exp))


;; (quote <text-of-quotation>)
(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (tagged-list? exp tag)
  (if (pair? exp)
    (eq (car exp) tag)
    false))



;; (set! <var> <value>)
(define (assignment? exp)
  (tagged-list exp 'set!))

(define (assignment-variable exp)
  (cadr exp))

(define (assignment-value exp)
  (caddr exp))




;; (define <var> <value>)
;; (define (<var> <p1>...<pn>)
;;   <body>)
;; (define <var>
;;   (lambda (<p1>...<pn>)
;;     <body>))

(define (difinition? exp)
  (tagged-list? exp 'define))
(define (difinition-variable exp)
  (if (symbol? (second exp))
    (second exp)
      (first (second exp))))
(define (difinition-value exp)
  (if (symbol? (second exp)
    (third exp)
    (make-lambda (rest (second exp)
                 (third exp))))))


;; lambda
(define (lambda? exp)
  (tagged-list? exp 'lambda))
(define (lambda-parameters exp)
  (second exp))
(define (lambda-body exp)
  (third exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))


;; (if <predicate>
;;   <consequent>
;;   <alternative>)
(define (if? exp)
  (tagged-list? exp 'if))
(define (if-predicate exp)
  (second exp))
(define (if-consequent exp)
  (third exp))
(define (if-alternative exp)
  (if (null? (fourth exp)
    'false
    (fourth exp))))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))


;; (begin <bla1>...<blan>)
(define (begin? exp)
  (tagged-list? exp 'begin))
(define (begin-actions exp)
  (rest exp))
(define (last-exp? seq)
  (null? rest seq))
(define first-exp seq)
  (first seq))
(define (rest-exps seq)
  (rest seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else
          (make-begin seq))))
(define (make-begin seq)
  (cons 'begin seq))

;; procedure
(define (application? exp)
  (pair? exp))
(define (operator exp)
  (first exp))
(define (operands exp)
  (rest exp))
(define (no-operands? ops)
  (null? ops))
(define (first-operand ops)
  (first ops))
(define (rest-operands ops)
  (rest ops))



;; cond => if
(define (cond? exp)
  (tagged-list? exp 'cond))
(define (cond-cluses exp)
  (rest exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause)
  (first clause))
(define (cond-actions clause)
  (rest clause))
(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))


(define (expand-clauses clauses)
  (if (null? clauses)
    'false
    (let [[fst & rst] clauses]
      (if (cond-else-clause? fst)
        (if (null? rst)
          (sequence->exp (cond-actions fst))
          (error "ELSE clause isn't last -- COND->IF" clauses))
        (make-if (cond-predicate fst)
                 (sequence->exp (cond-actions fst))
                 (expand-clauses rest))))))
```

### 연습문제 4.2

```lisp
;; a.
(eval ‘(define x 3) env)
;; (application? ‘(define x 3))

-> (apply (eval ‘define env)
          (list-of-values (‘x 3) env)))

(eval ‘define env)
;; (variable? ‘define)
-> (lookup-variable-value exp env)

(error “Unbound variable” ‘define)


;; b.
(define (application? exp)
  (tagged-list? exp 'call))
(define (operator exp) (cadr exp))
(define (operands exp) (cddr exp))
```



### 연습문제 4.3
```lisp
tagged-list?를 쓰는 것들을 빼서

((syntax-table-has-tag? (get-tag exp))
 ((get-fn-from-syntax-table (get-tag exp)) exp env))

syntax-table = {
  'quote  =>
  'set!   =>
  'define =>
  'lambda =>
  'begin  =>
  'if     =>
  'cond   =>
}
```


### 연습문제 4.4
```lisp
(define (self-evaluating? exp)
  (or (number? exp)
      (string? exp)
      (boolean? exp)))

syntax-table = {
  'or =>
  'and =>
}
```

### 연습문제 4.5
### 연습문제 4.6
### 연습문제 4.7
### 연습문제 4.8
### 연습문제 4.9
### 연습문제 4.10

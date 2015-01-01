;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ch 2 데이터를 요약해서 표현력을 끌어올리는 방법
;;; Ch 2.5. 일반화된 연산 시스템
;;; p 244

;;; 한 데이터의 표현이 서로 다를 때,
;;; 인자마다 종류가 다은 경우
;;; 모두 가능한 연산 정의 방법.


;;;;=================<ch 2.5.1 일반화된 산술 연산>=====================
;;; p245

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

;;; p246
;;; ordinary(보통 수)

(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))

  ;; ex 2.79
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y)
	 (= x y)))

  ;; ex 2.80
  (put 'zero? '(scheme-number)
       (lambda (x)
	 (= x 0)))

  ;; ex 2.81-a 
  (put 'exp '(scheme-number scheme-number)
       (lambda (x y) (tag (expt x y))))

  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

;;; p247
;;; rational

(define (install-rational-package)
  ;; 갇힌 프로시저
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
		 (* (numer y) (denom x)))
	      (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
		 (* (numer y) (denom x)))
	      (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
	      (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
	      (* (denom x) (numer y))))

  ;; 인터페이스
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))

  ;; ex 2.79
  (define (equ? r1 r2)
    (and (= (numer r1) (numer r2))
	 (= (denom r1) (denom r2))))
  (put 'equ? '(rational rational)
       (lambda (r1 r2)
	 (equ? r1 r2)))

  ;; ex 2.80
  (put 'zero? '(rational)
       (lambda (x)
	 (= (numer x) 0)))

  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))

;;; p248
;;; complex
;; 뒤에서 보완
;; (define (install-complex-package)
;;   ;; 직각 좌표, 극좌표 꾸러미
;;   (define (make-from-real-imag x y)
;;     ((get 'make-from-real-imag 'rectangular) x y))
;;   (define (make-from-mag-ang r a)
;;     ((get 'make-from-mag-ang 'polar) r a))

;;   ;; 갇힌 프로시저
;;   (define (add-complex z1 z2)
;;     (make-from-real-imag (+ (real-part z1) (real-part z2))
;; 			 (+ (imag-part z1) (imag-part z2))))
;;   (define (sub-complex z1 z2)
;;     (make-from-real-imag (- (real-part z1) (real-part z2))
;; 			 (- (imag-part z1) (imag-part z2))))
;;   (define (mul-complex z1 z2)
;;     (make-from-mag-ang (* (magnitude z1) (magnitude z2))
;; 		       (+ (angle z1) (angle z2))))
;;   (define (div-complex z1 z2)
;;     (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
;; 		       (- (angle z1) (angle z2))))

;;   ;; 인터페이스
;;   (define (tag z) (attach-tag 'complex z))
;;   (put 'add '(complex complex)
;;        (lambda (z1 z2) (tag (add-complex z1 z2))))
;;   (put 'sub '(complex complex)
;;        (lambda (z1 z2) (tag (sub-complex z1 z2))))
;;   (put 'mul '(complex complex)
;;        (lambda (z1 z2) (tag (mul-complex z1 z2))))
;;   (put 'div '(complex complex)
;;        (lambda (z1 z2) (tag (div-complex z1 z2))))
;;   (put 'make-from-real-imag 'complex
;;        (lambda (x y) (tag (make-from-real-imag x y))))
;;   (put 'make-from-mag-ang 'complex
;;        (lambda (r a) (tag (make-from-mag-ang r a))))

;;   ;; ex 2.79
;;   (put 'equ? '(complex complex)
;;        (lambda (z1 z2) 
;; 	 (apply-generic 'equ? z1 z2)))

;;   ;; ex 2.80
;;   (put 'zero? '(complex)
;;        (lambda (x)
;; 	 (apply-generic 'zero? x)))

;;   'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))

(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))


;;;--------------------------< ex 2.77 >--------------------------
;;; 250

;;; 아래를 포함해야함
;;----------------------------------------------------------
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 나의 put,get 구현
(define GOP (make-hash))

(define (put op types behavior)
  (hash-set! GOP (cons op types) behavior))
;;  (hash-set! GOP (list op types) behavior))
;;  (hash-set! GOP (cons 'key (cons op types)) behavior))

(define (get op types)
  (hash-ref GOP (cons op types)))
;;  (hash-ref GOP (list op types)))
;;  (hash-ref GOP (cons 'key (cons op types))))

(install-scheme-number-package)
(install-rational-package)
(install-complex-package)

;;------------
;; p229
(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum -- CONTENTS" datum)))
;;------------

;;--------------------------------
;; 여기서 타입 태그를 떼어낸다.
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
	  (apply proc (map contents args))
	  (error
	   "No method for these types -- APPLY-GENERTIC"
	   (list op type-tags))))))

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))
;;--------------------------------

;;
(define (make-from-real-imag x y)
  ((get 'make-from-real-imag 'rectangular) x y))

(define (make-from-mag-ang r a)
  ((get 'make-from-mag-ang 'polar) r a))


;; ;;--------------------------------
;; (define sn1 ((get 'make 'scheme-number) 1))
;; (define sn2 ((get 'make 'scheme-number) 2))

;; ((get 'add '(scheme-number scheme-number)
;;       sn1 sn2))
;; ;;--------------------------------

(define (install-rectangular-package)
  ;; 갇힌 프로시저
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) (cons x y))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (magnitude z)
    (sqrt (+ (square (real-part z)) (square (imag-part z)))))
  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))

  ;; 이 꾸러미의 인터페이스
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))

  ;; ex 2.79
  (define (equ? z1 z2)
    (and (= (real-part z1) (real-part z2))
	 (= (imag-part z1) (imag-part z2))))
  (put 'equ? '(rectangular rectangular)
       (lambda (z1 z2) 
	 (equ? z1 z2)))

  ;; ex 2.80
  (put 'zero? '(rectangular)
       (lambda (x)
       	 (and (= (real-part x) 0)
       	      (= (imag-part x) 0))))
;;       (lambda (x) (print "rectangular!")))

  'done)


;;; 극좌표 방식
(define (install-polar-package)
  ;; 갇힌 프로시저
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a)
    (cons r a))

  (define (real-part z)
    (* (magnitude z) (cons (angle z))))
  (define (mag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))
	  (atan y x)))

  ;; 이 꾸러미의 인터페이스
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))


  ;; ex 2.79
  (define (equ? z1 z2)
    (and (= (magnitude z1) (magnitude z2))
	 (= (angle z1) (angle z2))))
  (put 'equ? '(polar polar)
       (lambda (z1 z2) 
	 (equ? z1 z2)))

  ;; ex 2.80
  (put 'zero? '(polar)
       (lambda (x)
	 (= (magnitude x) 0)))

  'done)

;;
;;----------------------------------------------------------

(define (install-complex-package)
  ;; 직각 좌표, 극좌표 꾸러미
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))

  ;; 갇힌 프로시저
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
			 (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
			 (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
		       (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
		       (- (angle z1) (angle z2))))

  ;; 인터페이스
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; 추가
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; ex 2.79
  (put 'equ? '(complex complex)
       (lambda (z1 z2) 
	 (apply-generic 'equ? z1 z2)))

  ;; ex 2.80
  (put 'zero? '(complex)
       (lambda (x)
	 (apply-generic 'zero? x)))

  'done)



;;;
(install-polar-package)
(install-rectangular-package)
(install-complex-package)

;;;---
(define (square x) (* x x))
;;;---

(define z '(complex rectangular 3 . 4))
(define z (make-complex-from-real-imag 3 4))
(magnitude z)
;; 1)
;; => (apply-generic 'magnitude '(complex rectangular 3 . 4))
;;     ->
;;      (type-tag z) -> 'complex 
;; 
;;      (get 'magnitude '(complex)) -> procedure:magnitude <-| proc
;;      (contents z) -> '(rectangular 3 . 4)
;;      (apply proc '((rectangular 3 . 4)))
;;
;; => (apply (get 'magnitude '(complex)) '((rectangular 3 . 4)))
;;           ^^^^^^^^^^^^^^^^^^^^^^^^^^^
;;           -> (top:magnitude)
;;    --> (apply top:magnitude '((rectangular 3 . 4)))
;; => (apply magnitude '((rectangular 3 . 4)))

;; 2)
;; => (apply-generic 'magnitude '(rectangular 3 . 4))
;;     ->
;;      (type-tag z') -> 'rectangular
;;
;;      (get 'magnitude '(rectangular)) -> procedure:magnitude <-| proc
;;      (contents z') -> '(3 . 4)
;;      (apply proc '((3 . 4)))
;; => (apply (get 'magnitude '(rectangular)) '((3 . 4)))
;;           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;;           -> (rectangular-package:magnitude)             ;; p236
;;    --> (apply rectangular-package:magnitude '((3 . 4)))
;;    --> (rectangular-package:magnitude '(3 . 4))
;;
;; 
;; apply-generic은 두 번 호출된다.

(real-part z) ; 3
(imag-part z) ; 4
(angle z)     ; 0.9272952180016122


;;;;;;;;;;;;

(make-complex-from-real-imag 1 1) ; '(complex rectangular 1 . 1)
(make-complex-from-mag-ang 1 1)   ; '(complex polar 1 . 1)




;;; 추가 확인

(add (make-scheme-number 1) (make-scheme-number 2))

(add (make-rational 1 2) (make-rational 2 3))

(add (make-complex-from-real-imag 1 2) (make-complex-from-real-imag 2 3))

;;(add (make-complex-from-mag-ang 1 2) (make-complex-from-mag-ang 2 3))
;; <- 구현 안되어 있음

(div (make-complex-from-mag-ang 1 2) (make-complex-from-mag-ang 2 3))

;;;--------------------------< ex 2.78 >--------------------------
;;; 250
(add (make-scheme-number 1) (make-scheme-number 2)) ; '(scheme-number . 3)
(sub (make-scheme-number 1) (make-scheme-number 2)) ; '(scheme-number . -1)
(mul (make-scheme-number 1) (make-scheme-number 2)) ; '(scheme-number . 2)
(div (make-scheme-number 1) (make-scheme-number 2)) ; '(scheme-number . 1/2)

;;->
;;------------
(define (attach-tag type-tag contents)
  (if (number? contents) 
      contents
      (cons type-tag contents)))

(define (type-tag datum)
  (if (number? datum)
      'scheme-number
      (if (pair? datum)
	  (car datum)
	  (error "Bad tagged datum -- TYPE-TAG" datum))))

(define (contents datum)
  (if (number? datum)
      datum
      (if (pair? datum)
	  (cdr datum)
	  (error "Bad tagged datum -- CONTENTS" datum))))
;;------------

(add 1 2) ; 3
(sub 1 2) ; -1
(mul 1 2) ; 2
(div 1 2) ; 1/2


;;;--------------------------< ex 2.79 >--------------------------
;;; 251

;;; 각 패키지 속에 
;;; equ? 함수와
;;; (put 'equ? '(타입 타입) ...) 추가함
;;; ex 2.79 로 검색

;; (define (install-general-package)
;;   ;; 인터페이스
;;   (put 'equ? '(scheme-number scheme-number)
;;        (lambda (x y) (print "scheme-number")))
;;   (put 'equ? '(rational rational) 
;;        (lambda (x y) (print "rational")))
;;   (put 'equ? '(complex complex)
;;        (lambda (x y) (print "complex")))
  
;;   'done)
;; (install-general-package)

(define (equ? x y) (apply-generic 'equ? x y))


;;;-- [[test
(install-scheme-number-package)
(install-rational-package)
(install-rectangular-package)
(install-polar-package)
(install-complex-package)
;;; 위 패키지 모두 다시 평가 후 연산 등록. 

(equ? (make-scheme-number 1) (make-scheme-number 2))

(equ? (make-scheme-number 1) (make-scheme-number 1))

(equ? 1 2)

(equ? 1 1)

(equ? (make-rational 1 2) (make-rational 2 3))

(equ? (make-rational 1 2) (make-rational 1 2))

(equ? (make-complex-from-real-imag 1 2) (make-complex-from-real-imag 2 3))

(equ? (make-complex-from-real-imag 1 2) (make-complex-from-real-imag 1 2))

(equ? (make-complex-from-mag-ang 1 2) (make-complex-from-mag-ang 2 3))

(equ? (make-complex-from-mag-ang 1 2) (make-complex-from-mag-ang 1 2))

;;;--]]


;;;--------------------------< ex 2.80 >--------------------------
;;; 251

;;; 각 패키지 속에 
;;; zero? 함수와
;;; (put 'zero? ('타입) ...) 추가함
;;; ex 2.80 로 검색

(define (zero? x) (apply-generic 'zero? x))

;;;-- [[test
(install-scheme-number-package)
(install-rational-package)
(install-rectangular-package)
(install-polar-package)
(install-complex-package)
;;; 위 패키지 모두 다시 평가 후 연산 등록. 

(zero? (make-scheme-number 1))

(zero? (make-scheme-number 0))

(zero? 1)

(zero? 0)

(zero? (make-rational 2 3))

(zero? (make-rational 0 2))

(zero? (make-complex-from-real-imag 2 3))

(zero? (make-complex-from-real-imag 0 0))

(zero? (make-complex-from-mag-ang 1 2))

(zero? (make-complex-from-mag-ang 0 0))

;;;--]]



;;;;================<ch 2.5.2 타입이 다른 데이터를 엮어 쓰는 방법 >=====================
;;; p251

;;; 섞붙이기(cross-type) 연산을 이용해서 타입이 다른 데이터를 엮어 쓸 수 있다.
;;; 방법 1)
;;;   - 서로 다른 타입 사이에서 일어날 수 있는 연산마다
;;;     그에 해당하는 프로시저를 하나씩 설계
;;    -> 문제점 :
;;          (1) 수많은 섞붙이기 연산 구현
;;          (2) 엮어 쓰는 데 방해.
;;  방법 2)
;;    - 타입 바꾸기


;; ;;; 방법 1의 구현
;; (define (add-complex-to-schemenum z x)
;;   (make-from-real-imag (+ (real-part z) x)
;; 		       (imag-part z)))
;; (put 'add '(complex scheme-number)
;;      (lambda (z x) (tag (add-complex-to-schemenum z x))))

;;;-------------------------
;;; 타입 바꾸기
;;; p253 

;; ;;; 방법 2의 구현
;; (define (scheme-number->complex n)
;;   (make-complex-from-real-imag (contents n) 0))
;; (put-coercion 'scheme-number 'complex scheme-number->complex)


;;; 타입 바꿈 표가 있을 때 연산 방법 :
;;; - apply-generic 에서 아래의 경우에 따라 결정
;; 1) 연산-타입 표에 있으면 그 연산 수행
;; 2) 없으면
;;    (1) 첫번째 물체를 두 번째 타입으로 바꾼다.
;;    (2) 두번째 물체를 첫 번째 타입으로 바꾼다.
;;    (3) 연산을 포기한다.
;;-> 이에 따른 apply-generic

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
	  (apply proc (map contents args))   ;; 1) 경우
	  (if (= (length args) 2)
	      (let ((type1 (car type-tags))
		    (type2 (cadr type-tags))
		    (a1 (car args))
		    (a2 (cadr args)))
		(let ((t1->t2 (get-coercion type1 type2))
		      (t2->t1 (get-coercion type2 type1)))
		  (cond (t1->t2
			 (apply-generic op (t1->t2 a1) a2))
			(t2->t1
			 (apply-generic op a1 (t2->t1 a2)))
			(else
			 (error "No method for these types"
				(list op type-tags))))))
	      (error "No mtehod for these types"
		     (list op type-tags)))))))

;;; 위의 타입 바꾸기 문제점
;;; 두 물체 사이에서 바꾸는 방법이 없더라도
;;; 두 물체를 모두 다른 타입으로 바꾸면 연산이 가능한 경우가 있다.


;;;=================
;;; 나의 put-coercion, get-coercion 구현
;;; 타입 변환 표 구현.
;;; 타입 변환 연산 실험

(define TCT (make-hash)) ;; 타입 변환 테이블(Type Conversion Table)

(define (put-coercion type1 type2 convertor)
  (hash-set! TCT (cons type1 type2) convertor))
;;  (hash-set! GOP (list op types) behavior))
;;  (hash-set! GOP (cons 'key (cons op types)) behavior))

(define (get-coercion type1 type2)
  (let ((key (cons type1 type2)))
    (if (hash-has-key? TCT key)
	(hash-ref TCT key)
	#f)))
;;  (hash-ref GOP (list op types)))
;;  (hash-ref GOP (cons 'key (cons op types))))

;; 타입 변환 표에 변환 등록
;; ex 2.80
(define (install-type-conversion-package)
  ;; ex 2.80
  (define (scheme-number->complex n)
    (make-complex-from-real-imag (contents n) 0))

  ;; ex 2.81
  (define (scheme-number->scheme-number n) n)
  (define (complex->complex z) z)

  ;; ex 2.80
  (put-coercion 'scheme-number 'complex scheme-number->complex)

  ;; ex 2.81
  (put-coercion 'scheme-number 'scheme-number
		scheme-number->scheme-number)
  (put-coercion 'complex 'complex complex->complex)
  ;; 

  'done)


(install-type-conversion-package)

((get-coercion 'scheme-number 'complex) 1)
;; '(complex rectangular 1 . 0)


;;;-------

;; 타입 변환을 위해서 get 함수 수정
;; key가 없으면 에러를 내지 않고 #f를 리턴 하도록
(define (get op types)
  (let ((key (cons op types)))
    (if (hash-has-key? GOP key)
	(hash-ref GOP key)
	#f)))

;;; 새로운 apply-generic 실험
;;; scheme-number와 complex 간 의 더하기 연산
(add (make-scheme-number 1) (make-complex-from-real-imag 1 1))
;; '(complex rectangular 2 . 1)

;;;==================



;;;-------------------------
;;; 타입의 계층 관계
;;; p256

;;; 타입의 계층 관계 : 탑
;;; 위타입   - 복소수
;;;   ^       상수
;;;   |       유리수
;;;   v
;;; 아래타입    정수
	  
;;; 탑 구조의 장점
;;; 1) 아래 타입이 위 타입에서 정의한 연산을 모두 물려받는다.
;;;    - 복소수의 real-part -> 정수에서도 사용 가능
;;;      (정수에서 real-part : 데이터를 위 타입으로 끌어올려서 real-part 적용)
;;;
;;; 2) 데이터 물체를 단순한 표현으로 끌어내리기 쉽다
;;;    - 6+0i -> 6
;;;     복소수 -> 정수


;;;-------------------------
;;; 계층 구조가 지닌 문제점
;;; p258

;;; 보통 계층 관계가 정확하게 정의되지 않는다.
;;; - 아래 타입이 여러 개 : 끌어내리는 방법의 문제 발생
;;; - 위 타입이 여러 개  : 끌어올리는 방법의 문제 발생



;;;--------------------------< ex 2.81 >--------------------------
;;; 260


;;; 앞의 ex 2.80 install-type-conversion-package 에 내용 추가 
(install-type-conversion-package)

;;; 테스트 
((get-coercion 'scheme-number 'scheme-number) 1) ; 1

((get-coercion 'complex 'complex) (make-complex-from-real-imag 1 2))
;; '(complex rectangular 1 . 2)

(add (make-scheme-number 1) (make-scheme-number 2)) ; 3
(add (make-complex-from-real-imag 1 2) (make-complex-from-real-imag 1 1))
;; '(complex rectangular 2 . 3)

;;; 잘 된다.

;;;--------------------
;;; a.

;;; 연산이 정의되어 있지 않다면?
(define (exp x y) (apply-generic 'exp x y))

;; 아래 코드를 scheme-number-package에 추가
;; ;; scheme-number 꾸러미에만 거듭제곱 프로시저가 들어있다.
;; (put 'exp '(scheme-number scheme-number)
;;      (lambda (x y) (tag (expt x y))))

(install-scheme-number-package)
;; (install-rational-package)
;; (install-rectangular-package)
;; (install-polar-package)
;; (install-complex-package)

(exp (make-scheme-number 2) (make-scheme-number 3)) ; 8 : 잘 된다.

;; 정의되지 않은 연산에 complex complex 타입 넘기면 
;;(exp (make-complex-from-real-imag 2 3) (make-complex-from-real-imag 3 4))
;; 무한루프
;; (계속 타입만 바꾼다.)
;;
;; (1)
;->(apply-generic 'exp '(complex rectangular 2 . 3) '(complex rectangular 3 . 4))
;;
;; (2)
;-> 첫번째 if proc : false  :: 'exp '(complex complex) 연산이 없으므로
;; 
;; (3)
;-> cond ((t1->t2) 
;;         (apply-generic 'exp (t1->t2 '(complex ... 2 . 3)) '(complex ... 3 . 4))
;;  수행
;;-> 다시 apply-generic 'exp '(complex ... 3) '(complex ... 4)
;;   (1)부터 반복하는 셈.


;;;--------------------
;;; b.

;;; 타입이 같은 인자는 타입을 바꾸지 않는게 좋겠군.
;;; a)에서 보니 무한루프를 돈단 말이지..


;;;--------------------
;;; c.
;;; 두 인자가 같은 타입일 때 타입 바꾸기가 일어나지 않도록 apply-generic을 고쳐라.


(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
	  (apply proc (map contents args))   ;; 1) 경우
	  (if (= (length args) 2)
	      (let ((type1 (car type-tags))
		    (type2 (cadr type-tags))
		    (a1 (car args))
		    (a2 (cadr args)))
		(if (eq? type1 type2)
		    (error "No method for these same types" (list op type-tags))
		    (let ((t1->t2 (get-coercion type1 type2))
			  (t2->t1 (get-coercion type2 type1)))
		      (cond (t1->t2
			     (apply-generic op (t1->t2 a1) a2))
			    (t2->t1
			     (apply-generic op a1 (t2->t1 a2)))
			    (else
			     (error "No method for these types"
				    (list op type-tags)))))))
		(error "No mtehod for these types"
		       (list op type-tags)))))))

;;; 테스트 
(exp (make-scheme-number 2) (make-scheme-number 3)) ; 8 : 잘 된다.

;; 정의되지 않은 연산에 complex complex 타입 넘기면 
;;(exp (make-complex-from-real-imag 2 3) (make-complex-from-real-imag 3 4))
;; No method for these same types (exp (complex complex))
;; 정상적으로 에러 발생


;;;--------------------------< ex 2.82 >--------------------------
;;; 2
(define (apply-generic op . arg) 
   ;; if all types can coerced into target-type 
   (define (can-coerced-into? types target-type) 
         (andmap 
           (lambda (type) 
                 (or (equal? type target-type) 
                     (get-coercion type target-type))) 
           types)) 
   ;; find one type that all other types can coerced into 
   (define (find-coerced-type types) 
         (ormap 
           (lambda (target-type) 
                 (if (can-coerced-into? types target-type) 
                   target-type 
                   #f)) 
           types)) 
   ;; coerced args into target-type 
   (define (coerced-all target-type) 
         (map  
           (lamdba (arg) 
                   (let ((arg-type (type-tag arg))) 
                      (if (equal? arg-type target-type) 
                        arg 
                        ((get-coercion arg-type target-type) arg)))) 
           args)) 
   (let ((type-tags (map type-tag args))) 
         (let ((proc (get op type-tags))) 
           (if proc 
             (apply proc (map contents args)) 
               (let ((target-type (find-coerced-type type-tags))) 
                 (if target-type 
                   (apply apply-generic  
                          (append (list op) (coerced-all target-type))) 
                   (error "no method for these types" (list op type-args)))))))) 
;;;--------------------------< ex 2.83 >--------------------------
;;; 2
(define (raise x) (apply-generic 'raise x)) 
  
 ;; add into scheme-number package 
 (put 'raise 'integer  
          (lambda (x) (make-rational x 1))) 
  
 ;; add into rational package 
 (put 'raise 'rational 
          (lambda (x) (make-real (/ (numer x) (denom x))))) 
  
 ;; add into real package 
 (put 'raise 'real 
          (lambda (x) (make-from-real-imag x 0))) 
;;;--------------------------< ex 2.84 >--------------------------
;;; 2
;; assuming that the types are arranged in a simple tower shape. 
 (define (apply-generic op . args) 
   ;; raise s into t, if success, return s; else return #f 
   (define (raise-into s t) 
         (let ((s-type (type-tag s)) 
               (t-type (type-tag t))) 
           (cond ((equal? s-type t-type) s) 
                 ((get 'raise (list s-type))  
                  (raise-into ((get 'raise (list s-type)) (contents s)) t)) 
                 (else #f)))) 
  
   (let ((type-tags (map type-tag args))) 
         (let ((proc (get op type-tags))) 
           (if proc 
             (apply proc (map contents args)) 
             (if (= (length args) 2) 
               (let ((a1 (car args)) 
                    (a2 (cadr args))) 
                 (cond  
                   ((raise-into a1 a2) 
                    (apply-generic op (raise-into a1 a2) a2)) 
                   ((raise-into a2 a1) 
                    (apply-generic op a1 (raise-into a2 a1))) 
                   (else (error "No method for these types" 
                         (list op type-tags))))) 
            (error "No method for these types" 
                   (list op type-tags))))))) 
;;;--------------------------< ex 2.85 >--------------------------
;;; 2
 ;; add into rational package 
 (put 'project 'rational 
      (lambda (x) (make-scheme-number (round (/ (numer x) (denom x)))))) 
  
 ;; add into real package 
 (put 'project 'real 
      (lambda (x)  
        (let ((rat (rationalize  
                     (inexact->exact x) 1/100))) 
          (make-rational 
            (numerator rat) 
            (denominator rat))))) 
  
 ;; add into complex package 
 (put 'project 'complex 
      (lambda (x) (make-real (real-part x)))) 
  
 (define (drop x) 
   (let ((project-proc (get 'project (type-tag x)))) 
     (if project-proc 
       (let ((project-number (project-proc (contents x)))) 
         (if (equ? project-number (raise project-number)) 
           (drop project-number) 
           x)) 
       x))) 
  
 ;; apply-generic 
 ;; the only change is to apply drop to the (apply proc (map contents args))  
 (drop (apply proc (map contents args))) 
;;;--------------------------< ex 2.86 >--------------------------
;;; 2
(define (sine x) (apply-generic 'sine x)) 
 (define (cosine x) (apply-generic cosine x)) 
  
 ;; add into scheme-number package 
 (put 'sine 'scheme-number 
      (lambda (x) (tag (sin x)))) 
 (put 'cosine 'scheme-number 
      (lambda (x) (tag (cos x)))) 
  
 ;; add into rational package 
 (put 'sine 'rational 
      (lambda (x) (tag (sin x)))) 
 (put 'cosine 'rational 
      (lambda (x) (tag (cos x)))) 
  
 ;; To accomodate generic number in the complex package,  
 ;; we should replace operators such as + , * with theirs 
 ;; generic counterparts add, mul. 
 (define (add-complex z1 z2) 
   (make-from-real-imag (add (real-part z1) (real-part z2)) 
                        (add (imag-part z1) (imag-part z2)))) 
 (define (sub-complex z1 z2) 
   (make-from-real-imag (sub (real-part z1) (real-part z2)) 
                        (sub (imag-part z1) (imag-part z2)))) 
 (define (mul-complex z1 z2) 
   (make-from-mag-ang (mul (magnitude z1) (magnitude z2)) 
                      (add (angle z1) (angle z2)))) 
 (define (div-complex z1 z2) 
   (make-from-mag-ang (div (magnitude z1) (magnitude z2)) 
                      (sub (angle z1) (angle z2))))

;;;;=================<ch 2.5.1 일반화된 산술 연산>=====================
;;; p245

;;;--------------------------< ex 2.87 >--------------------------
;;; 2
;; add into polynomial package 
 (define (zero-poly? poly) 
   (define (zero-terms? termlist) 
     (or (empty-termlist? termlist) 
         (and (=zero? (coeff (first-term termlist))) 
              (zero-terms? (rest-terms termlist))))) 
   (zero-terms? (term-list poly))) 

;;;--------------------------< ex 2.88 >--------------------------
;;; 2
(define (negate x) (apply-generic 'negate x)) 
  
 ;; add into scheme-number package 
 (put 'negate 'scheme-number 
       (lambda (n) (tag (- n)))) 
  
 ;; add into rational package 
 (put 'negate 'rational 
      (lambda (rat) (make-rational (- (numer rat)) (denom rat)))) 
  
 ;; add into complex package 
 (put 'negate 'complex 
      (lambda (z) (make-from-real-imag (- (real-part z)) 
                                       (- (imag-part z))))) 
  
 ;; add into polynomial package 
 (define (negate-terms termlist) 
   (if (empty-termlist? termlist) 
         the-empty-termlist 
         (let ((t (first-term termlist))) 
           (adjoin-term (make-term (order t) (negate (coeff t))) 
                        (negate-terms (rest-terms termlist)))))) 
 (put 'negate 'polynomial 
          (lambda (poly) (make-polynomial (variable poly) 
                                          (negate-terms (term-list poly))))) 
 (put 'sub '(polynomial polynomial) 
       (lambda (x y) (tag (add-poly x (negate y))))) 

;;;--------------------------< ex 2.89 >--------------------------
;;; 2

;; all we should change are procedure first-term and adjoin-term 
  
 (define (first-term term-list) 
   (list (car term-list) (- (length term-list) 1))) 
 (define (adjoin-term term term-list) 
   (let ((exponent (order term)) 
         (len (length term-list))) 
     (define (iter-adjoin times terms) 
       (cond ((=zero? (coeff term)) 
              terms)) 
             ((= exponent times) 
              (cons (coeff term) terms)) 
             (else (iter-adjoin (+ times 1)  
                                (cons 0 terms)))) 
         (iter-adjoin len term-list))) 

;;;--------------------------< ex 2.90 >--------------------------
;;; 2
 ; these have to be added to the polynomial package. So now it dispatches to 
 ; the generic procedures. 
  
   (define (the-empty-termlist term-list) 
     (let ((proc (get 'the-empty-termlist (type-tag term-list)))) 
     (if proc 
         (proc) 
         (error "No proc found -- THE-EMPTY-TERMLIST" term-list)))) 
   (define (rest-terms term-list) 
     (let ((proc (get 'rest-terms (type-tag term-list)))) 
       (if proc 
           (proc term-list) 
           (error "-- REST-TERMS" term-list)))) 
   (define (empty-termlist? term-list) 
     (let ((proc (get 'empty-termlist? (type-tag term-list)))) 
       (if proc 
           (proc term-list) 
           (error "-- EMPTY-TERMLIST?" term-list)))) 
   (define (make-term order coeff) (list order coeff)) 
   (define (order term) 
     (if (pair? term) 
         (car term) 
         (error "Term not pair -- ORDER" term))) 
   (define (coeff term) 
     (if (pair? term) 
         (cadr term) 
         (error "Term not pair -- COEFF" term))) 
  
 ; here is the term-list package, which has the constructors and selectors for  
 ; the dense and sparse polynomials. 
  
 ; the generic first-term procedure.  
 (define (first-term term-list) 
   (let ((proc (get 'first-term (type-tag term-list)))) 
     (if proc 
         (proc term-list) 
         (error "No first-term for this list -- FIRST-TERM" term-list)))) 
  
 ; the pakcage with the constructors, selectors, and other helper procedures 
 ; I had to implement. 
 (define (install-polynomial-term-package) 
   (define (first-term-dense term-list) 
     (if (empty-termlist? term-list) 
         '() 
         (list 
          (- (length (cdr term-list)) 1) 
          (car (cdr term-list)))))   
   (define (first-term-sparse term-list) 
     (if (empty-termlist? term-list) 
         '() 
         (cadr term-list))) 
   (define (prep-term-dense term) 
     (if (null? term) 
         '() 
         (cdr term)))                    ;-> only the coeff for a dense term-list 
   (define (prep-term-sparse term) 
     (if (null? term) 
         '() 
         (list term)))                   ;-> (order coeff) for a sparse term-list 
   (define (the-empty-termlist-dense) '(dense)) 
   (define (the-empty-termlist-sparse) '(sparse)) 
   (define (rest-terms term-list) (cons (type-tag term-list) (cddr term-list))) 
   (define (empty-termlist? term-list)  
     (if (pair? term-list)  
         (>= 1 (length term-list)) 
         (error "Term-list not pair -- EMPTY-TERMLIST?" term-list))) 
   (define (make-polynomial-dense var terms) 
     (make-polynomial var (cons 'dense (map cadr terms)))) 
   (define (make-polynomial-sparse var terms) 
     (make-polynomial var (cons 'sparse terms))) 
   (put 'first-term 'sparse  
        (lambda (term-list) (first-term-sparse term-list))) 
   (put 'first-term 'dense 
        (lambda (term-list) (first-term-dense term-list))) 
   (put 'prep-term 'dense 
        (lambda (term) (prep-term-dense term))) 
   (put 'prep-term 'sparse 
        (lambda (term) (prep-term-sparse term))) 
   (put 'rest-terms 'dense 
        (lambda (term-list) (rest-terms term-list))) 
   (put 'rest-terms 'sparse 
        (lambda (term-list) (rest-terms term-list))) 
   (put 'empty-termlist? 'dense 
        (lambda (term-list) (empty-termlist? term-list))) 
   (put 'empty-termlist? 'sparse 
        (lambda (term-list) (empty-termlist? term-list))) 
   (put 'the-empty-termlist 'dense 
        (lambda () (the-empty-termlist-dense))) 
   (put 'the-empty-termlist 'sparse 
        (lambda () (the-empty-termlist-sparse))) 
   (put 'make-polynomial 'sparse 
        (lambda (var terms) (make-polynomial-sparse var terms))) 
   (put 'make-polynomial 'dense 
        (lambda (var terms) (make-polynomial-dense var terms))) 
   'done) 
  
 (install-polynomial-term-package) 
  
  
 ; I had to changhe the adjoin-term procedure. It now does  
 ; zero padding so we can `mul` dense polynomials correctly.  
  
   (define (zero-pad x type) 
     (if (eq? type 'sparse) 
         '() 
         (if (= x 0) 
             '() 
             (cons 0 (add-zeros (- x 1)))))) 
  
   (define (adjoin-term term term-list) 
     (let ((preped-term ((get 'prep-term (type-tag term-list)) term)) 
           (preped-first-term ((get 'prep-term (type-tag term-list)) 
                               (first-term term-list)))) 
       (cond ((=zero? (coeff term)) term-list)  
             ((empty-termlist? term-list) (append (the-empty-termlist term-list)  
                                                  preped-term 
                                                  (zero-pad (order term) 
                                                            (type-tag 
                                                              term-list)))) 
             ((> (order term) (order (first-term term-list))) 
              (append (list (car term-list)) 
                      preped-term  
                      (zero-pad (- (- (order term) 
                                      (order (first-term term-list))) 
                                   1) (type-tag term-list)) 
                      (cdr term-list))) 
             (else 
              (append preped-first-term  
                      (adjoin-term term (rest-terms term-list))))))) 
  
 ; here is `negate` now it creates a polynomial of the correct 
 ; type 
  
   (define (negate p) 
     (let ((neg-p ((get 'make-polynomial (type-tag (term-list p))) 
                   (variable p) (list (make-term 0 -1))))) 
       (mul-poly (cdr neg-p) p))) 

;;;--------------------------< ex 2.91 >--------------------------
;;; 2
 (define (div-terms L1 L2) 
   (if (empty-termlist? L1) 
     (list (the-empty-termlist) (the-empty-termlist)) 
     (let ((t1 (first-term L1)) 
           (t2 (first-term L2))) 
       (if (> (order t2) (order t1)) 
         (list (the-empty-termlist) L1) 
         (let ((new-c (div (coeff t1) (coeff t2))) 
           (new-o (- (order t1) (order t2))) 
           (new-t (make-term new-o new-c))) 
           (let ((rest-of-result 
                   (div-terms (add-poly L1 (negate (mul-poly (list new-t) L2))) 
                               L2))) 
             (list (adjoin-term new-t 
                                (car rest-of-result)) 
                   (cadr rest-of-result)))))))) 
  
 (define (div-poly poly1 poly2) 
   (if (same-variable? (variable poly1) (variable poly2)) 
     (make-poly (variable poly1) 
       (div-terms (term-list poly1) 
                  (term-list poly2))) 
     (error "not the same variable" (list poly1 poly2)))) 

;;;--------------------------< ex 2.92 >--------------------------
;;; 2

(define (install-polynomial-package) 
   ;; internal procedures 
   ;; representation of poly 
   (define (make-poly variable term-list) 
     (cons variable term-list)) 
   (define (polynomial? p) 
     (eq? 'polynomial (car p))) 
   (define (variable p) (car p)) 
   (define (term-list p) (cdr p)) 
   (define (variable? x) 
     (symbol? x)) 
   (define (same-variable? x y) 
     (and (variable? x) (variable? y) (eq? x y))) 
  
   ;; representation of terms and term lists 
   (define (add-poly p1 p2) 
 ;   (display "var p1 ") (display p1) (newline) 
 ;   (display "var p2 ") (display p2) (newline) 
     (if (same-variable? (variable p1) (variable p2)) 
         (make-poly (variable p1) 
                    (add-terms (term-list p1) 
                               (term-list p2))) 
         (let ((ordered-polys (order-polys p1 p2))) 
           (let ((high-p (higher-order-poly ordered-polys)) 
                 (low-p (lower-order-poly ordered-polys))) 
             (let ((raised-p (change-poly-var low-p))) 
               (if (same-variable? (variable high-p)  
                                   (variable (cdr raised-p))) 
                   (add-poly high-p (cdr raised-p)) ;-> cdr for 'polynomial. Should fix this, 
                   ;; change-poly-var should return without 'polynomial as it is only used here. 
                   (error "Poly not in same variable, and can't change either! -- ADD-POLY" 
                          (list high-p (cdr raised-p))))))))) 
   (define (add-terms L1 L2) 
     (cond ((empty-termlist? L1) L2) 
           ((empty-termlist? L2) L1) 
           (else 
            (let ((t1 (first-term L1)) 
                  (t2 (first-term L2))) 
              (cond ((> (order t1) (order t2)) 
                     (adjoin-term 
                      t1 (add-terms (rest-terms L1) L2))) 
                    ((< (order t1) (order t2)) 
                     (adjoin-term 
                      t2 (add-terms L1 (rest-terms L2)))) 
                    (else 
                     (adjoin-term 
                      (make-term (order t1) 
                                 (add (coeff t1) (coeff t2))) 
                      (add-terms (rest-terms L1) 
                                 (rest-terms L2))))))))) 
  
   (define (mul-poly p1 p2) 
     (if (same-variable? (variable p1) (variable p2)) 
         (make-poly (variable p1) 
                    (mul-terms (term-list p1) 
                               (term-list p2))) 
         (let ((ordered-polys (order-polys p1 p2))) 
           (let ((high-p (higher-order-poly ordered-polys)) 
                 (low-p (lower-order-poly ordered-polys))) 
             (let ((raised-p (change-poly-var low-p))) 
               (if (same-variable? (variable high-p) 
                                   (variable (cdr raised-p))) 
                   (mul-poly high-p (cdr raised-p)) 
                   (error "Poly not in same variable, and can't change either! -- MUL-POLY" 
                          (list high-p (cdr raised-p))))))))) 
   (define (mul-terms L1 L2) 
     (if (empty-termlist? L1) 
         (the-empty-termlist L1) 
         (add-terms (mul-term-by-all-terms (first-term L1) L2) 
                    (mul-terms (rest-terms L1) L2)))) 
   (define (mul-term-by-all-terms t1 L) 
     (if (empty-termlist? L) 
         (the-empty-termlist L) 
         (let ((t2 (first-term L))) 
           (adjoin-term 
            (make-term (+ (order t1) (order t2)) 
                       (mul (coeff t1) (coeff t2))) 
            (mul-term-by-all-terms t1 (rest-terms L)))))) 
  
 (define (div-poly p1 p2) 
   (if (same-variable? (variable p1) (variable p2)) 
       (let ((answer (div-terms (term-list p1) 
                                (term-list p2)))) 
         (list (tag (make-poly (variable p1) (car answer))) 
               (tag (make-poly (variable p1) (cadr answer))))) 
         (let ((ordered-polys (order-polys p1 p2))) 
           (let ((high-p (higher-order-poly ordered-polys)) 
                 (low-p (lower-order-poly ordered-polys))) 
             (let ((raised-p (change-poly-var low-p))) 
               (if (same-variable? (variable high-p) 
                                   (variable (cdr raised-p))) 
                   (div-poly high-p (cdr raised-p)) 
                   (error "Poly not in same variable, and can't change either! -- DIV-POLY" 
                          (list high-p (cdr raised-p))))))))) 
  
  (define (div-terms L1 L2) 
    (define (div-help L1 L2 quotient) 
      (if (empty-termlist? L1) 
          (list (the-empty-termlist L1) (the-empty-termlist L1)) 
          (let ((t1 (first-term L1)) 
                (t2 (first-term L2))) 
            (if (> (order t2) (order t1)) 
                (list (cons (type-tag L1) quotient) L1) 
                (let ((new-c (div (coeff t1) (coeff t2))) 
                      (new-o (- (order t1) (order t2)))) 
                  (div-help 
                   (add-terms L1 
                              (mul-term-by-all-terms  
                               (make-term 0 -1) 
                               (mul-term-by-all-terms (make-term new-o new-c) 
                                                      L2))) 
                   L2  
                   (append quotient (list (list new-o new-c))))))))) 
    (div-help L1 L2 '())) 
  
   (define (zero-pad x type) 
     (if (eq? type 'sparse) 
         '() 
         (cond ((= x 0) '())      
               ((> x 0) (cons 0 (zero-pad (- x 1) type))) 
               ((< x 0) (cons 0 (zero-pad (+ x 1) type)))))) 
 ;;; donno what to do when coeff `=zero?` for know just return the  term-list 
   (define (adjoin-term term term-list) 
     (define (adjoin-help term acc term-list) 
       (let ((preped-term ((get 'prep-term (type-tag term-list)) term)) 
             (preped-first-term ((get 'prep-term (type-tag term-list)) 
                                 (first-term term-list))) 
             (empty-termlst (the-empty-termlist term-list))) 
         (cond ((=zero? (coeff term)) term-list)  
               ((empty-termlist? term-list) (append empty-termlst 
                                                    acc 
                                                    preped-term 
                                                    (zero-pad (order term) 
                                                              (type-tag term-list)))) 
                
               ((> (order term) (order (first-term term-list))) 
                (append (list (car term-list)) ;-> the type-tag 
                        acc 
                        preped-term  
                        (zero-pad (- (- (order term) 
                                        (order (first-term term-list))) 
                                     1) (type-tag term-list)) 
                        (cdr term-list))) 
               ((= (order term) (order (first-term term-list))) 
                (append (list (car term-list)) 
                        acc 
                        preped-term      ;-> if same order, use the new term 
                        (zero-pad (- (- (order term) 
                                        (order (first-term term-list))) 
                                     1) (type-tag term-list)) 
                        (cddr term-list))) ;-> add ditch the original term. 
               (else 
                (adjoin-help term  
                             (append acc preped-first-term)  
                             (rest-terms term-list)))))) 
     (adjoin-help term '() term-list)) 
  
   (define (negate p) 
     (let ((neg-p ((get 'make-polynomial (type-tag (term-list p))) 
                   (variable p) (list (make-term 0 -1))))) 
       (mul-poly (cdr neg-p) p)))        ; cdr of neg p to eliminat the tag 'polynomial 
  
   (define (zero-poly? p) 
     (define (all-zero? term-list) 
       (cond ((empty-termlist? term-list) #t) 
             (else 
              (and (=zero? (coeff (first-term term-list))) 
                   (all-zero? (rest-terms term-list)))))) 
     (all-zero? (term-list p))) 
  
   (define (equal-poly? p1 p2) 
     (and (same-variable? (variable p1) (variable p2)) 
          (equal? (term-list p1) (term-list p2)))) 
  
   (define (the-empty-termlist term-list) 
     (let ((proc (get 'the-empty-termlist (type-tag term-list)))) 
     (if proc 
         (proc) 
         (error "No proc found -- THE-EMPTY-TERMLIST" term-list)))) 
   (define (rest-terms term-list) 
     (let ((proc (get 'rest-terms (type-tag term-list)))) 
       (if proc 
           (proc term-list) 
           (error "-- REST-TERMS" term-list)))) 
   (define (empty-termlist? term-list) 
     (let ((proc (get 'empty-termlist? (type-tag term-list)))) 
       (if proc 
           (proc term-list) 
           (error "-- EMPTY-TERMLIST?" term-list)))) 
   (define (make-term order coeff) (list order coeff)) 
   (define (order term) 
     (if (pair? term) 
         (car term) 
         (error "Term not pair -- ORDER" term))) 
   (define (coeff term) 
     (if (pair? term) 
         (cadr term) 
         (error "Term not pair -- COEFF" term))) 
   ;; Mixed polynomial operations. This better way to do this, was just to raise the other types 
   ;; to polynomial. Becuase raise works step by step, all coeffs will end up as complex numbers. 
   (define (mixed-add x p)               ; I should only use add-terms to do this.  
     (define (zero-order L)              ; And avoid all this effort. :-S 
       (let ((t1 (first-term L))) 
         (cond ((empty-termlist? L) #f)  
               ((= 0 (order t1)) t1) 
               (else  
                (zero-order (rest-terms L)))))) 
     (let ((tlst (term-list p))) 
       (let ((last-term (zero-order tlst))) 
         (if last-term 
             (make-poly (variable p) (adjoin-term 
                                      (make-term 0 
                                                 (add x (coeff last-term))) 
                                      tlst)) 
             (make-poly (variable p) (adjoin-term (make-term 0 x) tlst)))))) 
  
   (define (mixed-mul x p) 
     (make-poly (variable p) 
                (mul-term-by-all-terms (make-term 0 x) 
                                       (term-list p)))) 
  
   (define (mixed-div p x) 
     (define (div-term-by-all-terms t1 L) 
       (if (empty-termlist? L) 
           (the-empty-termlist L) 
           (let ((t2 (first-term L))) 
             (adjoin-term 
              (make-term (- (order t1) (order t2)) 
                         (div (coeff t1) (coeff t2))) 
              (div-term-by-all-terms t1 (rest-terms L)))))) 
     (make-poly (variable p) 
                (div-term-by-all-terms (make-term 0 x) 
                                       (term-list p)))) 
  
   ;; Polynomial transformation. (Operations on polys of different variables) 
   (define (variable-order v)            ;-> var heirarchy tower. x is 1, every other letter 0. 
     (if (eq? v 'x) 1 0)) 
   (define (order-polys p1 p2)           ;-> a pair with the higher order poly `car`, and the 
     (let ((v1 (variable-order (variable p1))) ;-> lower order `cdr` 
           (v2 (variable-order (variable p2)))) 
       (if (> v1 v2) (cons p1 p2) (cons p2 p1)))) 
   (define (higher-order-poly ordered-polys) 
     (if (pair? ordered-polys) (car ordered-polys) 
         (error "ordered-polys not pair -- HIGHER-ORDER-POLY" ordered-polys))) 
   (define (lower-order-poly ordered-polys) 
     (if (pair? ordered-polys) (cdr ordered-polys) 
         (error "ordered-polys not pair -- LOWER-ORDER-POLY" ordered-polys))) 
  
   (define (change-poly-var p)           ;-> All terms must be polys 
     (define (helper-change term-list)   ;-> change each term in term-list 
       (cond ((empty-termlist? term-list) '()) ;-> returns a list of polys with changed var.  
             (else                             ;-> one poly per term.  
              (cons (change-term-var (variable p) 
                                     (type-tag term-list) 
                                     (first-term term-list)) 
                    (helper-change (rest-terms term-list)))))) 
     (define (add-poly-list acc poly-list) ;-> add a list of polys. 
       (if (null? poly-list)               ;-> no more polys, give me the result. 
           acc 
           (add-poly-list (add acc (car poly-list)) ;-> add acc'ed result to first poly 
                          (cdr poly-list)))) ;-> rest of the polys.  
     (add-poly-list 0 (helper-change (term-list p)))) 
    (define (change-term-var original-var original-type term) 
      (make-polynomial original-type (variable (cdr (coeff term))) ;-> cdr eliminates 'polynomial 
                      (map (lambda (x) 
                             (list (order x) ;-> the order in x  
                                   (make-polynomial ;-> coeff is a poly in  
                                    original-type ;-> the original-type (in this example y) 
                                    original-var ;-> the original-var is passed to the coeffs now 
                                    (list        ;-> each term, is formed by  
                                     (list (order term) ;-> the order of the orignal term  
                                           (coeff x)))))) ;-> and the coeff of each term in x 
                           (cdr (term-list (cdr (coeff term))))))) ;-> un-tagged termlist of 
                                                                   ;-> the coeff of the term of y. 
  
   ;; interface to rest of the system 
   (define (tag p) (attach-tag 'polynomial p)) 
   (put 'add '(polynomial polynomial) 
        (lambda (p1 p2) (tag (add-poly p1 p2)))) 
   (put 'sub '(polynomial polynomial) 
        (lambda (p1 p2) (tag (add-poly p1 (negate p2))))) 
   (put 'mul '(polynomial polynomial) 
        (lambda (p1 p2) (tag (mul-poly p1 p2)))) 
   (put 'negate '(polynomial) 
        (lambda (p) (negate p))) 
   (put 'div '(polynomial polynomial) 
        (lambda (p1 p2) (div-poly p1 p2))) 
   (put 'zero-poly? '(polynomial) 
        (lambda (p) (zero-poly? p))) 
   (put 'equal-poly? '(polynomial polynomial) 
        (lambda (p1 p2) (equal-poly? p1 p2))) 
   (put 'make 'polynomial 
        (lambda (var terms) (tag (make-poly var terms)))) 
    
   ;; Interface of the mixed operations. 
   ;; Addition 
   (put 'add '(scheme-number polynomial) ; because it's commutative I won't define both. Just 
        (lambda (x p) (tag (mixed-add x p)))) ;poly always second. 
   (put 'add '(rational polynomial) 
        (lambda (x p) (tag (mixed-add (cons 'rational x) p)))) ;-> this is needed becuase 
   (put 'add '(real polynomial)                                ;-> apply-generic will remove the 
        (lambda (x p) (tag (mixed-add x p))))                  ;-> tag. 
   (put 'add '(complex polynomial) 
        (lambda (x p) (tag (mixed-add (cons 'complex x) p)))) 
   ;; Subtraction 
   (put 'sub '(scheme-number polynomial) 
        (lambda (x p) (tag (mixed-add x (negate p))))) 
   (put 'sub '(polynomial scheme-number) 
        (lambda (p x) (tag (mixed-add (mul -1 x) p)))) 
   (put 'sub '(rational polynomial) 
        (lambda (x p) (tag (mixed-add (cons 'rational x) (negate p))))) 
   (put 'sub '(polynomial rational) 
        (lambda (p x) (tag (mixed-add (mul -1 (cons 'rational x)) p)))) 
   (put 'sub '(real polynomial) 
        (lambda (x p) (tag (mixed-add x (negate p))))) 
   (put 'sub '(polynomial real) 
        (lambda (p x) (tag (mixed-add (mul -1 x) p)))) 
   (put 'sub '(complex polynomial) 
        (lambda (x p) (tag (mixed-add (cons 'complex x) (negate p))))) 
   (put 'sub '(polynomial complex) 
        (lambda (p x) (tag (mixed-add (mul -1 (cons 'complex x)) p)))) 
   ;; Multiplication 
   (put 'mul '(scheme-number polynomial) 
        (lambda (x p) (tag (mixed-mul x p)))) 
   (put 'mul '(rational polynomial) 
        (lambda (x p) (tag (mixed-mul (cons 'rational x) p)))) 
   (put 'mul '(real polynomial) 
        (lambda (x p) (tag (mixed-mul x p)))) 
   (put 'mul '(complex polynomial) 
        (lambda (x p) (tag (mixed-mul (cons 'complex x) p)))) 
   ;; Division 
   ;; Using a polynomial as a divisor will leave me wiht negative orders. Which I donno how to 
   ;; handle yet. 
   (put 'div '(polynomial scheme-number) 
        (lambda (p x) (tag (mixed-mul (/ 1 x) p)))) 
   (put 'div '(scheme-number polynomial) 
        (lambda (x p) (tag (mixed-div p x)))) 
   (put 'div '(polynomial rational)      ;multiply by the denom, and divide by the numer. 
        (lambda (p x) (tag (mixed-mul (make-rational (cdr x) (car x)) p)))) 
   (put 'div '(rational polynomial) 
        (lambda (x p) (tag (mixed-div p (cons 'rational x))))) 
   (put 'div '(polynomial real)   
        (lambda (p x) (tag (mixed-mul (/ 1.0 x) p)))) 
   (put 'div '(real polynomial) 
        (lambda (x p) (tag (mixed-div p x)))) 
   (put 'div '(polynomial complex) 
        (lambda (p x) (tag (mixed-mul (div 1 (cons 'complex x)) p)))) 
   (put 'div '(complex polynomial) 
        (lambda (x p) (tag (mixed-div p (cons 'complex x))))) 
   'done) 
  
 (install-polynomial-package) 
  
 ; this takes an extra argument type to specify if it is dense or sparse. 
 (define (make-polynomial type var terms) 
   (let ((proc (get 'make-polynomial type))) 
     (if proc 
         (proc var terms) 
         (error "Can't make poly of this type -- MAKE-POLYNOMIAL" 
                (list type var terms))))) 
  
 ; the generic negate procedure needed for subtractions.  
  
 (define (negate p) 
   (apply-generic 'negate  p)) 
  
 ; And the generic first-term procedure with it's package to work with dense and 
 ; sparse polynomials. 
  
 (define (first-term term-list) 
   (let ((proc (get 'first-term (type-tag term-list)))) 
     (if proc 
         (proc term-list) 
         (error "No first-term for this list -- FIRST-TERM" term-list)))) 
  
 (define (install-polynomial-term-package) 
   (define (first-term-dense term-list) 
     (if (empty-termlist? term-list) 
         '() 
         (list 
          (- (length (cdr term-list)) 1) 
          (car (cdr term-list)))))   
   (define (first-term-sparse term-list) 
     (if (empty-termlist? term-list) 
         '() 
         (cadr term-list))) 
   (define (prep-term-dense term) 
     (if (null? term) 
         '() 
         (cdr term)))                            ;-> only the coeff for a dense term-list 
   (define (prep-term-sparse term) 
     (if (null? term) 
         '() 
         (list term)))         ;-> (order coeff) for a sparse term-list 
   (define (the-empty-termlist-dense) '(dense)) 
   (define (the-empty-termlist-sparse) '(sparse)) 
   (define (rest-terms term-list) (cons (type-tag term-list) (cddr term-list))) 
   (define (empty-termlist? term-list)  
     (if (pair? term-list)  
         (>= 1 (length term-list)) 
         (error "Term-list not pair -- EMPTY-TERMLIST?" term-list))) 
   (define (make-polynomial-dense var terms) 
     (append (list 'polynomial var 'dense) (map cadr terms))) 
   (define (make-polynomial-sparse var terms) 
     (append (list 'polynomial var 'sparse) terms)) 
   (put 'first-term 'sparse  
        (lambda (term-list) (first-term-sparse term-list))) 
   (put 'first-term 'dense 
        (lambda (term-list) (first-term-dense term-list))) 
   (put 'prep-term 'dense 
        (lambda (term) (prep-term-dense term))) 
   (put 'prep-term 'sparse 
        (lambda (term) (prep-term-sparse term))) 
   (put 'rest-terms 'dense 
        (lambda (term-list) (rest-terms term-list))) 
   (put 'rest-terms 'sparse 
        (lambda (term-list) (rest-terms term-list))) 
   (put 'empty-termlist? 'dense 
        (lambda (term-list) (empty-termlist? term-list))) 
   (put 'empty-termlist? 'sparse 
        (lambda (term-list) (empty-termlist? term-list))) 
   (put 'the-empty-termlist 'dense 
        (lambda () (the-empty-termlist-dense))) 
   (put 'the-empty-termlist 'sparse 
        (lambda () (the-empty-termlist-sparse))) 
   (put 'make-polynomial 'sparse 
        (lambda (var terms) (make-polynomial-sparse var terms))) 
   (put 'make-polynomial 'dense 
        (lambda (var terms) (make-polynomial-dense var terms))) 
   'done) 
  
 (install-polynomial-term-package) 
;;;--------------------------< ex 2.93 >--------------------------
;;; 2
 (define (greatest-common-divisor a b) 
   (apply-generic 'greatest-common-divisor a b)) 
  
 ;; add into scheme-number package 
 (put 'greatest-common-divisor '(scheme-number scheme-number) 
      (lambda (a b) (gcd a b))) 
  
 ;; add into polynomial package 
 (define (remainder-terms p1 p2) 
   (cadr (div-terms p1 p2))) 
  
 (define (gcd-terms a b) 
   (if (empty-termlist? b) 
     a 
     (gcd-terms b (remainder-terms a b)))) 
  
 (define (gcd-poly p1 p2) 
   (if (same-varaible? (variable p1) (variable p2)) 
         (make-poly (variable p1) 
                    (gcd-terms (term-list p1) 
                               (term-list p2)) 
         (error "not the same variable -- GCD-POLY" (list p1 p2))))) 
  
 (put 'greatest-common-divisor '(polynomial polynomial) 
          (lambda (a b) (tag (gcd-poly a b)))) 

;;;--------------------------< ex 2.94 >--------------------------
;;; 2

(define (greatest-common-divisor a b) 
   (apply-generic 'greatest-common-divisor a b)) 
  
 ;; add into scheme-number package 
 (put 'greatest-common-divisor '(scheme-number scheme-number) 
      (lambda (a b) (gcd a b))) 
  
 ;; add into polynomial package 
 (define (remainder-terms p1 p2) 
   (cadr (div-terms p1 p2))) 
  
 (define (gcd-terms a b) 
   (if (empty-termlist? b) 
     a 
     (gcd-terms b (remainder-terms a b)))) 
  
 (define (gcd-poly p1 p2) 
   (if (same-varaible? (variable p1) (variable p2)) 
     (make-poly (variable p1) 
                (gcd-terms (term-list p1) 
                           (term-list p2)) 
     (error "not the same variable -- GCD-POLY" (list p1 p2))))) 
  
 (put 'greatest-common-divisor '(polynomial polynomial) 
      (lambda (a b) (tag (gcd-poly a b)))) 
;;;--------------------------< ex 2.95 >--------------------------
;;; 2

;;;--------------------------< ex 2.96 >--------------------------
;;; 2
;; a 
 (define (pseudoremainder-terms a b) 
   (let* ((o1 (order (first-term a))) 
          (o2 (order (first-term b))) 
          (c (coeff (first-term b))) 
          (divident (mul-terms (make-term 0  
                                          (expt c (+ 1 (- o1 o2)))) 
                               a))) 
     (cadr (div-terms divident b)))) 
  
 (define (gcd-terms a b) 
   (if (empty-termlist? b) 
     a 
     (gcd-terms b (pseudoremainder-terms a b)))) 
  
 ;; b 
 (define (gcd-terms a b) 
   (if (empty-termlist? b) 
     (let* ((coeff-list (map cadr a)) 
            (gcd-coeff (apply gcd coeff-list))) 
       (div-terms a (make-term 0  gcd-coeff))) 
     (gcd-terms b (pseudoremainder-terms a b))))
;;;--------------------------< ex 2.97 >--------------------------
;;; 2
;;a 
 (define (reduce-terms n d) 
   (let ((gcdterms (gcd-terms n d))) 
         (list (car (div-terms n gcdterms)) 
               (car (div-terms d gcdterms))))) 
  
 (define (reduce-poly p1 p2) 
   (if (same-variable? (variable p1) (variable p2)) 
     (let ((result (reduce-terms (term-list p1) (term-list p2)))) 
       (list (make-poly (variable p1) (car result)) 
             (make-poly (variable p1) (cadr result)))) 
     (error "not the same variable--REDUCE-POLY" (list p1 p2)))) 
  
 ;;b. skip this, I had done such work many times, I'm tired of it. 

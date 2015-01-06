;;; Church Numerals
;;; Assume we have a programming language that doesn't support numbers
;;; or booleans: a lambda is the only value it provides.
;;; We can create some system that allows us to count, add, multiply,
;;; and do all other things we do with numbers.

;;; Church numerals use lambdas to create a representation of
;;; numbers. The idea is closely related to the functional
;;; representation of natural numbers, i.e. to have a natural number
;;; representing "zero" and a function "succ" that returns the
;;; successor of the natural number it was given.

;;; All Church numerals are functions with two parameters
;;;  (lambda (f) (lambda (x) (something)))

;;; The first parameter, f, is the successor function that should be
;;; used.  The second parameter, x, is the value that represents zero.
;;; Therefore, The Church numerals for zero is
(define C0 (lambda (f) (lambda (x) x)))

;;; The Church numerals for one applies the successor function to the
;;; value representing zero exactly once:
(define C1 (lambda (f) (lambda (x) (f x))))

;;; The Church numerals for two, three, four, ..., n
(define C2 (lambda (f) (lambda (x) (f (f x)))))
(define C3 (lambda (f) (lambda (x) (f (f (f x))))))
(define C4 (lambda (f) (lambda (x) (f (f (f (f x)))))))
;; (define Cn (lambda (f) (lambda (x) (f (f (f (f (f (f x)))))))))
;;                                    ~~~~~~~ n ~~~~~~~

;; The addition function (plus C3 C4)
;; (plus C3 C4)
;; => (lambda (f) (lambda (x) ((C3 f) ((C4 f) x))))
;; => (lambda (f) (lambda (x) (((lambda (f3) (lambda (x3) (f3 (f3 (f3 x3))))) f) ((C4 f) x))))
;; => (lambda (f) (lambda (x) ((lambda (x3) (f (f (f x3)))) ((C4 f) x))))
;; => (lambda (f) (lambda (x) ((lambda (x3) (f (f (f x3)))) (((lambda (f4) (lambda (x4) (f4 (f4 (f4 (f4 x4)))))) f) x))))
;; => (lambda (f) (lambda (x) ((lambda (x3) (f (f (f x3)))) ((lambda (x4) (f (f (f (f x4))))) x))))
;; => (lambda (f) (lambda (x) ((lambda (x3) (f (f (f x3)))) (f (f (f (f x)))))))
;; => (lambda (f) (lambda (x) (f (f (f (f (f (f (f x)))))))))
(define (plus m n)
  (lambda (f) (lambda (x) ((m f) ((n f) x)))))

;;; The successor function (succ n) is β-equivalent to (plus C1 n)
;; (succ n)
;; => (plus C1 n)
;; => (lambda (f) (lambda (x) ((C1 f) ((n f) x))))
;; => (lambda (f) (lambda (x) (((lambda (f1) (lambda (x1) (f1 x1))) f) ((n f) x))))
;; => (lambda (f) (lambda (x) ((lambda (x1) (f x1)) ((n f) x))))
;; => (lambda (f) (lambda (x) (f ((n f) x))))
(define (succ n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

;; (succ C0)
;; => (succ (lambda (f) (lambda (x) x)))
;; => (lambda (f) (lambda (x) (f (((lambda (f0) (lambda (x0) x0)) f) x))))
;; => (lambda (f) (lambda (x) (f ((lambda (x0) x0) x))))
;; => (lambda (f) (lambda (x) (f x)))

;; (succ C1)
;; => (succ (lambda (f) (lambda (x) (f x))))
;; => (lambda (f) (lambda (x) (f (((lambda (f1) (lambda (x1) (f1 x1))) f) x))))
;; => (lambda (f) (lambda (x) (f ((lambda (x1) (f x1)) x))))
;; => (lambda (f) (lambda (x) (f (f x))))

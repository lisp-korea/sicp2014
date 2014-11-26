#lang planet neil/sicp

;; recursive version:
;; (define (sum term a next b)
;;   (if (> a b)
;;       0
;;       (+ (term a)
;;          (sum term (next a) next b))))

;; make iterative version of (sum term a next b).

;; (define (sum term a next b)
;;   (define (iter a result)
;;      (if <>
;;          <>
;;          (iter <> <>)))
;;   (iter <> <>))


(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ result (term a)))))
  (iter a 0))

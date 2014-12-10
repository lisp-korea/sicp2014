;; Alyssa P. Hacker's code.

(define (make-interval a b) (cons a b))

(define (lower-bound x) (car x))

(define (upper-bound x) (cdr x))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

;; Ben Bitdiddle's advice.

;; (a  b) x (a' b')
;; ----------------
;; (+  +) x (+  +) -> (aa', bb')
;; (-  -) x (-  -) -> (bb', aa')
;; (-  +) x (+  +) -> (ab', bb')
;; (+  +) x (-  +) -> (a'b, bb')
;; (-  -) x (+  +) -> (ab', a'b)
;; (+  +) x (-  -) -> (a'b, ab')
;; (-  +) x (-  -) -> (a'b, aa')
;; (-  -) x (-  +) -> (ab', aa')
;; (-  +) x (-  +) -> (ab', bb') or (a'b, bb')
;;
;; (0이 있는 경우, 예전 mul-interval 함수를 사용하는 것으로 처리함)

(define (mul-interval-1 x y)
  (if (or (= 0 (lower-bound x)) (= 0 (lower-bound y))
          (= 0 (upper-bound x)) (= 0 (upper-bound y)))
      (mul-interval x y) ;; use original func
      (mul-interval-non0 x y)))

(define (mul-interval-non0 x y)
  (let ((lx (lower-bound x))
        (ux (upper-bound x))
        (ly (lower-bound y))
        (uy (upper-bound y)))
    (cond ((and (> lx 0) (> ux 0) (> ly 0) (> uy 0))
           (make-interval (* lx ly) (* ux uy)))
          ((and (< lx 0) (< ux 0) (< ly 0) (< uy 0))
           (make-interval (* ux uy) (* lx ly)))
          ((and (< lx 0) (> ux 0) (> ly 0) (> uy 0))
           (make-interval (* lx uy) (* ux uy)))
          ((and (> lx 0) (> ux 0) (< ly 0) (> uy 0))
           (make-interval (* ly ux) (* ux uy)))
          ((and (< lx 0) (< ux 0) (> ly 0) (> uy 0))
           (make-interval (* lx uy) (* ly ux)))
          ((and (> lx 0) (> ux 0) (< ly 0) (< uy 0))
           (make-interval (* ly ux) (* lx uy)))
          ((and (< lx 0) (> ux 0) (< ly 0) (< uy 0))
           (make-interval (* ly ux) (* lx ly)))
          ((and (< lx 0) (< ux 0) (< ly 0) (> uy 0))
           (make-interval (* lx uy) (* lx ly)))
          ((and (< lx 0) (> ux 0) (< ly 0) (> uy 0))
           (make-interval (min (* lx uy) (* ly ux)) (* ux uy))))))

;; test
(mul-interval-1 (make-interval 1 2) (make-interval 3 4))
(mul-interval   (make-interval 1 2) (make-interval 3 4))

(mul-interval-1 (make-interval -2 -1) (make-interval -4 -3))
(mul-interval   (make-interval -2 -1) (make-interval -4 -3))

(mul-interval-1 (make-interval -1 2) (make-interval 3 4))
(mul-interval   (make-interval -1 2) (make-interval 3 4))

(mul-interval-1 (make-interval 1 2) (make-interval -3 4))
(mul-interval   (make-interval 1 2) (make-interval -3 4))

(mul-interval-1 (make-interval -2 -1) (make-interval 3 4))
(mul-interval   (make-interval -2 -1) (make-interval 3 4))

(mul-interval-1 (make-interval 1 2) (make-interval -4 -3))
(mul-interval   (make-interval 1 2) (make-interval -4 -3))

(mul-interval-1 (make-interval -1 2) (make-interval -4 -3))
(mul-interval   (make-interval -1 2) (make-interval -4 -3))

(mul-interval-1 (make-interval -2 -1) (make-interval -3 4))
(mul-interval   (make-interval -2 -1) (make-interval -3 4))

(mul-interval-1 (make-interval -1 2) (make-interval -3 4))
(mul-interval   (make-interval -1 2) (make-interval -3 4))

;;; Exercise 2.11

(define (make-interval a b) (cons a b))

(define (lower-bound x) (car x))

(define (upper-bound x) (cdr x))

(define (mul-interval x y)

  (define (plus? n) (>= n 0))

  (define (sign-type i)
    (if (plus? (lower-bound i))
	(if (plus? (upper-bound i))
	    'plus-plus
	    (error "invalid"))
	(if (plus? (upper-bound i))
	    'minus-plus
	    'minus-minus)))
  (let ((x-sign-type (sign-type x))
	(y-sign-type (sign-type y)))
    (cond ((or (and (eq? x-sign-type 'plus-plus) (eq? y-sign-type 'plus-plus))
	       (and (eq? x-sign-type 'minus-minus) (eq? y-sign-type 'minus-minus)))
	   (make-interval (* (upper-bound x) (upper-bound y))
			  (* (lower-bound x) (lower-bound y))))
	  ((and (eq? x-sign-type 'plus-plus) (eq? y-sign-type 'minus-plus))
	   (make-interval (* (upper-bound x) (lower-bound y))
			  (* (upper-bound x) (upper-bound y))))
	  ((or (and (eq? x-sign-type 'plus-plus) (eq? y-sign-type 'minus-minus))
	       (and (eq? x-sign-type 'minus-minus) (eq? y-sign-type 'plus-plus)))
	   (make-interval (* (upper-bound x) (upper-bound y))
			  (* (lower-bound x) (lower-bound y))))
	  ((and (eq? x-sign-type 'minus-plus) (eq? y-sign-type 'plus-plus))
	   (make-interval (* (lower-bound x) (upper-bound y))
			  (* (upper-bound x) (upper-bound y))))
	  ((and (eq? x-sign-type 'minus-plus) (eq? y-sign-type 'minus-plus))
	   (make-interval (min (* (lower-bound x) (upper-bound y))
			       (* (upper-bound x) (lower-bound y)))
			  (max (* (lower-bound x) (lower-bound y))
			       (* (upper-bound x) (upper-bound y)))))
	  ((and (eq? x-sign-type 'minus-plus) (eq? y-sign-type 'minus-minus))
	   (make-interval (* (upper-bound x) (upper-bound y))
			  (* (lower-bound x) (upper-bound y))))
	  ((and (eq? x-sign-type 'minus-minus) (eq? y-sign-type 'minus-plus))
	   (make-interval (* (upper-bound x) (upper-bound y))
			  (* (upper-bound x) (lower-bound y)))))))

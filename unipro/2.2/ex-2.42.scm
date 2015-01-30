;;; Exercise 2.42

(define (queens board-size)
  (define empty-board nil)

  ;; XXX: k is not used
  (define (safe? k positions)
    (null? (filter (lambda (q) (eq? (car positions) q))
		   (cdr positions))))

  ;; XXX: k is not used
  (define (adjoin-position new-row k rest-of-queens)
    (cons new-row rest-of-queens))

  (define (queen-cols k)
    (if (= k 0)
	(list empty-board)
	(filter
	 (lambda (positions) (safe? k positions))
	 (flatmap
	  (lambda (rest-of-queens)
	    (map (lambda (new-row)
		   (adjoin-position new-row k rest-of-queens))
		 (enumerate-interval 1 board-size)))
	  (queen-cols (- k 1))))))
  (queen-cols board-size))

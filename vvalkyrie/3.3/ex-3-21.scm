(define (front-ptr queue) (car queue))

(define (rear-ptr queue) (cdr queue))

(define (set-front-ptr! queue item) (set-car! queue item))

(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (empty-queue? queue) (null? (front-ptr queue)))

(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
    (error "FRONT called with an empty queue" queue)
    (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue)
          (else
            (set-cdr! (rear-ptr queue) new-pair)
            (set-rear-ptr! queue new-pair)
            queue))))

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
          (set-front-ptr! queue (cdr (front-ptr queue)))
          queue)))

; ex 3.21
(define q1 (make-queue))

(insert-queue! q1 'a) ;;=> ((a) a)

(insert-queue! q1 'b) ;;=> ((a b) b)

(delete-queue! q1) ;;=> ((b) b)

(delete-queue! q1) ;;=> (() b)

; why? and define procedure `print-queue`.
;
; Because REPL just print the q1's first cons pair, `front-ptr` and `rear-ptr`.

(define (print-queue queue)
  (define (print-element e)
    (if (null? e)
      (display "(rear)")
      (begin
        (display (car e))
        (display " ")
        (print-element (cdr e)))))
  (newline)
  (display "(front) ")
  (print-element (front-ptr queue)))

(print-queue q1)

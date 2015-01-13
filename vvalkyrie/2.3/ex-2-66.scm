; ex 2.66

(define (entry tree) (car tree))

(define (left-branch tree) (cadr tree))

(define (right-branch tree) (caddr tree))

;; assume: entry is a cons of key and data.
(define (key entry) (car entry))

; binary tree version
(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) #f)
        ((equal? given-key (key (entry set-of-records)) (entry set-of-records)))
        ((< given-key (key (entry set-of-records)))
         (lookup given-key (left-branch set-of-records)))
        ((> given-key (key (entry set-of-records)))
         (lookup given-key (right-branch set-of-records)))))


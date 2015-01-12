; ex 2.63

(define (make-tree entry left right)
  (list entry left right))

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
    (cons '() elts)
    (let ((left-size (quotient (- n 1) 2)))
      (let ((left-result (partial-tree elts left-size)))
        (let ((left-tree (car left-result))
              (non-left-elts (cdr left-result))
              (right-size (- n (+ left-size 1))))
          (let ((this-entry (car non-left-elts))
                (right-result (partial-tree (cdr non-left-elts)
                                            right-size)))
            (let ((right-tree (car right-result))
                  (remaining-elts (cdr right-result)))
              (cons (make-tree this-entry left-tree right-tree)
                    remaining-elts))))))))

(list->tree '(1 3 5 7 9 11))
;;=> (5 (1 () (3 () ())) (9 (7 () ()) (11 () ())))

;; list 길이를 기준으로, 첫번째 절반에 대해 partial-tree를 통해
;; left-result를 생성한다.
;; 그 다음 element에 대해 this-entry로 삼아 해당 tree의 entry로 삼고,
;; 나머지 절반에 대해 다시 partial-tree를 돌려 right-result를 생성한다.
;; 각 partial-tree에서는 주어진 파라미터에 의해 같은 동작을 반복하여
;; length = 0인 경우에 empty list를 반환할 때까지 재귀적으로 반복한다.
;; left-result와 right-result의 결과로부터 각각 left-tree와 right-tree를
;; 가져와 this-entry와 함께 묶어 tree를 만들고, 이를 남아있는 list와
;; 함께 cons로 묶어 반환한다.


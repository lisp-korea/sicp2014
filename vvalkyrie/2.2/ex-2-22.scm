; ex 2.22

(define (square x) (* x x))

;; 역순으로 바뀌는 문제는 아래와 같이 answer와 (square (car things))의
;; 위치를 바꾸면 된다.

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items '()))

(square-list (list 1 2 3 4))
;;=> ((((() . 1) . 4) . 9) . 16)

;; 위 square-list 함수에 따라 전개되는 결과는 다음과 동일하다.
(cons (cons (cons (cons '() 1) 4) 9) 16)

;; 그러나 (1 4 9 16) 과 같은 결과를 얻으려면 다음과 같이 전개돼야 한다.
(cons 1 (cons 4 (cons 9 (cons 16 '()))))

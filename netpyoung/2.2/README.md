# 2.2 계층 구조 데이터와 닫힘 성질 - 126p
http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-15.html#%_sec_2.2

* car, cdr - cons
 -  constructs memory objects which hold two values or pointers to values.
 - car, cdr란 이름이 붙은 까닭: "IBM 704"상에서 lisp를 구현하는데, 당시 "IBM 704"에서 사용하는 레지스터의 이름이 car, cdr이였다.
 - 후에, 대안이름 first와 rest란게 나왔으나 caar, cadr, cdadr등 중첩키워드를 대체하기에는 무리가 있었음.


    [15 Address][15 Decrement][3 Prefix][3 Tag]
    car (Contents of the Address part of Register number)
    cdr (Contents of the Decrement part of Register number)
    cpr (Contents of the Prefix part of Register number)
    ctr (Contents of the Tag part of Register number)




* cons 쌍이, 다른 cons 쌍의 원소가 될 수 있다.

![ch2-Z-G-12.gif](http://mitpress.mit.edu/sicp/full-text/book/ch2-Z-G-12.gif)


* closure property : 닫힘 성질.
 - closure ** : 어떤 집합에 속하는 원소를 가지고 연산한 결과가, 그 집합에 속하면, 그 집합은 주어진 연산에 닫혀 있다.
 - closure    : 자유 변수를 지닌 프로시져를 표현하는 기법.
- 닫힘 성질에 바탕을 두고, 뭉친 데이터를 만들어 보기로 한다.
 - sequence, tree, graphic language




## 2.2.1 차례열의 표현방법. - 128p
http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-15.html#%_sec_2.2.1

* cons cell을 이용하여 만든 자료 구조 sequence. list에 대해 설명함.


![](http://mitpress.mit.edu/sicp/full-text/book/ch2-Z-G-13.gif)

```scheme
(cons 1
  (cons 2
    (cons 3
      (cons 4 nil))))

(list 1 2 3 4)
```

- nil : `nothing`을 뜻하는, 라틴어의 `nihil`을 줄인 것.


### 리스트 연산



```scheme
(define (zero? n) (= n 0))
(define (inc n) (+ n 1))
(define (dec n) (- n 1))
(define (first seq) (car seq))
(define (rest seq) (cdr seq))


(define (nth items n)
  (if (zero? n)
    (first items)
    (nth (rest items) (dec n))))

(define squares
  (list 1 4 9 16 25))

(nth squares 3)
;=> 16
```



```scheme
(define (length items)
  (define (length-iter seq acc)
    (if (null? seq)
      acc
      (length-iter (rest a) (inc acc))))
  (length-iter items 0))


(length '(1 2 3 4 5))
;=> 5
```


```scheme
(define (append lst1 lst2)
  (if (null? lst1)
    lst2
    (cons (first lst1)
          (append (rest lst1) lst2))))
```



* 2.17 pass

(빈 리스트가 아닌) 리스트를 인자로 받아, 그 리스트의 마지막 원소만으로 이루어진 리스트를 내놓는 last-pair.

```scheme
(define (last-pair list)
  (let ((rst (rest list)))
    (if (null? rst)
        list
        (last-pair rst))))


(last-pair (list 23 72 149 34))
;=> (34)

(last-pair (list 23 72 149 34 44))
;=> (44)
```



* 2.18

리스트를 인자로 받아, 그 원소들의 순서를 뒤집는 reverse.

```scheme

(define (reverse list)
  (define (reverse-iter seq acc)
    (if (null? seq)
        acc
        (reverse-iter (rest seq) (cons (first seq) acc))))
  (reverse-iter list nil))


(reverse (list 1 4 9 16 25))
;=> (25 16 9 4 1)

```



* 2.19 pass

```scheme
;2.19-------------------------
(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

;(cc 100 us-coins) ; 292
(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))
;first-denomination
(define (first-denomination list)
  (car list))
;except-first-denomination
(define (except-first-denomination list)
  (cdr list))
;no-more?
(define (no-more? list)
  (null? list))

(cc 100 us-coins)


292
>


리스트 순서를 섞어도 답은 똑같이 나오나

http://nosyu.pe.kr/1315

에서 보면 결과를 도출해내는 시간은 차이가 난다고 나왔다.
```


* 2.20

`.`을 활용, 여러 인자를 받는 것을 연습.
하나 이상의 인자를 받고, 첫번째 인자가 홀수면 홀수들만 반환, 짝수면 짝수들만 반환하는 same-parity

```scheme
(define (same-parity fst . rst)
  (if (odd? fst)
      (filter odd? (cons fst rst))
      (filter even? (cons fst rst))))

(same-parity 1 2 3 4 5 6 7)
;=> (1 3 5 7)

(same-parity 2 3 4 5 6 7)
;=> (2 4 6)
```



### 리스트 매핑.
map : 프로시저와, 리스트를 인자로 받아, 리스트의 각 원소마다 해당 프로시져를 적용시킨 결과를 반환한다.

```scheme
(define (map proc items)
  (if (null? items)
    nil
    (cons (proc (first items)
          (map proc (rest items))))))
```

`scale-list`를 `map`을 써서 구현.

```scheme
(define (scale-list items factor)
  (if (null? items)
    nil
    (cons (* (first items) factor)
          (scale-list (rest items) factor))))


(define (scale-list items factor)
  (map (lambda (x) (* x factor)
       items)))
```




* 2.21

square-list 구현.

```scheme
(define (square x) (* x x))

(define (square-list items)
  (if (null? items)
      nil
      (cons (square (first items))
            (square-list (rest items)))))

(define (square-list items)
  (map square items))

(square-list (list 1 2 3 4))
;=> (1 4 9 16)
```

* 2.22 pass

앞선 `square-list`를 iterate형식으로 풀어쓰기.

```scheme
처음부분은
  (cons (square (car things))
        answer)
이 부분 때문에 원소가 역순으로 배치된다.

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (iter items nil))

(square-list (list 1 2 3 4))
;=> (16 9 4 1)




두번째부분은
list끼리 합쳐야 하는데 pair끼리 합쳐서 그렇다.

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))

(square-list (list 1 2 3 4))
;=> ((((() . 1) . 4) . 9) . 16)

```


* 2.23

`map`처럼 sequence를 순회하되, 결과값으로 list를 반환하지 않아도 되는 `for-each`구현.

```scheme
(define (for-each fn seq)
  (if (null? seq)
    nil
    (let ()
       (fn (car seq))
       (for-each fn (cdr seq)))))

(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))
;>> 57
;>> 321
;>> 88
```


## 2.2.2 계층 구조. - 139p
http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-15.html#%_sec_2.2.2

cons cell을 엮어, tree구조를 만들 수 있다.

```scheme
(cons (list 1 2)
      (list 3 4))
```

![](http://mitpress.mit.edu/sicp/full-text/book/ch2-Z-G-15.gif)

![](http://mitpress.mit.edu/sicp/full-text/book/ch2-Z-G-16.gif)


```scheme
(define (count-leaves x)
  (cond ((null? x)       0)
        ((not (pair? x)) 1)
        (else            (+ (count-leaves (car x)
                            (count-leaves (cdr x)))))))
```

* 2.24

```scheme
(list 1
  (list 2
    (list 3 4)))
```

를 계산한다고 할때, 실행기가 계산한 값을 어떻게 찍어내는지?, 화살표구조로 나타내보면?, 나무꼴로 그려보면?

http://wqzhang.wordpress.com/2009/06/19/sicp-exercise-2-24/


* 2.25 pass

다음정의에서, 7을 뽑아내려면, car와 cdr을 어떻게 조합할 것인가?

```scheme
(define A (list 1 3 (list 5 7) 9)) ; (1 3 (5 7) 9)
(define B (list (list 7)))         ; ((7))

;; (1 (2 (3 (4 (5 (6 7))))))
(define C (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))



(car (cdr (car (cdr (cdr A)))))
;=> 7

(car (car B))
;=> 7

(car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr C))))))))))))
;=> 7
```


* 2.26

다음 표현식 결과값 생각해보기.

```scheme
(define x (list 1 2 3))
(define y (list 4 5 6))

(append x y)
;=> (1 2 3 4 5 6)

(cons x y)
;=> ((1 2 3) 4 5 6)

(list x y)
;=> ((1 2 3) (4 5 6))
```


* 2.27

`reverse`프로시저를 수정하여, 리스트를 인자로 받는 `deep-reverse`프로시져 구현.

```scheme
(define x (list (list 1 2) (list 3 4)))
;=> ((1 2) (3 4))


(define (reverse seq)
  (list (cadr seq) (car seq)))

(reverse x)
;=> ((3 4) (1 2))

(define (deep-reverse seq)
  (list (reverse (car (reverse seq)))
        (reverse (cadr (reverse seq)))))

(deep-reverse x)
;=> ((4 3) (2 1))
```


* 2.28
TODO(eunpyoung.kim)


```scheme
(define X (list (list 1 2) (list 3 4)))
;=> ((1 2) (3 4))


(define (fringe x)
  (cond ((null? x) nil)

        ((pair? x) (append (fringe (car x))
                           (fringe (cdr x))))

        (else      (list y))))


(fringe X)
;=> (1 2 3 4)


(fringe (list X X))
;=> (1 2 3 4 1 2 3 4)
```


* 2.29

```scheme
;; a
(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

(define (left-branch mobile)
  (car mobile))
(define (right-branch mobile)
  (cadr mobile))

(define (branch-length branch)
  (car branch))
(define (branch-structure branch)
  (cadr branch))


;; b
(define (total-weight mobile)
  (+ (branch-weight (left-branch mobile))
     (branch-weight (right-branch mobile))))

(define (branch-weight branch)
  (let ((weight (branch-structure branch)))
    (cond ((pair? weight) (total-weight weight))
          (else weight))))


;; c
(define (branch-torque branch)
  (* (branch-length branch) (branch-weight branch)))

(define (mobile-is-Balanced? mobile)
  (or (not (pair? mobile))
      (let ((right (right-branch mobile))
            (left (left-branch mobile)))
        (and (not (null? (cdr mobile)))
             (= (branch-torque left) (branch-torque right))
             (mobile-is-Balanced? (branch-structure right))
             (mobile-is-Balanced? (branch-structure left))))))


;; d
(define (make-mobile left right)
  (cons left right))
(define (make-branch length structure)
  (cons length structure))

;; cadr이였던 부분에서 cdr로 바꾸면된다
(define (right-branch mobile)
  (cdr mobile))
(define (branch-structure branch)
  (cdr branch))
```

* 2.30

```scheme
(define (square-tree tree)
  (cond ((null? tree)       nil)
        ((not (pair? tree)) (* tree tree))
        (else (cons (square-tree (car tree))
                    (square-tree (cdr tree))))))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))
;=> (1 (4 (9 16) 25) (36 49))


(define (square-tree tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (square-tree sub-tree)
             (* sub-tree sub-tree)))
       tree))


(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))
;=> (1 (4 (9 16) 25) (36 49))
```

* 2.31

```scheme
(define (square x) (* x x))

(define (square-tree tree) (tree-map square tree))

(define (tree-map how tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (square-tree sub-tree)
             (how sub-tree)))
       tree))


(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))
;=> (1 (4 (9 16) 25) (36 49))
```

* 2.32

```scheme
(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s)))
            (make-subset (lambda (x) (cons (car s) x))))
        (append rest (map make-subset rest)))))

(subsets (list 1 2 3))
;=> (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))


;; (subsets (list 1 2 3))
;; (1 2 3)에서
;; (2 3)은 앞으로 붙게되고
;; 뒤의 map과정은 (2 3)이 (1)과 cons해서
;; ((2 3) (1 2 3))이런 형태가 되고
;; rest가 재귀이기 때문에
;; (map앞의 재귀  (2 3)  map뒤의 재귀 (1 2 3))
;; 이런 형태로 된다.
```

## 2.2.3 공통 인터페이스로써 차례열의 쓰임세. - 147p
http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-15.html#%_sec_2.2.3

converntional interface(공통 인터페이스)의 쓰임세를 살펴보자.

http://qerub.se/clojure-macros-for-scheme


![](http://mitpress.mit.edu/sicp/full-text/book/ch2-Z-G-17.gif)

* 첫번째
 - 나뭇잎을 모두 차례대로 늘어놓고 - enumerate
 - 홀수만을 골라내               - filter
 - 하나하나 제곱한 다음에         - map
 - 0부터 차례대로 + 한다          - accumulate


* 두번째
 - 0부터 n까지 정수들을 늘어놓고           - enumerate
 - 수마다 피보나치 수를 계산한 다음에       - map
 - 짝수만 골라서                          - filter
 - 빈 리스트에서, 차례대로 cons를 수행한다. - accumulate


```scheme
(define (filter predicate sequence)
  (cond ((null? sequence) nil
        ((predicate (car sequence))
          (cons (car sequence)
                (filter predicate (cdr sequence)))
        (else
          (filter predicate (cdr sequence)))))))

(filter odd? (list 1 2 3 4 5))
;=> (1 3 5)

(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))

(accumulate + 0 (list 1 2 3 4 5))
;=> 15


(accumulate cons nil (list 1 2 3 4 5))
;=> (1 2 3 4 5)
```


```scheme
(define (sum-odd-square tree)
  (accumulate + 0
    (map square
      (filter odd?
        (enumerate-tree
          tree)))))


(define (sum-odd-square tree)
  (->> tree
       (enumerate-tree)
       (filter odd?)
       (map square)
       (accumulate + 0)))
```

* 154p 15)
 - Richard waters, 1979년 포트란 프로그램을 자동분석 - map, filter, accumulate로 풀어내는 프로그램 개발
 - Fortran Scientific Subroutine Package에 들어있는 코드 중 90%가 위 패러다임에 들어맞는 사실을 밝혀냄.



* 2.33 pass

빈칸체우기

```scheme
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (square x) (* x x))

(map square (list 1 2 3 4 5))
;=> (1 4 9 16 25)

(append (list 1 2 3) (list 4 5))
;=> (1 2 3 4 5)

(length (list 1 2 3 4 5))
;=> 5


;===============================


(define (map-1 p sequence)
  (accumulate (lambda (x y)
                (cons (p x) y))
              nil sequence))


(define (append-1 seq1 seq2)
  (accumulate cons seq2 seq1))


(define (length-1 sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

(map-1 square (list 1 2 3 4 5))
;=> (1 4 9 16 25)

(append-1 (list 1) (list 2 3))
;=> (1 2 3 4 5)

(length-1 (list 1 2 3 4 5))
;=> 5
```


* 2.34 pass

호너의 규칙

```scheme
;; ref: http://nosyu.pe.kr/1338

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
(define (square x) (* x x))

;===============================

(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms)
                (+ (* x higher-terms) this-coeff))
              0
              coefficient-sequence))

(horner-eval 2 (list 1 3 0 5 0 1))
;=> 79
```

* 2.35

accumulate를 써서, 2.2.2절에 나온 `count-leaves`를 재정의.

```scheme
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

;===============================

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))
(count-leaves (list 1 2 (list 3 4) (list 5 (list 6)) 7))
;=> 7


;===============================

(define (count-leaves t)
  (accumulate (lambda (x y) (+ x y))
              0
              (map (lambda (x)
                     (if (pair? x)
                         (count-leaves x)
                         1))
                   t)))
(count-leaves (list 1 2 (list 3 4) (list 5 (list 6)) 7))
;=> 7
```


* 2.36

중첩 sequence를 인자로 받는 `accmulate-n정의.

```scheme
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
;===============================
(define s (list (list  1  2  3)
                (list  4  5  6)
                (list  7  8  9)
                (list 10 11 12)))

(define (get-front seqs)
  (if (pair? seqs)
      (cons (caar seqs) (get-front (cdr seqs)))
      nil))

(define (get-end seqs)
  (if (pair? seqs)
      (cons (cdar seqs) (get-end (cdr seqs)))
      nil))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (get-front seqs))
            (accumulate-n op init (get-end seqs)))))

(accumulate-n + 0 s)
;=> (22 26 30)
```


* 2.37 pass

```scheme
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
;===============================
(define (get-front seqs)
  (if (pair? seqs)
      (cons (caar seqs) (get-front (cdr seqs)))
      nil))
(define (get-end seqs)
  (if (pair? seqs)
      (cons (cdar seqs) (get-end (cdr seqs)))
      nil))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (get-front seqs))
            (accumulate-n op init (get-end seqs)))))
;===============================
(define m (list (list 1 2 3 4)
                (list 4 5 6 6)
                (list 6 7 8 9)))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(dot-product (car m) (cadr m))
;=> 5

(define (matrix-*-vector m v)
  (map (lambda (x)
         (dot-product v x))
          m))

(matrix-*-vector m (car m))
;=> (30 56 80)


(define (transpose mat)
  (accumulate-n cons nil mat))

(transpose m)
;=> ((1 4 6) (2 5 7) (3 6 8) (4 6 9))


(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x)
           (matrix-*-vector cols x))
            m)))
(matrix-*-matrix m (transpose m))
;=> ((30 56 80) (56 113 161) (80 161 230))

(matrix-*-matrix (transpose m) m)
;=> ((53 64 75 82) (64 78 92 101) (75 92 109 120) (82 101 120 133))

;; 우오오 살짝 감동먹음.



;; 음.. 이날의 나는 뭐에 감동을 먹었던 걸까?
```


* 2.38

```scheme
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence))))
)
;========================
(define fold-right accumulate)

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(fold-right / 1 (list 1 2 3))
;=> 1 1/2
(fold-left / 1 (list 1 2 3))
;=> 1/6

(fold-right list nil (list 1 2 3))
;=> (1 (2 (3 ())))
(fold-left list nil (list 1 2 3))
;=> (((() 1) 2) 3)

(fold-right * 1 (list 1 2 3))
;=> 6
(fold-left * 1 (list 1 2 3))
;=> 6

(fold-right + 0 (list 1 2 3))
;=> 6
(fold-left + 0 (list 1 2 3))
;=> 6

```

* 2.39

2.3.8에 나온 `fold-right`, `fold-left`로 `reverse`프로시저 정의.

```scheme
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

;========================

(define fold-right accumulate)

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(define (reverse sequence)
  (fold-right (lambda (x y)
                (append y (list x)))
              nil sequence))
(reverse (list 1 2 3 4 5))
;=> (5 4 3 2 1)


(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))

(reverse (list 1 2 3 4 5))
;=> (5 4 3 2 1)
```


### 겹친 맵핑

정수 n, i, j가 있을때, i <= j < i <= n을 만족하고, i +j의 값이 소수가 되는 (i, j)의 모든 순서쌍을 구하기.

n = 6

|       |               |
|-------|---------------|
| i     | 2 3 4 4 5 6 6 |
| j     | 1 2 1 3 2 1 5 |
| i + j | 3 5 5 7 7 7 11|


```scheme
(->> (enuerate-interval 1 n)
     (map (lambda (i)
            (->> (enumerate-interval 1 (- i 1))
                 (map (lambda (j) (list i j))))))
     (accumulate append nil))


(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))


(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (->> (enuerate-interval 1 n)
       (flatmap (lambda (i)
                  (->> (enumerate-interval 1 (- i 1))
                       (map (lambda (j) (list i j))))))
       (filter-prime-sum?)
       (map make-pair-sum)))
```



* 2.40 pass

정수 n을 인자로 받아서, `1 <= j < j <= n`을 만족하는, (i,j)쌍의 차례열을 뽑아낼 수 있도록 `unique-pairs`프로시저 정의.


```scheme
(define (smallest-divisor n)
  (find-divisor n 2))
(define (next test-divisor)
  (if (= (remainder test-divisor 2) 0)
      (+ test-divisor 1)
      (+ test-divisor 2)))

(define (square n)
  (* n n))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))
;========================
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))
;========================
(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))
;========================
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
;========================
(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
               (flatmap
                (lambda (i)
                  (map (lambda (j) (list i j))
                       (enumerate-interval 1 (- i 1))))
                (enumerate-interval 1 n)))))
(prime-sum-pairs 6)
;=> ((2 1 3) (3 2 5) (4 1 5) (4 3 7) (5 2 7) (6 1 7) (6 5 11))

;========================

(define (permutations s)
  (if (null? s)
      (list nil)
      (flatmap (lambda (x)
                 (map (lambda (p) (cons x p))
                      (permutations (remove x s))))
               s)))
(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence))

(permutations (list 1 2 3))
;=> ((1 2 3) (1 3 2) (2 1 3) (2 3 1) (3 1 2) (3 2 1))

(define (make-pair pair)
  (list (car pair) (cadr pair)))
(define (unique-pairs n)
  (map make-pair
       (flatmap
        (lambda (i)
          (map (lambda (j) (list i j))
               (enumerate-interval 1 (- i 1))))
        (enumerate-interval 1 n))))
(unique-pairs 10)
=> ((2 1)
    (3 1) (3 2)
    (4 1) (4 2) (4 3)
    (5 1) (5 2) (5 3) (5 4)
    (6 1) (6 2) (6 3) (6 4) (6 5)
    (7 1) (7 2) (7 3) (7 4) (7 5) (7 6)
    (8 1) (8 2) (8 3) (8 4) (8 5) (8 6) (8 7)
    (9 1) (9 2) (9 3) (9 4) (9 5) (9 6) (9 7) (9 8)
    (10 1) (10 2) (10 3) (10 4) (10 5) (10 6) (10 7) (10 8) (10 9))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
               (unique-pairs n))))
(prime-sum-pairs 6)
;=> ((2 1 3) (3 2 5) (4 1 5) (4 3 7) (5 2 7) (6 1 7) (6 5 11))
```


* 2.41

어떤 정수, n보다 작거나 n과 같은, 서로 다른 양의 정수 i, j, k가 있다고 할때, 그 합을 s라 할때.
n과 s를 받아, (i, j, k)쌍을 뽑는 프로시져 구현.


```scheme
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))


(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

;========================
(define (make-triple-pair pair)
  (list (car pair) (cadr pair) (caddr pair)))

(define (triple-pairs n)
  (flatmap (lambda (i)
             (flatmap (lambda (j)
                        (map (lambda (k) (list i j k))
                             (enumerate-interval 1 (- j 1))))
                      (enumerate-interval 1 (- i 1))))
           (enumerate-interval 1 n)))

(triple-pairs 6)
;=> ((3 2 1)
     (4 2 1) (4 3 1) (4 3 2)
     (5 2 1) (5 3 1) (5 3 2) (5 4 1) (5 4 2) (5 4 3)
     (6 2 1) (6 3 1) (6 3 2) (6 4 1) (6 4 2) (6 4 3) (6 5 1) (6 5 2) (6 5 3) (6 5 4))

(define (triple-pair-found-sum pair-num sum)
  (filter (lambda (x)
            (= sum (accumulate + 0 x)))
          (triple-pairs pair-num)))

(triple-pair-found-sum 6 10)
;=> ((5 3 2) (5 4 1) (6 3 1))
```

* 2.42, 2.43 pass

```scheme
(define (1+ num) (+ num 1))
(define (1- num) (- num 1))

(define null '())
(define nil null)
(define empty-board null)

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (adjoint-position y x lst)
  (append lst (list (cons x y))))

(define (nth n lst)
  (list-ref lst n))

(define (safe? col pos-lst)
  (let ((queen (nth (1- col) pos-lst))
        (other-queens (filter (lambda (p)
                                (not (= col (car p))))
                              pos-lst)))
    (safe-queen? queen other-queens)))

(define (attack-able? pos-a pos-b)
  (let ((ax (car pos-a))
        (ay (cdr pos-a))
        (bx (car pos-b))
        (by (cdr pos-b)))
    (or (= ax bx)
        (= ay by)
        (= (abs (- ax bx))
           (abs (- ay by))))))

(define (safe-queen? queen other-queens)
  (null? (filter (lambda (other-queen)
                   (attack-able? other-queen queen))
                 other-queens)))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter (lambda (positions)
                  (safe? k positions))
                (flatmap (lambda (rest-of-queens)
                           (map (lambda (new-row)
                                  (adjoint-position new-row k rest-of-queens))
                                (enumerate-interval 1 board-size)))
                         (queen-cols (1- k))))))
  (queen-cols board-size))


(queens 4)
;=> (((1 . 2) (2 . 4) (3 . 1) (4 . 3)) ((1 . 3) (2 . 1) (3 . 4) (4 . 2)))
```



## 2.2.4 연습 : 그림 언어 - 165p pass
http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-15.html#%_sec_2.2.4


* 2.44

```scheme
(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (1- n))))
        (below painter (beside smaller smaller)))))

(paint (up-split  einstein 4))
```

* 2.45

```scheme
(define (split fn1 fn2)
  (lambda (painter)
    (fn1 painter (fn2 painter painter))))

(define right-split (split beside below))
(define up-split (split below beside))
```


* 2.46

```scheme
(define (make-vect x y)
  (cons x y))

(define (xcor-vect vect)
  (car vect))

(define (ycor-vect vect)
  (cdr vect))

(define (vect-op op v1 v2)
  (let ((x1 (xcor-vect v1))
        (y1 (ycor-vect v1))
        (x2 (xcor-vect v2))
        (y2 (ycor-vect v2)))
    (make-vect (op x1 x2) (op y1 y2))))

(define (add-vect v1 v2)
  (vect-op + v1 v2))

(define (sub-vect v1 v2)
  (vect-op - v1 v2))

(define (scale-vect n vect)
  (vect-op * vect (make-vect n n)))
```

* 2.47

```scheme
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (cadr frame))

(define (edge2-frame frame)
  (caddr frame))

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (origin-frame frame)
  (car frame))

(define (edge1-frame frame)
  (cadr frame))

(define (edge2-frame frame)
  (cddr frame))
```

* 2.48
* 2.49
* 2.50
* 2.51
* 2.52

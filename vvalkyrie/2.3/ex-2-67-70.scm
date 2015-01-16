; ex 2.67 - 2.70

; expressions

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))

(define (weight-leaf x) (caddr x))

(define (symbols tree)
  (if (leaf? tree)
    (list (symbol-leaf tree))
    (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
    (weight-leaf tree)
    (cadddr tree)))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))

(define (right-branch tree) (cadr tree))

; decoding

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit -- CHOOSE-BRANCH" bit))))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
      '()
      (let ((next-branch
              (choose-branch (car bits) current-branch)))
        (if (leaf? next-branch)
          (cons (symbol-leaf next-branch)
                (decode-1 (cdr bits) tree))
          (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

; set

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
    '()
    (let ((pair (car pairs)))
      (adjoin-set (make-leaf (car pair)
                             (cadr pair))
                  (make-leaf-set (cdr pairs))))))

; ex 2.67

(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                    (make-leaf 'B 2)
                    (make-code-tree (make-leaf 'D 1)
                                    (make-leaf 'C 1)))))
;;=> ((leaf A 4) ((leaf B 2) ((leaf D 1) (leaf C 1) (D C) 2) (B D C) 4) (A B D C) 8)

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

(decode sample-message sample-tree)
;;=> (A D A B B C A)

; ex 2.68

(define (element-of-set? x set)
  (cond ((null? set) #f)
        ((equal? x (car set)) #t)
        (else (element-of-set? x (cdr set)))))

(define (is-there? x set)
  (if (leaf? set)
    (eq? x (symbol-leaf set))
    (element-of-set? x (symbols set))))

(define (encode-symbol x tree)
  (cond ((is-there? x (left-branch tree))
         (if (leaf? (left-branch tree))
           (list 0)
           (cons 0 (encode-symbol x (left-branch tree)))))
        ((is-there? x (right-branch tree))
         (if (leaf? (right-branch tree))
           (list 1)
           (cons 1 (encode-symbol x (right-branch tree)))))
        (else (error "bad symbol -- ENCODE-SYMBOL" x))))

(define (encode message tree)
  (if (null? message)
    '()
    (append (encode-symbol (car message) tree)
            (encode (cdr message) tree))))

(encode '(A D A B B C A) sample-tree)
;;=> (0 1 1 0 0 1 0 1 0 1 1 1 0)

; ex 2.69

(define (successive-merge set)
  (if (null? (cdr set))
    (car set)
    (successive-merge
      (adjoin-set ;; <!!>
        (make-code-tree (car set) (cadr set))
        (cdr (cdr set))))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(successive-merge (make-leaf-set '((D 1) (C 1) (A 4) (B 2))))
;;=> ((leaf A 4) ((leaf B 2) ((leaf C 1) (leaf D 1) (D C) 2) (B D C) 4) (A B D C) 8)

; ex 2.70

(define rock-words
  '((a 2) (boom 1) (get 2) (job 2) (na 16) (sha 3) (yip 9) (wah 1)))

(define rock-words-tree
  (generate-huffman-tree rock-words))
;;=> ((leaf na 16) ((leaf yip 9) (((leaf a 2) ((leaf wah 1) (leaf boom 1) (wah boom) 2) (a wah boom) 4) ((leaf sha 3) ((leaf job 2) (leaf get 2) (job get) 4) (sha job get) 7) (a wah boom sha job get) 11) (yip a wah boom sha job get) 20) (na yip a wah boom sha job get) 36) 

(define rock-lyrics
  '(get a job
    sha na na na na na na na na
    get a job
    sha na na na na na na na na
    wah yip yip yip yip yip yip yip yip yip
    sha boom))

(encode rock-lyrics rock-words-tree)
;;=> (1 1 1 1 1 1 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0 0 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 1 0 1 1 0 1 1)
;; (84 bits)

;; in the case of encoding with fixed-length code,
;; each word requires 3-bit.
;; rock-lyrics has 36 words, so 3 x 36 = 108 bits required minimally.

(decode (encode rock-lyrics rock-words-tree) rock-words-tree)
;;=> (get a job sha na na na na na na na na get a job sha na na na na na na na na wah yip yip yip yip yip yip yip yip yip sha boom)

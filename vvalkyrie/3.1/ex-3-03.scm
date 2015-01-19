; ex 3.3

(define (make-account balance passwd)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance (- balance amount))
             balance)
      "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (incorrect-passwd amount)
    "Incorrect password")
  (define (dispatch p m)
    (if (eq? p passwd)
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            (else (error "Unknown request -- MAKE-ACCOUNT" m)))
      (incorrect-passwd)))
  dispatch)

(define acc (make-account 100 'my-passwd))

((acc 'my-passwd 'withdraw) 60)

((acc 'your-passwd 'deposit) 50)

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
  (define (call-the-cops amount)
    "Call the Cops!")
  (let ((ntrials 0))
    (define (dispatch p m)
      (if (eq? p passwd)
        (cond ((eq? m 'withdraw) withdraw)
              ((eq? m 'deposit) deposit)
              (else (error "Unknown request -- MAKE-ACCOUNT" m)))
        (begin
          (set! ntrials (+ ntrials 1))
          (if (>= ntrials 7)
            call-the-cops
            incorrect-passwd))))
    dispatch))

(define acc (make-account 100 'my-passwd))

((acc 'my-passwd 'withdraw) 60)

((acc 'your-passwd 'deposit) 50)

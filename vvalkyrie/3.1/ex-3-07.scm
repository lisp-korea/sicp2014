; ex 3.7

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
      incorrect-passwd))
  dispatch)

(define (make-joint acc passwd shared-passwd)
  (define (incorrect-passwd amount)
    "Incorrect password")
  (define (dispatch p m)
    (if (eq? p shared-passwd)
      (acc passwd m)
      incorrect-passwd))
  dispatch)

(define peter-acc (make-account 100 'open-sesame))

(define paul-acc
  (make-joint peter-acc 'open-sesame 'rosebud))

((peter-acc 'open-sesame 'withdraw) 10)
;;=> 90

((paul-acc 'rosebud 'withdraw) 10)
;;=> 80

((paul-acc 'open-sesame 'withdraw) 10)
;;=> "Incorrect password"

((peter-acc 'rosebud 'withdraw) 10)
;;=> "Incorrect password"

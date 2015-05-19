#연습문제 5.20 
#아래처럼 만들어 놓은 리스트 구조를 그림 5.14처 럼 상자와 포인터로 나타내 
#고 메모리 벡터로도 나타내라. 여기서, 각 그림은 pl 이라는free 포인터로 시 
#작한다. 
#(define x (cons  1  2)) 
#(define y (list  x  x)) 
#free의 마지막 값은 무엇인가? x와 y 값을 나타내는 포인터는 무엇인가?
               +-+-+                           +-+-+
            2  |.|.|-------------------------->|.|/|
               +-+-+                         3 +-+-+
                |                               |
                |          +--------------------+
                |          V
                | 1 (*)   +-+-+                 
                +-------->|.|.|
                          +-+-+
                           | | 
                           V V 
                        +-+   +-+
                        |1|   |2|
                        +-+   +-+

               (*) indicates the index in memory
+----------+----+----+----+----+----+----+-
| Index    |  0 |  1 |  2 |  3 |  4 |  5 | 
|----------+----+----+----+----+----+----+-
| the-cars |    | n1 | p1 | p1 |    |    | 
|----------+----+----+----+----+----+----+-
| the-cdrs |    | n2 | p3 | e0 |    |    | 
+----------+----+----+----+----+----+----+-

free의 마지막 값 : p4
x를 나타내는 포인터 : p1
y를 나타내는 포인터 : p3?

#연습문제 5.21 
#아래 프로시저로 레지스터 기계를 만들어라. 리스트 구조의 메모리 연산은 기 
#계의 기본 연산으로 쓸 수 있다고 가정하자. 
#a. 자기를 부르는recursive count-leaves : 
#(define (count-leaves tree) 
#(cond ((null?  tree) 0) 
#((not (pair?  tree))  1) 
#(else (+ (count-leaves (car tree)) 
#(count-leaves (cdr tree))))))

#b. 자기를 몇 번이나 부르는지 셀 수 있는 count-leaves :
#(define (count-leaves tree) 
#(define (count-iter tree n) 
#(cond ((null?  tree) n) 
#((not (pair?  tree))  (+  n 1)) 
#(else (count-iter (cdr tree)
#(count-iter (car tree) n)))))
#(count-iter tree 0))


 ;; a. 
 (define (not-pair? lst) 
   (not (pair? lst))) 
  
 (define count-leaves 
   (make-machine 
    `((car ,car) (cdr ,cdr) (null? ,null?) 
                 (not-pair? ,not-pair?) (+ ,+)) 
    '( 
      start 
        (assign continue (label done)) 
        (assign n (const 0)) 
      count-loop 
        (test (op null?) (reg lst)) 
        (branch (label null)) 
        (test (op not-pair?) (reg lst)) 
        (branch (label not-pair)) 
        (save continue) 
        (assign continue (label after-car)) 
        (save lst) 
        (assign lst (op car) (reg lst)) 
        (goto (label count-loop)) 
      after-car 
        (restore lst) 
        (assign lst (op cdr) (reg lst)) 
        (assign continue (label after-cdr)) 
        (save val) 
        (goto (label count-loop)) 
      after-cdr 
        (restore n) 
        (restore continue) 
        (assign val 
                (op +) (reg val) (reg n)) 
        (goto (reg continue)) 
      null 
        (assign val (const 0)) 
        (goto (reg continue)) 
      not-pair 
        (assign val (const 1)) 
        (goto (reg continue)) 
      done))) 
  
 ;; b. 
  
 (define count-leaves 
   (make-machine 
    `((car ,car) (cdr ,cdr) (pair? ,pair?) 
                 (null? ,null?) (+ ,+)) 
    '( 
      start 
        (assign val (const 0)) 
        (assign continue (label done)) 
        (save continue) 
        (assign continue (label cdr-loop)) 
      count-loop 
        (test (op pair?) (reg lst)) 
        (branch (label pair)) 
        (test (op null?) (reg lst)) 
        (branch (label null)) 
        (assign val (op +) (reg val) (const 1)) 
        (restore continue) 
        (goto (reg continue)) 
      cdr-loop 
        (restore lst) 
        (assign lst (op cdr) (reg lst)) 
        (goto (label count-loop)) 
      pair 
        (save lst) 
        (save continue) 
        (assign lst (op car) (reg lst)) 
        (goto (label count-loop)) 
      null 
        (restore continue) 
        (goto (reg continue)) 
      done))) 
      
#연습문제 5.22 
#3.3. 1절에 나온 연습문제 3. 12에서 append 프로시저는 두 리스트를 붙여
#새로운 리스트를 만든다. 그리고 append!는 두 프로시저를 잘라 붙인다splice. 
#이 프로시저를 모두 구현한 레지스터 기계를 설계하라. 이것을 설계할 때, 리스 
#트 구조 메모리 연산은 기본 연산후 쓸 수 있다고 치자.

 ; a. append 
  
 (define append-machine 
   (make-machine 
    `((null? ,null?) (cons ,cons) (car ,car) 
                     (cdr ,cdr)) 
    '( 
      start 
        (assign x (reg x))               ; these 2 instruction are only here to 
        (assign y (reg y))               ; initialize the registers.  
        (assign continue (label done))   ; retrun addres 
        (save continue)                  ; save it. 
      append 
        (test (op null?) (reg x)) 
        (branch (label null)) 
        (assign temp (op car) (reg x))   ; push car as the arg to cons. 
        (save temp) 
        (assign continue (label after-rec)) ;return address for procedure call. 
        (save continue)                  ; push the return address 
        (assign x (op cdr) (reg x))      ; arg for recursive call to append. 
        (goto (label append))            ; recursive call to append. 
      after-rec 
        (restore x)                      ; get the argument pushed by append  
        (assign val (op cons) (reg x) (reg val)) ; consit to the return value 
        (restore continue)               ; get the return address 
        (goto (reg continue))            ; return to caller.  
      null 
        (assign val (reg y))             ; base case, return value = y. 
        (restore continue)               ; get return address 
        (goto (reg continue))            ; return to caller. 
      done))) 
  
 ; b. append! 
  
 (define append!-machine 
   (make-machine 
    `((set-cdr! ,set-cdr!) (null? ,null?) 
                           (cdr ,cdr)) 
    '( 
      start 
        (assign x (reg x))               ; as before just initiailze the regs. 
        (assign y (reg y)) 
        (assign temp1 (reg x))           ; must use temp to avoid changing x.  
        (goto (label last-pair)) 
      append! 
        (assign temp (op set-cdr!) (reg temp1) (reg y)) ;set-cdr! returns an 
        (goto (label done))              ; unspecified value, that we put in temp. 
      last-pair                          ; we want the side effect. 
        (assign temp (op cdr) (reg temp1)) ; test if (cdr temp1 is null) 
        (test (op null?) (reg temp))     ; if so, temp1 is the last pair. 
        (branch (label null)) 
        (assign temp1 (op cdr) (reg temp1)) 
      null 
        (goto (label append!))           ; splice the lists. 
      done 
      ))) 

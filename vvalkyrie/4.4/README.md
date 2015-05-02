# 논리로 프로그램 짜기

식 중심 언어 (expression-oriented language):

- 식 (expression)은 컴퓨터에서 계산을 지시하는 단위이다.
- 컴퓨터 계산이 한쪽으로 흘러가도록 입출력 방식을 잘 정의하여 사용한다.

```scheme
(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))

(append (a b) (c d))
;;=> (a b c d)
```

논리 프로그래밍 언어:

- 관계 시스템(constraint system) 기반으로 여러 값 사이의 관계 기반으로 계산하며,
  계산하는 흐름이나 차례가 명확히 드러나지 않는다.
- 기호 패턴 매칭 (symbolic pattern matching) 기법의 하나인 동일화 (unification)
  기법을 적용하여 뛰어난 표현력을 제공한다.

```scheme
;; (append-to-form x y z)

(rule (append-to-form () ?y ?y))

(rule (append-to-form (?u . ?v) ?y (?u . ?z))
      (append-to-form ?v ?y ?z))

; query input
(append-to-form (a b) (c d) ?z)

; query result
(append-to-form (a b) (c d) (a b c d)) ; ?z = (a b c d)
```

## 4.4.1 연역식 정보 찾기

마이크로샤프트의 인사 데이터베이스 (example).
인사 정보가 assertion의 목록 형태로 저장되어 있으며 query로 정보를 찾는다.

```scheme
;; computer division

(address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))
(job (Bitdiddle Ben) (computer wizard))
(salary (Bitdiddle Ben) 60000)
(supervisor (Bitdiddle Ben) (Warbucks Oliver))


(address (Hacker Alyssa P) (Cambridge (Mass Ave) 78))
(job (Hacker Alyssa P) (computer programmer))
(salary (Hacker Alyssa P) 40000)
(supervisor (Hacker Alyssa P) (Bitdiddle Ben))

(address (Fect Cy D) (Cambridge (Ames Street) 3))
(job (Fect Cy D) (computer programmer))
(salary (Fect Cy D) 35000)
(supervisor (Fect Cy D) (Bitdiddle Ben))

(address (Tweakit Lem E) (Boston (Bay State Road) 22))
(job (Tweakit Lem E) (computer technician))
(salary (Tweakit Lem E) 25000)
(supervisor (Tweakit Lem E) (Bitdiddle Ben))


(address (Reasoner Louis) (Sumerville (Pine Tree Road) 80))
(job (Reasoner Louis) (computer programmer trainee))
(salary (Reasoner Louis) 30000)
(supervisor (Reasoner Louis) (Hacker Alyssa P))


;; big wheel (final boss) and his/her secretary

(address (Warbucks Oliver) (Swellesley (Top Heap Road)))
(job (Warbucks Oliver) (administration big wheel))
(salary (Warbucks Oliver) 150000)

(address (Aull DeWitt) (Sumerville (Onion Square) 5))
(job (Aull DeWitt) (administration secretary))
(salary (Aull DeWitt) 25000)
(supervisor (Aull DeWitt) (Warbucks Oliver))


;; acounting division

(address (Scrooge Eben) (Weston (Shady Lane) 10))
(job (Scrooge Eben) (accouting chief accountant))
(salary (Scrooge Eben) 75000)
(supervisor (Scrooge Eben) (Warbucks Oliver))


(address (Cratchet Robert) (Allston (N Harvard Street) 16))
(job (Cratchet Robert) (accouting scrivener))
(salary (Cratchet Robert) 18000)
(supervisor (Cratchet Robert) (Scrooge Eben))


;; role

(can-do-job (computer wizard) (computer programmer))
(can-do-job (computer wizard) (computer technician))
(can-do-job (computer programmer) (computer programmer trainee))
(can-do-job (administration secretary) (administration big wheel))
```

### simple queries

```scheme
;; query
(job ?x (computer programmer))

;; result
(job (Hacker Alyssa P) (computer programmer))
(job (Fect Cy D) (computer programmer))


;; query
(job ?x ?y)

;; result
;; => all (job ...) assertions


;; query
(job ?x (computer ?type))

;; results
(job (Bitdiddle Ben) (computer wizard))
(job (Hacker Alyssa P) (computer programmer))
(job (Fect Cy D) (computer programmer))
(job (Tweakit Lem E) (computer technician))


;; query
(job ?x (computer . ?type))

;; results
(job (Bitdiddle Ben) (computer wizard))
(job (Hacker Alyssa P) (computer programmer))
(job (Fect Cy D) (computer programmer))
(job (Tweakit Lem E) (computer technician))
(job (Reasoner Louis) (computer programmer trainee))
```

### compound query

and, or, not을 이용하여 simple query들을 엮는다.

```scheme
;; and query
(and (job ?person (computer programmer))
     (address ?person ?where))

;; result
(and (job (Hacker Alyssa P) (computer programmer))
     (address (Hacker Alyssa P) (Cambridge (Mass Ave) 78)))
(and (job (Fect Cy D) (computer programmer))
     (address (Fect Cy D) (Cambridge (Amess Street) 3)))

;; or
(or (supervisor ?x (Bitdiddle Ben))
    (supervisor ?x (Hacker Alyssa P)))

;; not
(and (supervisor ?x (Bitdiddle Ben))
     (not (job ?x (computer programmer))))

;; lisp-value
(and (salary ?person ?amount)
     (lisp-value > ?amount 30000))
```

### rule

프로시저 처럼 쿼리를 요약하는 수단이다.

> (rule <conclusion> <body>)

```scheme
(rule (lives-near ?person-1 ?person-2)
      (and (address ?person-1 (?town . ?rest-1))
           (address ?person-2 (?town . ?rest-2))
           (not (same ?person-1 ?person-2))))

(rule (same ?x ?x))

(rule (wheel ?person)
      (and (supervisor ?middle-manager ?person)
           (supervisor ?x ?middle-manager)))

(rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (supervisor ?staff-person ?middle-manager)
               (outranked-by ?middle-manager ?boss))))
```

```scheme
(lives-near ?x (Bitdiddle Ben))

(lives-near (Reasoner Louis) (Bitdiddle Ben))
(lives-near (Aull DeWitt) (Bitdiddle Ben))

(and (job ?x (computer programmer))
     (lives-near ?x (Bitdiddle Ben)))
```

### 프로그램으로서의 논리

쿼리 언어는 규칙에 바탕을 두고 논리에 따라 연역식 추론을
해내는 능력을 갖춘 것이다.

예로 `append` 연산을 밝히는 규칙은 다음과 같다.

- 리스트 y에서 빈 리스트와 y를 append하면 y가 된다.

```scheme
(rule (append-to-form () ?y ?y))
```

- u, v, y, z가 있을 때, v와 y를 append한 결과는 z이며
  (cons u v)와 y를 append하여 (cons u z)가 나온다.

```scheme
(rule (append-to-form (?u . ?v) ?y (?u . ?z))
      (append-to-form ?v ?y ?z))
```

위의 두 규칙을 바탕으로, 다음과 같이 쿼리를 던져 두 리스트를
append한 결과를 알아낼 수 있다.
또한, 규칙을 바탕으로 append하여 (a b c d)를 만들 수 있는
리스트 쌍을 알아낼 수도 있다.

```scheme
(append-to-form (a b) (c d) ?z)
;=>
(append-to-form (a b) (c d) (a b c d))

(append-to-form (a b) ?y (a b c d))
;=>
(append-to-form (a b (c d) (a b c d))

(append-to-form ?x ?y (a b c d))
;=>
(append-to-form () (a b c d) (a b c d))
(append-to-form (a) (b c d) (a b c d))
(append-to-form (a b) (c d) (a b c d))
(append-to-form (a b c) (d) (a b c d))
(append-to-form (a b c d) () (a b c d))
```

## 4.4.2 쿼리 시스템의 동작 방식

쿼리 실행기에 쿼리를 받아 이를 데이터베이스에 들어있는
사실(fact)과 규칙(rule)들을 찾아 매치시키는 기능을 구현해야 하는데,
4.3절의 amb 실행기를 쓰거나 stream 기법을 사용할 수 있다.

쿼리 시스템은 패턴 매칭(pattern matching)과 동일화(unification)이라는
두 연산을 중심으로 구성된다.
패턴 매칭에서는 이 연산이 일람표들의 스트림(streams of frames)으로
구성된 정보를 가지고 쿼리를 어떻게 구현하는 지 살펴본다.
동일화는 규칙을 구현하기 위해 패턴 매칭을 일반화한 기법이다.

### 패턴 매칭

패턴 매처는 데이터가 지정된 패턴에 들어맞는지 알아보는 프로그램이다.

패턴, 데이터, 변수 일람표 (frame)를 받은 후,
이미 일람표에 들어있던 변수 정의를 바탕으로, 받아온 데이터를 지정된
패턴에 맞출 수 있는지 살펴본다. 잘 맞아떨어진다면, 그 과정에서
정의된 패턴 변수를 일람표에 넣고 그 일람표를 값으로 내놓는다.

```
 pattern: (?x ?y ?x)
    data: (a b a)
   frame: <empty>
        |
        v
  [pattern matcher]
        |
        v
frame: ?x -> a, ?y -> b
```

### 변수 일람표들의 스트림

변수 일람표 하나를 받을 때마다, matching process에서는 데이터베이스의
원소를 하나씩 차례대로 살펴본다. 모두 살펴본 다음에는 그 결과가 모여
하나의 스트림을 이룬다.

```
frame    +-------------------+   frame  
input    |                   |   output 
stream   |       query       |   stream 
+------->+    (job ?x ?y)    +------->  
         |                   |          
         |                   |          
         +-------------------+          
                  ^                     
                  | stream of           
                  | assertions          
                  + in data base        
```

### compound query의 경우

and, or 연산의 경우 아래 그림에서와 같이 각 쿼리가 직렬, 또는 병렬로
묶이는 것으로 확장할 수 있다.

처리 성능은 낮은 편으로, and는 최악의 경우 쿼리를 처리하는데 드는
매칭의 수가 모든 쿼리 수에 지수 비례로 늘어날 수 있다.

```
    +----------------------+                  
    |       (and A B)      |                  
    |                      |                  
    |   +---+      +---+   |                  
+-----> | A +----> | B +-------->             
    |   +-+-+      +-+-+   |                  
    |     ^          ^     |                  
    |     |          |     |                  
    |     |----+-----+     |                  
    |          |           |                  
    +----------------------+                  
               |                              
               |                              
               +                              
```

```
      +------------------------+    
      |       (or A B)         |    
      |   +---+                |    
    +---> | A +----------+     |    
    | |   +-+-+          v     |    
    | |     ^        +---+---+ |    
+---+ |     |        | merge +----->
    | |     |        +---+---+ |    
    | |     |  +---+     ^     |    
    +--------> | B +-----+     |    
      |     |  +-+-+           |    
      |     |    ^             |    
      |     +--+-+             |    
      |        |               |    
      +--------|---------------+    
               |
               +                    
```

not의 경우 그 조건을 만족하는 frame을 모두 없애는 filter로 동작한다.

```scheme
(not (job ?x (computer programmer)))
```

filter의 한 종류로, lisp-value도 뒤이어 나오는 predicate에 따라
특정 frame들을 걸러낸다.

### 동일화

쿼리 언어에서 rule을 다루기 위해 패턴 매칭 기능을 확장한 것으로,
패턴 외에 데이터도 변수를 가질 수 있다.
두 개의 패턴을 받아 그 변수 자리에 알맞은 값을 넣어 두 패턴을
같게 만들 수 있는지 없는지를 판단한다.

```
(?x a ?y)
(?y ?z a)

?x => a, ?y => a, ?z => a
```

패턴 매칭이 성공적인 경우 모든 패턴 변수가 정의되고 그 결과는
상수였으나, 동일화의 경우 변수 값이 완전히 결정되지 않는 경우도 있다.

```
(?x a)
((b ?y) ?z)
```

### 규칙 적용하기

```scheme
(lives-near ?x (Hacker Alyssa P))

(rule (lives-near $person-1 $person-2)
  (and (address ?person-1 (?town . $rest-1))
       (address ?person-2 (?town . $rest-2))
			 (not (same $person-1 $person-2))))
```

?person-1을 ?x로, ?person-2를 (Hacker Alyssa P)로 정의한 frame이 나온다.
이 frame에 맞춰 rule의 body에 있는 compound query를 처리한다.
매칭이 성공적으로 끝나면, frame 속에 $person-1의 정의가 들어있고, 이는
곧 ?x와 같다.
그 값을 갖고 처음의 query pattern에서 데이터를 찍어낸다.

쿼리 실행기가 규칙을 적용하는 방법:

- query를 rule에 동일화하는 일이 성공으로 끝나면, 그에 맞춰 처음에
  받았던 frame에 알맞은 정보를 보탠다.
- 확장된 frame에 맞춰 rule의 body를 구성하는 query를 처리한다.

Lisp의 eval/apply 실행기에서 프로시저를 처리하는 방법:

- 프로시저의 매개변수를 받아온 인자값으로 정의하여, 처음 프로시저
  환경을 확장한 일람표를 구성한다.
- 확장된 환경에 맞춰 프로시저의 몸을 이루는 식의 값을 구한다.

### 간단한 쿼리

query pattern과 frame들의 스트림을 받으면, 각 frame에 대해 다음 두
스트림을 만든다.

- 패턴 매처를 가지고 데이터베이스에 있는 모든 assertion에 패턴을
  맞춰보는 과정에서 확장된 frame들의 스트림
- 동일화 함수를 가지고 쓸 수 있는 모든 규칙을 적용하는 과정에서
  확장된 frame들의 스트림

이 두 스트림을 붙여 하나의 스트림을 만든다.

### 쿼리 실행기와 드라이버 루프

**qeval**: 매칭 연산을 다스리는 프로시저로, query 하나와 frame stream
하나를 받아 frame stream 하나를 내놓는다. query의 구조에 따라
특별한 형태 (and, or, not, lisp-value)를 처리하는 프로시저나
간단한 쿼리를 처리하는 프로시저로 넘긴다.

**driver-loop**: 터미널에서 query를 읽으며 그 때마다 query와 빈
frame 하나를 qeval에 인자로 넘기고, 그 결과 frame stream에서
정의된 변수 값을 가지고 처음에 받은 query에 데이터를 화면에
찍어낸다. 또한 assert! 명령을 받으면 데이터베이스에 추가한다.

## 4.4.3 논리 프로그래밍은 수학 논리를 따르는가

쿼리 언어는 수학과 달리 어떤 절차에 따라 논리식을 해석하는 제어구조를
갖추기 때문에 완전히 같다고 할 수 없다.

```scheme
(and (job ?x (computer programmer))
     (supervisor ?x ?y))

(and (supervisor ?x ?y)
     (job ?x (computer programmer))
```

and의 첫 번째 query의 결과 (frame)를 갖고 두 번째 query에 맞춰 전체
데이터베이스를 훑어봐야 한다.

논리 프로그래밍의 목표는 프로그래머가 컴퓨터 계산 문제 하나로 how와
what을 밝히는데 있다. 이를 위해 충분한 표현력, 해석을 위한 단순성을
모두 갖출 수 있도록 수학 논리에서 알맞은 부분을 빌려온다.

### 끝없는 루프

```scheme
(assert! (married Minnie Mickey))

(married Mickey ?who)
;=> (no result)

(assert! (rule (married ?x ?y)
               (married ?y ?x)))

(married Mickey ?who)
;=> (endless loop)
```

### not과 관련된 문제들

```scheme
(and (supervisor ?x ?y)
     (not (job ?x (computer programmer))))

(and (not (job ?x (computer programmer)))
     (supervisor ?x ?y))
```

위 두 쿼리는 같은 결과를 내지 않는다. 두 번째 쿼리의 경우 

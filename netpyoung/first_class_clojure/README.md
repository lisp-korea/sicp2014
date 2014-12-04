# [First Class Function](http://en.wikipedia.org/wiki/First-class_function)

* 컴퓨터 과학에서, 프로그래밍 언어가 function을 first-class citizens로써 다룰 수 있다면, first-class funtions을 지녔다고 말한다.
* first-class functions라는 용어는, 1960년대 중반 [크리스토퍼 스트래치](http://en.wikipedia.org/wiki/Christopher_Strachey)에 의해
처음으로 쓰여졌다(`functions as first-class citizens`).
* first-class functions을 지닌 언어에서, 함수의 [이름](http://en.wikipedia.org/wiki/Identifier)은 특별한 의미를 지니지 않는다.
* 요구조건
  - 함수를 다른 함수의 인자로 넘기기.
  - 함수 자체를 반환하기.
  - 변수에 함수 자체를 할당하기.
  - 자료구조에 함수 자체를 저장하기.
  - 익명 함수(몇몇 언어 이론가(theorists)들의 요구조건)


* [First Class citizen](http://en.wikipedia.org/wiki/First-class_citizen)
  - 프로그래밍 언어 설계에 있어서, first-class citizen은 다른 entity들에 적용 가능한 연산(operation)을 지원하는 entity이다.


## Concepts
### Higher-order functions: passing functions as arguments

```clojure
(defn square
  [x]
  (* x x))

(->> [1 2 3 4 5]
     (map square))
;=> (1 4 9 16 25)
```

### Anonymous and nested functions

```clojure
(->> [1 2 3 4 5]
     (map (fn [x] (* x x))))
;=> (1 4 9 16 25)
```


### Non-local variables and closures

```clojure
(let [a 3
      b 1]
  (->> [1 2 3 4 5]
       (map (fn [x] (+ (* a x) b)))))
;=> (4 7 10 13 16)
```


### Higher-order functions: returning functions as results

```clojure
(defn ret-fn
  []
  (fn [x] (* x x)))

((ret-fn) 2)
;=> 4
```


### Assigning functions to variables

```clojure
(def var1
  (fn [x] (inc x)))

(var1 10)
;=> 11
```


## [Pioneer Profiles - Christopher Strachey](http://toyfab.tistory.com/entry/Pioneer-Profiles-Christopher-Strachey)

* 이론가와는 거리가 먼사람.
* 말 그대로 선구자였던 사람.
* programmer's programmer
* ALCOL60->`CPL(Cambridge Programming Language => Combined Programming Language)`->BCPL->B->C.

* http://ropas.snu.ac.kr/~kwang/quote/strachey.html

```
It has long been my personal view that the separation of practical and theoretical work is artificial and injurious. Much of the practical work done in computing, both in software and in hardware design, is unsound and clumsy because the people who do it have not any clear understanding of the fundamental design principles of their work. Most of the abstract mathematical and theoretical work is sterile because it has no point of contact with real computing. One of the central aims of the Programming Research Group as a teaching and research group has been to set up an atmosphere in which this separation cannot happen.

-----

(번역: 이광근)

나는 우리분야에서 이론과 실제를 떼어놓는 것은 부자연스러울 뿐 아니라 매우 해로운 것이라고 생각해 왔다. 전산분야의 실용적인 작업들은 (하드웨어와 소프트웨어를 막론하고) 무슨 문제를 어떻게 다루고 있는지에 대한 근본적인 이해가 없이 부지런하게만 건설된 것들이기 때문에 위태롭고 어설픈 성과들이 대부분이다. 이론분야에서 이루어놓은 성과들도 진짜 컴퓨팅 현실로 부터 너무나 초연해 있었던 까닭에 현실의 열매를 키워내는 비옥한 토양이 되지 못한 경우가 대부분이다. 우리의 [프로그래밍 연구 그룹]의 주요 목표는 이러한 이론과 실제의 불통이 발생할 수 없는 공부 풍토를 건설하는 것이다.
```

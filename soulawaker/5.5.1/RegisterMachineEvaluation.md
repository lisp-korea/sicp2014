#5 레지스터 기계로 계산하기
+ 여태까지 프로시저가 실행되는 계산 모형을 차례로 살펴보았다.
 - 1장에서 맞바꿈 계산법
 - 3장에서 환경 계산법
 - 4장에서 meta-circular evaluator를 보았다.
   * 특히 여기서 Lisp 언어의 실행방법에 대해 많이 알게 되었다.
   * 하지만 Lisp 시스템의 control이 명확하게 보이지 않으므로 아래의 의문점이 해소되지 않는다.
     * 부분식의 계산 결과가 어떻게 다음식에 전달되는지
     * 재귀 프로세스가 어떤때는 반복 프로세스가 되고 어땐때는 재귀 프로세스가 되는지
   * 이것은 meta-circular evaluator가 Lisp으로 짜여 있기 때문이다.
   * Lisp evaluator의 실행 흐름을 제대로 보려면 Lisp 보다 낮은 수준에서 프로세스가 돌아가는 방법을 알아야 한다.
+ 여기서는 기계어 operation 관점에서 프로세스를 설명한다.
 - register machine은 레지스터의 값을 다루는 instruction을 차례대로 실행한다.
 - register machine instruction은 대체로 어떤 레지스터 값에 간단한 연산을 적용한 결과를 다른 레지스터에 저장하는 내용이다.
 - 여기서 machine language를 설명하지는 않는다.
 - Lisp 프로시저들 중 일부를 돌릴 수 있는 register machine을 설계해 볼 것이다.
 - 기계어 프로그래머 관점이 아닌 하드웨어 설계자 관점에서 register machine을 설계한다.
 - 재귀를 구현하는 메커니즘도 만들어 볼 것이다.
 - register machine 설계를 설명하는 언어도 선보인다.
 - 5.2절에서 모형 기계를 시뮬레이션하는 Lisp 프로그램도 짜본다.
+ register machine의 기본 연산은 대부분 아주 간단하다.
 - 2개의 레지스터에서 값을 꺼내어 더한 다음 다른 레지스터에 넣는 연산은 간단한 하드웨어로 실행할 수 있다.
 - list구조 처리를 위한 car, cdr, cons 같은 메모리 연산은 정교한 저장 장치 할당 메커니즘이 필요하다.
   * 5.3절에서 이들 연산을 기본 연산으로 만드는 공부를 한다.
+ 5.4절은 register machine으로 간단한 프로시저 몇 개를 만든 다음에, 4.1절에서 다룬 meta-circular evaluator로 설명한 알고리즘을 수행하는 register machine을 설계한다.
 - evaluator의 실행 흐름을 뚜렷하게 파악하여 meta-circular evaluator만으로는 일부 밖에 파악되지 않았던 Scheme식의 해석 방식을 이해할 수 있게 된다.
 - 5.5절은 컴파일러를 만든다.
   * 컴파일러는 Scheme으로 짠 프로그램을 register machine으로 만든 evaluator에서 실행가능한 명령어로 번역한다.

##5.1 레지스터 기계 설계하기
+ register machine은 data path와 controller가 반드시 있어야 한다.
 - data path란 register와 연산의 조합이다.
 - controller란 data path에 표현된 연산의 차례를 정하여 순서대로 돌아가게 하는 것이다.

 ###5.1.1 레지스터 기계를 묘사하는 언어
 
 ###5.1.2 기계 디자인에서의 속 내용 감추기
 
 ###5.1.3 서브루틴
 
 ###5.1.4 스택을 이용해 되돌기 구현하기
 
 ###5.1.5 명령어 정리

##5.2 레지스터 기계 시뮬레이터

##5.3 메모리 할당(memory allocation)과 재활용(garbage collection)

##5.4 제어가 다 보이는 실행기

##5.5 번역compilation

+ explicit-control evaluator은 register machine이다.
 - register machine의 controller가 Scheme 프로그램을 실행한다.
 - 여기 5.5에서는 controller가 register machine에서 Scheme 프로그램을 어떻게 실행하는지 살펴본다.
+ explicit-control evaluator는 어떤 Scheme 프로세스도 돌릴 수 있다.
 - evaluator의 controller만 적당하다면 data path로 어떤 계산도 할 수 있다.
+ 범용 컴퓨터 역시 data path로 구성된 register machine이고, 이것의 controller는 register machine language의 evaluator다.
 - register machine language를 기계의 고유언어 내지는 기계어라고 부른다.
 - 기계어로 만든 프로그램은 기계의 data path를 쓰는 명령의 시퀀스다.
   * 명령의 시퀀스는 controller가 아니다. 기계어 프로그램이다.
+ 기계어 기반으로 만들어졌으나 기계어를 보이지 않게 만든 고수준 언어와 레지스터 기계어의 차이를 메우기 위해 2가지 전략이 사용된다.
 1. explicit-control evaluator는 실행 전략을 모두 드러낸다. 
   * 기계어로 만들어진 evaluator는 source language(기계어가 아닌 언어)로 만든 프로그램을 실행하도록 기계를 설정한다.
   * source language의 기본 프로시저들은 기계어로 만든 서브루틴의 라이브러리로 만들어진다.
   * source 프로그램은 데이터 구조로 표현된다.
   * evaluator는 데이터 구조를 따라 움직이며 소스 프로그램을 분석한다.
   * evaluator는 라이브러리에서 적절한 기계어 기본 서브루틴을 불러와 소스 프로그램이 실행해야 할 동작을 시뮬레이트 한다.
 2. 여기서는 또 다른 전략인 compilation을 살펴본다.
   * compiler는 소스 프로그램을 오브젝트 프로그램으로 바꾼다.
   * 오브젝트 프로그램은 기계어로 번역된 것이다. (아마도 오브젝트 프로그램이 instruction 시퀀스인가?)
   * 여기서 만드는 compiler는 Scheme으로 만든 프로그램을 기계어의 instruction 시퀀스로 바꾸고, explicit-control evaluator register machine의 data path에서 돌려본다.
   * evaluator register machine은 Lisp으로 만든 evaluator보다 더 단순하다.
     * 코드로 만든 evaluator는 아직 계산되지 않은 부분을 나타내는 exp, unev 레지스터가 필요했다.
     * 하지만 evaluator machine은 컴파일러가 기계어로 전부 번역한 코드를 사용하기 때문에 위의 레지스터가 필요없다.
     * 이미 번역된 코드를 쓰기 때문에 식의 문법을 다루는 연산도 evaluator machine에서는 필요가 없다.
     * 하지만 컴파일된 코드는 컴파일된 프로시저 객체를 나타내는 기계 연산이 필요하다.
     * 이것은 explicit-control evaluator에는 없었던 연산이다.
+ interpretation과 비교할 때, compilation은 프로그램을 아주 효율적으로 돌아가게 만든다.
 - 비교는 아래의 번역기의 개괄에서 설명한다.
 - interpreter는 서로 대화하면서 프로그램을 개발하고 디버그하는 환경을 제공한다.
   * 수행 중인 프로그램을 실행 시간에 검사하고 고칠 수 있다.
   * 기본적인 명령의 모든 라이브러리가 interpreter에 내장되어 있으므로 디버그하는 동안 새로운 프로그램을 만들거나 추가할 수 있다.
+ compilation과 interpretation의 장점을 취하기 위해 최근의 프로그램 개발 환경은 둘을 혼합하는 방법을 따른다.
 - Lisp interpreter는 대개 그대로 실행한 프로시저와 번역한 프로시저를 서로 불러 쓸 수 있게 되어 있다.
   * 무슨 말이냐면, 디버깅이 끝났다고 판단된 부분은 컴파일을 해서 효율성을 살리고
   * 개발과 디버깅이 진행중인 부분은 interpreter방식으로 돌리는 것이다.
 - 5.5.7절에서 컴파일러를 만들고 난 뒤에, interpreter를 어떻게 통합할 것인지 살펴본다.
 
 ###번역기의 개괄
 + compiler는 interpreter와 구조 및 수행 함수 측면에서 많이 닮아있다.
  - 그러므로 compiler 사용법은 interpreter 사용법과 유사하다.
  - 번역된 코드와 실행된 코드를 연계해서 파악하기 쉽도록 interpreter의 레지스터 사용 관행을 compiler 설계에 반영한다.
    * 그러면 환경은 env 레지스터
    * 인자 리스트는 argl 레지스터
    * 계산할 프로시저는 proc 레지스터
    * 프로시저 계산 결과는 val 레지스터
    * 프로시저가 돌아갈 위치는 continue 레지스터에 배치한다.
  - 컴파일러가 소스 프로그램을 오브젝트 프로그램으로 바꿀 때 수행하는 연산은 본질적으로 interpreter가 소스 프로그램을 실행하는 연산과 같다.
 + 위의 유사점으로 부터 컴파일러를 어떻게 구현해야 할지 감을 잡을 수 있다.
  - 컴파일러는 일단 interpreter가 하는 것처럼 소스 프로그램의 식을 따라가면 된다.
  - 대신 interpreter가 레지스터 명령을 바로바로 수행했던 것과 달리 컴파일러는 레지스터 명령을 차례대로 모으는 것이다.
    * 여기서 모인 명령어들이 오브젝트 코드가 된다.
  - 과연 컴파일 방식이 얼마 효율성이 있다는 것인가?
    * (f 84 96) 식을 계산하는 경우
      * interpreter는 식을 분류해서 이것이 procedure application임을 파악하고, 피연산자 리스트를 검사해서 피연산자가 2개 있다는 것을 파악한다.
      * compiler는 식을 한번만 분석해서 명령문을 만드는데 아래 4개의 명령들이 만들어진다.
        * 연산자를 계산하는 명령
        * 2개의 피연산자를 계산하는 명령
        * 인자 리스트를 모으는 명령
        * proc에 있는 프로시저를 argl에 있는 인자에 적용하는 명령
 + 위에서 설명한 컴파일 방식은 4.1.7절에서 살펴본 interpreter에서 구현한 최적화와 같다.
  - 하지만 컴파일된 코드가 더 효율적일 가능성이 높다.
    * interpreter가 돌아갈 때, interpreter는 임의의 식에도 적용할 수 있는 프로세스를 가져야 한다.
    * 하지만 컴파일 된 코드는 이미 특화된 명령문들을 모아 놓은 것으로, 그 밖의 임의적 상황에 대비할 필요가 없다.
  - 레지스터를 스택에 저장해야하는 경우를 예로 들어보자.
    * interpreter는 식을 계산할 때 우발 상황에 대비해야 한다.
      * 부분식을 계산할 때 나중에 필요한 레지스터를 전부 스택에 저장해 두어야 한다. 부분식에서 어떤 계산이 필요한지 모르기 때문이다.
    * 반면에 compiler는 식의 구조를 분석해서 불필요한 스택 저장 연산을 피하는 컴파일된 코드를 만들어낼 수 있다.
 + (f 84 96)을 처리하는 경우를 생각해 보자.
  - interpreter는 식의 연산자를 계산하기 전에 피연산자와 환경을 담은 레지스터들을 스택에 저장한다.
    * 이제 연산자를 계산하고 그 결과를 val에 담아 두고, 스택에 저장된 레지스터를 다시 가져온다.
    * 이후에 val의 내용을 proc으로 옮긴다.
  - 하지만 위의 식의 연산자 f는 symbol이다. 이는 lookup-variable-value에 의해 계산되며, 어떤 레지스터 변경도 일어나지 않는다.
  - 우리가 만드는 컴파일러는 이런 사실을 이용해서 아래와 같은 코드를 만들어 낸다.
  ```lisp
  (assign proc (op (lookup-variable-value) (const f) (reg env)))
  ```
    * 이 코드는 뭔가를 별도의 스택에 저장하고 다시 가져오는 작업이 없다.
    * 그리고 찾은 값을 바로 proc에 저장한다.
      * 이와 달리 interpreter는 결과를 val에 저장했다가 나중에 proc으로 옮긴다.
 + 컴파일러는 환경에 대한 접근도 최적화할 수 있다.
  - 컴파일러는 코드를 분석해서 어떤 변수가 어떤 일람표frame에 있는지 파악하는 경우가 많다.
    * 이렇게 파악이 되면 lookup-variable-value로 찾지 않아도 해당 변수일람표에서 변수를 바로 건드릴 수 있다.
    * 이러한 변수 접근의 구현방법은 5.5.6절에서 다룬다.
  - 5.5.5절까지는 레지스터와 스택 최적화를 중심으로 다룬다.
    * apply 대신 기본연산 inline을 짜는 것 같은 다른 최적화 방법들도 많이 있다.
    * 여기서는 다른 최적화 방법들까지 다루지는 않는다.
    * 5.5절은 컴파일 프로세스를 간단하게 설명하는 것이 목표다.
  
 ###5.5.1 번역기의 구조
 + 4.1.7절에서 meta-circular evaluator를 변형해서 프로그램 분석작업과 프로그램 실행작업을 따로 처리하게 만들었다.
  - 식을 분석해서 execution procedure를 만드는 것이다. 실행 프로시저는 인자로 환경을 받아서 필요한 연산을 수행한다.
  - 여기서 만들 컴파일러도 4.1.7절의 방법으로 프로그램을 분석한다.
    * 다만 execution procedure를 만드는 대신 instruction을 만드는 것이다.
 + compile 프로시저는 컴파일러의 top-level 프로시저다. 이것과 비슷한 것들로 앞에서 본 것들은 아래 3가지가 있다.
  1. 4.1.1절의 eval 프로시저
  2. 4.1.7절의 analyze 프로시저
  3. 5.4.1절의 explicit-control evaluator의 eval-dispatch 프로시저
    * eval-dispatch 프로시저는 evaluator의 진입 지점을 나타낸다.
  - 컴파일러도 4.1.2절에서 정의한 식-문법 프로시저를 사용한다.
    * 물론 컴파일러도 Scheme으로 만든 프로그램이므로, 식을 다루는 문법 프로시저는 결국 meta-circular evaluator에 쓰인 Scheme 프로시저다.
    * 이와 달리, explicit-control evaluator는 문법 연산을 그 프로그램 말고 register machine 연산으로 쓸 수 있다.
      * 물론 이때도 register machine은 Scheme으로 만들었고, 이것을 시뮬레이션하려면 결국 Scheme프로시저를 쓰게 되긴 한다.
 + compile 프로시저는 번역대상인 식의 문법 타입에 따라 번역한다.
  - 정확히는 문법 타입에 맞는 코드 생성기를 마련해두고 분기처리한다.
  ```lisp
  (define (compile exp target linkage)
    (cond ((self-evaluating? exp)
           (compile-self-evaluating exp target linkage))
          ((quoted? exp) (compile-quoted exp target linkage))
          ((variable? exp)
           (compile-variable exp target linkage))
          ((assignment? exp)
           (compile-definition exp target linkage))
          ((definition? exp)
           (compile-definition exp target linkage))
          ((if? exp) (compile-if exp target linkage))
          ((lambda? exp) (compile-lambda exp target linkage))
          ((begin? exp)
           (compile-sequence (begin-actions exp)
                              target
                              linkage))
          ((cond? exp) (compile (cond->if exp) target linkage))
          ((application? exp)
           (compile-application exp target linkage))
          (else
           (error "Unknown expression type -- COMPILE" exp))))
  ```

  ####타깃과 연결
  + compile 프로시저는 식 이외에 두가지 인자를 더 받는다.
   - compile 프로시저 내부의 코드 생성기들(아마도 compile-로 시작하는)도 식 이외에 target과 linkage를 더 받는다.
     * target은 번역된 코드를 돌려받을 레지스터를 가리킨다.
     * linkage는 linkage descriptor로 번역된 코드가 실행이 끝난 뒤에 어떤 작업을 할지 정해두는 것이다. 아래의 3가지 중 하나를 인자로 지정할 수 있다.
       1. next: 이것은 다음 명령을 계속 처리하라는 요청이다.
       2. return: 이것은 호출되었던 프로시저로 돌아가라는 요청이다.
       3. 특정 라벨: 이것은 특정 라벨 이름을 붙인 위치로 가라는 요청이다.
   - 예를들면, val 레지스터를 target으로, next를 linkage로 해서 식 5를 컴파일하면 아래와 같다.
   ```lisp
   (assign val (const 5))
   ```
     * 이 코드는 식을 val에 저장하고, 다음 명령으로 가라는 별도의 표시는 없지만 자연히 다음의 명령코드를 수행하게 될 것이다.
   - 위의 번역 전 식을 return linkage로 컴파일하면 아래와 같다.
   ```lisp
   (assign val (const 5))
   (goto (reg continue))
   ```
     * 이 코드는 식을 val에 저장하고, 둘째줄에서 이것을 호출했던 곳으로 되돌아간다.
   
  ####명령들과 스택 사용
  + compile 프로시저의 하부에 있는 코드 생성기 마다 전달받은 식에서 일렬로 구성된 명령줄을 돌려준다.
   - 부분 식에서 쓰는 간단한 코드 생성기 결과를 조합해서 복합 식을 별도의 코드 생성기로 만들어 내는 것 같은 효과를 얻을 수 있다.
  + 명령문을 연결하는 간단한 방법은 append-instruction-sequences 프로시저를 쓰는 것이다.
   - 이 프로시저는 순차 수행될 명령들을 인자로 받아서 이어붙인 명령줄을 돌려준다.
   ```lisp
   (append-instruction-sequences <seq1> <seq2>)
   ```
     * 이것을 수행하면 2개의 명령줄이 하나로 이어붙어 진다.
  + 컴파일러는 레지터스들을 저장할 필요가 있으면 preserving이라는 복잡한 방법으로 명령문을 조합한다.
   - preserving은 3개의 인자를 받는다. 저장할 레지스터 세트 하나, 먼저 수행될 명령문, 다음 수행될 명령문.
     * 첫번째 명령문을 수행하면 레지스터 세트의 값들이 변경된다.
     * 그런데 두번째 명령문 처리에 변경되기 전의 레지스터 세트의 값들이 필요한 경우가 있다.
     * 이런 경우 preserving을 통해 레지스터 세트 값을 미리 저장하고 첫번째 명령문을 처리한 뒤에 저장된 레지스터 세트 값을 복원한 후 두번째 명령문을 처리하게 해주는 것이다.
     * preserving을 적용해도 레지스터 저장이 필요없는 경우에는 앞뒤 명령줄을 연결한 결과만 돌려준다.
     ```lisp
     (preserving (list <reg1> <reg2>) <seq1> <seq2>)
     ```
     * 위의 코드를 실행하면 아래의 4가지 중 하나의 결과가 나오게 된다.
       1. 레지스터 변경이 발생하지 않는 경우
          ```lisp
		  <seq1>
          <seq2>
          ```
       2. 레지스터 세트 중 reg1만 변경이 발생될 경우
          ```lisp
          (save <reg1>)
          <seq1>
          (restore <reg1>)
          <seq2>
          ```
       3. 레지스터 세트 중 reg2만 변경이 발생될 경우
          ```lisp
     	  (save <reg2>)
          <seq1>
          (restore <reg2>)
          <seq2>
          ```
       4. 레지스터 세트 중 reg1, reg2 모두 변경이 발생될 경우
          ```lisp
		  (save <reg1>)
          (save <reg2>)
          <seq1>
          (restore <reg1>)
          (restore <reg2>)
          <seq2>
          ```
  + preserving이 명령줄을 이어붙일 때 필요에 따라 레지스터를 저장 복구하므로 컴파일러는 불필요한 스택연산을 하지 않게 된다.
   - 명령문을 이어붙이기 전에 save와 restore 명령문을 만들어 넣어야 하는지 판단하고 수행해야 한다.
   - 이런 작업을 코드 생성기 마다 넣지 않고 별도로 분리시킬 수 있다. 관심사항을 분리하는 것이다.
  + 명령줄은 명령 리스트로 간단하게 표현된다.
   - append-instruction-sequences는 append를 이용하여 리스트로 된 명령줄을 한데 합친다.
   - 하지만 preserving은 명령줄이 레지스터를 어떻게 사용하는지 분석해야 한다. 
     * 이 경우 preserving으로 분석된 명령줄을 다시 preserving으로 중복 분석하게 될 수도 있다.
     * 이런 중복 분석을 막으려면 명령줄마다 레지스터 사용 정보를 동봉하는 것이 좋다.
     * 이것을 추가하면 명령줄에는 아래 3가지 정보가 들어가게 된다.
       1. needs: 명령처리 전에 초기화되야 하는 레지스터들
       2. modifies: 명령이 처리되면 값이 바뀌는 레지스터들
       3. statements: 사용될 명령들
     * 이것을 적용하여 명령줄 생성자를 만들면 아래와 같다.
     ```lisp
     (define (make-instruction-sequence needs modifies statements)
       (list needs modifies statements))
     ```
   - 예제, 두 개의 명령줄이 있다.
     * 현재의 환경에서 변수 x를 찾아보고 val에 결과를 지정하고 리턴한다.
     * 이 때 레지스터 env와 continue는 초기화가 필요하고, val은 값이 변경된다.
     * 이런 내용의 명령줄은 아래처럼 만들어질 것이다.
     ```lisp
     (make-instruction-sequence '(env continue) '(val)
       '((assign val
                 (op lookup-variable-value) (const x) (reg env))
         (goto (reg continue))))
     ```
     * 때로 아무런 statement가 없는 명령줄을 만들 필요가 있다. 아래의 것을 이용하면 된다.
     ```lisp
     (define (empty-instruction-sequence)
       (make-instruction-sequence '() '() '()))
     ```
   - 명령줄을 하나로 합치는 프로시저는 5.5.4절에 본다.

#####연습문제5.31
+ explicit-control evaluator가 주어진 프로시저를 계산할 때
 - 연산자 계산할 때는 그 앞뒤의 env 레지스터 값을 저장했다가 다시 꺼낸다.
 - 피연산자는 마지막 것만 빼고 그 계산할 때 앞뒤의 env를 저장했다가 다시 꺼냈다.
   * 더불어 피연산자 계산의 전후로 argl도 저장하고 다시 꺼냈다.
 - 피연산자 시퀀스 계산의 전후로 proc도 저장하고 다시 꺼냈다.
 - 아래에 4가지 조합식이 있다. 
   * save와 restore 연산이 필요없는 부분이 어딘가? 그것을 컴파일러의 preserving으로 제거할 수 있는가?

```lisp
(f 'x 'y)

((f) 'x 'y)

(f (g 'x) y)

(f (g 'x) 'y)

```

#####연습문제5.32
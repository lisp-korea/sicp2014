# [First Class Function]


* SICP에서 제시하는 first class procedure의 4가지 요소

  - 변수의 값이 될 수 있다. 다시 말해, 이름이 붙을 수 있다.
  - 프로시저의 인자로 쓸 수 있다.
  - 프로시저의 결과로 만들어 질 수 있다.
  - 데이터 구조 속에 집어 넣을 수 있다.


* Wikipedia에서 제시하는 First Class Function(http://en.m.wikipedia.org/wiki/First-class_function)

  - 머릿글에서 SICP의 위 4가지 조건 인용
  - 어떤이는 익명함수 지원까지 요소로 본다고 한다.


## Java에서의 일급함수

* Java 8 이전의 경우

```java
public class HigherOrderFuncSimulate {
 
   public static void main(String[] args) {
       higherOrderSimulateMethod(new FirstClassFuncSimulate() {
           public void call() {
               speakFrankly().call();
           }
       });
   }
 
   public static void higherOrderSimulateMethod(FirstClassFuncSimulate obj) {       
       obj.call();
   }
 
   public static FirstClassFuncSimulate speakFrankly() {
       System.out.println("I'm not real Higher!");

       return new FirstClassFuncSimulate() {
           public void call() {
        	   show();
           };
       };
   }
 
   public static void show(){
	   System.out.println("And nowhere first-class Method in Java world!");
   }
   
}
 
interface FirstClassFuncSimulate {
   public void call();
}
```

* Java 8 이후의 경우 java.util.function과 lambda식 도입
  
  - Fucntion<InputType, ResultType>, BiFunction<Type1, Type2, Result> 등 함수 흉내를 내는 interface 제공
  - 람다식은 syntatic sugar로 컴파일 전에 자바문법으로 자동 번역
  - 예제는 스택오버플로우( http://stackoverflow.com/questions/15198979/lambda-expressions-and-higher-order-functions) 참조

  - 위의 예제에서 알 수 있는 것들
  - 1. Function 타입의 변수에 Function 타입 함수를 인자로 넣을 수 있다.
  - 2. Collection 연산에서 stream 또는 parallelStream 호출 후의 메서드에 Function 타입 변수 혹은 람다식을 인자로 넣을 수 있다.
  - 3. Function 타입 함수에서 람다식을 리턴할 수 있다.
  - 4. 그러면 자료구조에 함수 집어넣는 것은? 아래 코드 주석 참조

```java
public class HigherOrder {		
	
   public static void main(String[] args) {
      HashMap<String, Function<String, String>> funcMaps = initFunctionMaps();  // 내용 추가
      Function<Integer, Long> addOne = add(1L);

      System.out.println(addOne.apply(1)); 

      Arrays.asList("test", "new")
	.parallelStream()  
	.map(funcMaps.get("stringFunc1"))  // 내용 수정  
	.forEach(System.out::println);
   }

   private static Function<Integer, Long> add(long l) {
      return (Integer i) -> l + i;
   }

   private static Function<String, String> camelize = 
	(str) -> str.substring(0, 1).toUpperCase() + str.substring(1);

   // 자료구조에 함수 집어넣기 (내용 추가)			
   public static HashMap<String, Function<String, String>> initFunctionMaps(){
      HashMap<String, Function<String, String>> functionMaps
	   = new HashMap<String, Function<String, String>>();
		
      functionMaps.put("stringFunc1", (str) -> str.substring(0, 1).toUpperCase() + str.substring(1) );
      functionMaps.put("stringFunc2", (str) -> str + " , hello? you see stringFunc2.");
		
      return functionMaps;		
   }
}
```


  

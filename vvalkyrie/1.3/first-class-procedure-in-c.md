# First-Class Procedure in C

## 정의 (SICP pp.98)

1. 변수의 값이 될 수 있다. 다시 말해, 이름이 붙을 수 있다.
2. 프로시저 인자로 쓸 수 있다.
3. 프로시저의 결과로 만들어질 수 있다.
4. 데이터 구조 속에 집어 넣을 수 있다.

## C Implementation

### 변수의 값으로 사용

```c
typedef int (*operator_f)(int, int);

int my_mul(int a, int b)
{
  return (a*b);
}

int main(void)
{
  operator_f mul = my_mul; // (1)
  int a = 4, b = 5;
  printf("%d x %d = %d\n", a, b, mul(a, b));
  return 0;
}
```

### 프로시저의 인자로 사용

```c
typedef int (*operator_f)(int, int);

int my_mul(int a, int b)
{
  return (a*b);
}

int op(int a, int b, operator_f operation)
{
  return operation(a, b);
}

int main(void)
{
  int a = 4, b = 5;
  printf("%d x %d = %d\n", a, b, op(a, b, my_mul)); // (2)
  return 0;
}
```

### 프로시저의 결과로 받기

```c
typedef int (*operator_f)(int, int);

int my_mul(int a, int b)
{
  return (a*b);
}

operator_f get_op_mul(void)
{
  return my_mul; // (3)
}

int main(void)
{
  int a = 4, b = 5;
  printf("%d x %d = %d\n", a, b, get_op_mul()(a, b));
  return 0;
}
```

### 데이터 구조 속에 집어 넣기

```c
typedef int (*operator_f)(int, int);

typedef struct {
  int a;
  int b;
  operator_f op;
} calc_t;

int my_mul(int a, int b)
{
  return (a*b);
}

int main(void)
{
  calc_t calc = { 4, 5, my_mul };
  printf("%d x %d = %d\n", calc.a, calc.b, calc.op(calc.a, calc.b));
  return 0;
}
```

## Etc.

C 언어는 다음 요구조건들을 충족하지 못한다 (C11 포함).

- 중첩된 합수 정의
- 익명 함수
- 클로저 (closure)

단, OS X의 clang에서는 block의 형태로 closure를 지원한다.

```c
#include <stdio.h>
#include <Block.h>

typedef int (^IntBlock)();

IntBlock MakeCounter(int start, int increment)
{
  __block int i = start;

  return Block_copy(^{
      int ret = i;
      i += increment;
      return ret;
    });
}

int main(void)
{
  IntBlock mycounter = MakeCounter(5, 2);
  printf("1st call: %d\n", mycounter());
  printf("2nd call: %d\n", mycounter());
  printf("3rd call: %d\n", mycounter());

  Block_release(mycounter);

  return 0;
}
```
(from wikipedia)
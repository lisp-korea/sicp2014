# First-Class Procedure in C

## 정의 (SICP pp.98)

1. 변수의 값이 될 수 있다. 다시 말해, 이름이 붙을 수 있다.
2. 프로시저 인자로 쓸 수 있다.
3. 프로시저의 결과로 만들어질 수 있다.
4. 데이터 구조 속에 집어 넣을 수 있다.

## C Implementation

외국환 거래소에서는 시장 환율에 따라 달러와 타 국가의 화폐를 거래한다.
모든 화폐는 달러로만 거래할 수 있다.
예를 들어 원화를 엔화로 바꾸고 싶을 때에는 원화를 먼저 달러로 바꾼 후,
다시 엔화로 바꾼다.

단 원화의 경우, 창구 거래에 의한 환전 수수료가 붙어서
달러로 바꿀 때에는 원/달러 기준 환율에 20원이 추가되고,
달러에서 원화로 바꿀 때에는 20원이 차감된다.

```c
#include <stdio.h>
#include <string.h>

int exchange_generic2usd(int money, int rate) { return (money / rate); }
int exchange_usd2generic(int money, int rate) { return (money * rate); }
int exchange_krw2usd(int money, int rate) { return (money / (rate+20)); }
int exchange_usd2krw(int money, int rate) { return (money * (rate-20)); }

int get_exchange_rate(const char *unit)
{
  if(unit == NULL) return 0;
  if(!strcmp(unit, "KRW")) return 1114;
  else if(!strcmp(unit, "JPY")) return 119;
  return 1;
}

typedef int (*exchange_f)(int, int); // function pointer

exchange_f get_exchange_to_usd(const char *unit)
{
  if(unit == NULL) return NULL;
  if(!strcmp(unit, "KRW"))
    return exchange_krw2usd;

  else if(!strcmp(unit, "JPY"))
    return exchange_generic2usd;

  return NULL;
}

exchange_f get_exchange_from_usd(const char *unit)
{
  if(unit == NULL) return NULL;
  if(!strcmp(unit, "KRW"))
    return exchange_usd2krw;

  else if(!strcmp(unit, "JPY"))
    return exchange_usd2generic;

  return NULL;
}

int currency_conversion(int money,
    exchange_f from_func, int from_rate,
    exchange_f to_func,   int to_rate)
{
  int m = from_func(money, from_rate);

  if(to_func != NULL)
    return to_func(m, to_rate);
  else return m;
}

int currency_exchange(int money, const char *from, const char *to)
{
  int from_rate = get_exchange_rate(from),
      to_rate   = get_exchange_rate(to);

  exchange_f from_func = get_exchange_to_usd(from),
             to_func   = get_exchange_from_usd(to);

  return currency_conversion(money, from_func, from_rate, to_func, to_rate);
}

int main(void)
{
  printf("10000 won is %d us$.\n", currency_exchange(10000, "KRW", "USD"));
  printf("10000 won is %d yen.\n", currency_exchange(10000, "KRW", "JPY"));
  return 0;
}
```

결과:

```
10000 won is 8 us$.
10000 won is 952 yen.
```

## Etc.

- 중첩된 합수 정의
- 익명 함수
- 클로저 (closure)

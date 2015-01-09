# Python에서 function은 일급객체
 - [위키피디아](http://en.wikipedia.org/wiki/First-class_function#Language_support "표 제공")

## 그래서 Higher order function 가능하다.
 적은 코드로 많은 일을 할 수 있다.
 <pre><code>
"""
 출처 : [software-capentry.org](http://software-carpentry.org/v4/python/funcobj.html)
"""
def combine_values(func, *values):
    current = values[0]
    for i in range(1, len(values)):
        current = func(current, values[i])
    return current

def add(x, y):
    return x + y

print combine_values(add,1,3,5)
print combine_values(add, 'long', ' long ', 'time ago')
 </code></pre>
 higher order function을 못쓴다면
  - 할 일 개수 * data structure 개수: int 따로, string 따로 combine_values, add
 higher order function을 쓸 수 있으면
  - 할 일 개수+ data structure 개수 : combine_values, add 같이 사용
  - 물론 *args 덕을 보긴 했지만, data structure 타입이 더 늘어나면..?

## 그래서 closer, closer로 데코레이터 만들기
 [출처: thenewcircle.com](https://thenewcircle.com/static/bookshelf/python_fundamentals_tutorial/functional_programming.html)
 <pre><code>
def simple(*args):
    for arg in args:
        print arg,

def logit(func):
    def wrapper(\*args, \*\*kwargs):
        print 'function %s called with args %s' % (func, args)
        func(\*args, \*\*kwargs)
    return wrapper

logged_simple = logit(simple)
"""
test 실행
"""
logged_simple('a', 'b', 'c')
"""
바꿔치기
"""
simple = logit(simple)
</code></pre>

<pre><code>
"""
 functional-3-langs-atsyntax.py
 출처 : [thenewarticle.com](https://thenewcircle.com/static/bookshelf/python_fundamentals_tutorial/functional_programming.html)
"""
import itertools

CLAIM = '{0} is the #{1} {2} language'

def python_rules(func):
    def wrapper(*args, **kwargs):
        new_args = ['Python']
        new_args.extend(args)
        return func(*new_args)
    return wrapper

def best(type, *args):
    langs = []
    for i, arg in enumerate(args):
        langs.append(CLAIM.format(arg, i+1, type))
    return langs

@python_rules
def best_functional(*args):
    return best('functional', *args)

@python_rules
def best_oo(*args):
    return best('OO', *args)

for claim in itertools.chain(best_functional('Haskell', 'Erlang'), [''],
        best_oo('Objective-C', 'Java')):
    print claim
</code></pre>


## (제한이 있는) lambda
 제한 : body에는 expression 딱 하나만 허용한다. 제어문 안됨.
 lambda도 익명 '함수' 니까 (당연히)값처럼 넘어간다.
 <pre><code>
"""
 출처 : [bototobogo.com](http://www.bogotobogo.com/python/python_fncs_map_filter_reduce.php)
"""
def square(x):
        return (x\*\*2)
def cube(x):
        return (x\*\*3)

funcs = [square, cube]

for r in range(5):
    value = map(lambda x: x(r), funcs)
    print value
 </code></pre>

 <pre><code>
"""
 출처 : http://www.ibm.com/developerworks/library/l-prog/
"""
pr = lambda s:s
namenum = lambda x: (x==1 and pr("one")) \
                  or (x==2 and pr("two")) \
                  or (pr("other"))
 </code></pre>
 <!>단순한 lambda를 만들기 전에 operator 모듈에 있나 체크.
 [파이썬 operator 모듈](https://docs.python.org/2/library/operator.html#module-operator)

# Clojure HTTP API 서버 구현을 위한 라이브러리

카카오 / 김은민

### descrption
- 인사 (소속 / 이름)
- 클로저를 공부해 보신 분?
- 클로저를 실무에서 사용해 보신 분?
- 클로저로 HTTP API 서버를 개발하면서 사용했던 라이브러리들에 대해서 공유하려고 함

## HTTP API 서버에 필요한 것들

- HTTP
  - Web Server / Servlet Wrapper / Routing
- Database
  - SQL / Connection Pool / Migration
- Etc
  - Resource Life Cycle Manager / Latency and Fault Tolerance / Doc

### descrption
- Clojure 웹 개발은 다른 Java 프레임워크와 유사하게 서블릿을 사용하고 Wrapper 형태 라이브러리들이 있음
- Clojure 개발을 위해 어떤 서블릿 컨테이너를 선택 할지 고민
- 다양한 Java 웹 프레임워크들에서 기본적으로 제공하는 라우팅 라이브러리 역시 필요
- Clojure는 데이터를 객체에 매핑해서 사용하는 방식은 아니기 때문에 ORM은 사용하지 않지만 SQL을 더 쉽게 다룰 수 있는 라이브러리가 있으면 좋다
- 데이터베이스 커넥션 풀 관리를 위한 라이브러리도 필요
- 협업을 위해 테이블 스키마 관리가 필요하기 때문에 마이그레이션 라이브러리도 필요
- 커넥션 풀과 같은 상태를 가지는 값들 관리하기 위한 방법이 필요
- 장애 전파 방지등 외부 의존적인 서비스들에 대한 관리도 필요
- API 문서를 효과적으로 관리할 수 있는 방법도 필요

## HTTP - Web Server

[그림] https://github.com/ptaoussanis/clojure-web-server-benchmarks/tree/master/results/60k-keepalive#60k-keepalive

https://github.com/ptaoussanis/clojure-web-server-benchmarks

### descrption
- 웹 서버 선택을 위해 찾아본 벤치 마크 자료
- Jetty / Tomcat / Undertow / Netty / Nginx 등 다양한 서버들을 Wrapping 해놓은 클로저 라이브러리들이 있음
- 별도의 컨테이너에 war 형식으로 배포하는 경우도 있지만 어플리케이션 내부에서 server를 포함하는 방법이 더 많이 사용되고 있음
- immutant2는 보통의 웹 환경에 대체로 좋은 성능을 보여주고 있음

## Web - Servlet Wrapper

- Ring
  - 가장 많이 사용되고 있는 서블릿 Wrapper 라이브러리
  - 서블릿 Wrapper 기능에 충실하고 단순
  - middleware 방식으로 기능 확장
  - 기본 컨테이너로 Jetty 사용
  - 서블릿 2.5 버전 지원

- Pedestal
  - Cognitect에서 지원하고 있음
  - 서블릿 Wrapper 외 Routing 기능이 있음
  - interceptor 방식으로 기능 확장 (Ring middleware 호환)
    - https://github.com/pedestal/pedestal/blob/master/guides/documentation/service-interceptors.md
  - 기본 컨테이너로 Jetty / Tomcat / Immutant 선택 가능
  - 서블릿 3.1 버전 지원
  - Ring request/response 사용

## HTTP - Routing - Compojure

- Compojure
  - Ring을 만든 Weavejester가 작성
  - Ring과 함께 가장 많이 사용
  - 파라미터 디스트럭처링 기능

- RESTful Example
```clojure
(defroutes routes
  (context "/articles" []
    (defroutes articles-routes
      (GET "/" [] (article/get-all))
      (POST "/" {body :body} (article/wrap-member-only
                               (article/create body)))
      (context "/:id" [id]
        (defroutes article-routes
          (GET "/" [] (article/get))
          (PUT "/" {body :body} (article/wrap-owner-only
                                  (article/update id body)))
          (DELETE "/" [] (article/warp-owner-only
                           (article/delete id))))))))
```

### descrption

## HTTP - Routing - Pedestal

- Pedestal
  - Pedestal 라이브러리에 포함
  - 디스트럭처링 기능은 없음

- RESTful Example
```clojure
(defroutes routes
  [[["/articles"
     {:get (article/get-all)
      :post ^:interceptors [article/member-only] (article/create)}
     ["/:id" ^:constraints {:id #"[0-9]+"}
      {:get (article/get)
       :put ^:interceptors [article/owner-only] (article/update)
       :delete ^:interceptors [article/owner-only] (article/delete)}]]]])
```
### descrption
- 디스트럭처링 기능이 없기 때문에 파라미터에 대한 처리는 핸들러에서 함
- Compojure와 기능상 큰 차이 디스트럭링 지원 유무
- Compojure가 조금 더 클로저에 자연스러운 형태
- Restful Routing을 표현하기 위해 Context가 필요하다면 좀 더 간결해 보이는 Pedestal 라우팅을 선호
- 일반 Restful Routing이 아닌 경우에 표현 방식에 큰 차이는 없을 것 같음

## HTTP - Routing - Liberator

- Liberator
  - Restful Routing에 특화된 라이브러리
  - Compojure와 함께 사용

- Restful Example
```clojure
(defresource articles-resource []
  :allowed-methods [:get :post]
  :handle-ok article/get-all
  :post! article/create)

(defresource article-resource [id]
  :allowed-methods [:get :put :delete]
  :exists? article/exists?
  :existed? artcle/existed?
  :handle-ok ::article
  :delete! article/delete
  :put! article/update
  :new? article/new?)

(defroute routes
  (ANY ["/articles/:id{[0-9]+}"] [id] (article-resource id))
  (ANY "/articles" [] articles-resource))
```

### descrption
- defresource에는 더 많은 기능이 있음
- 확장이 불편해 보이지만 사용해 볼만한 라이브러리라고 생각

## HTTP - 정리

- Pedestal 선택
  - Restful API에 라우팅 스타일이 좀 더 간결
  - immutant2 사용의 편리함
  - Servlet 최신 버전에 대한 지원
  - 장기적인 라이브러리 지원에 대한 안정성

### descrption
- 서블릿 3.1은 NIO 사용이 편리한 스타일의 API 제공 / 기능은 크게 변화 없음

## Database - SQL

- sqlkorma
  - SQL에 대응하는 매크로들을 제공
  - clojure.jdbc 함수들을 직접 호출할 필요가 없음
  - 관계 정의 기능
  - 데이터베이스 연결을 defdb를 사용해 Var를 만들기 때문에 connection 관리가 불편함

  ```clojure
  (defdb prod (postgres {:db "korma"
                         :user "db"
                         :password "dbpass"}))

  (defentity address)
  (defentity user
    (has-one address))

  (select user
    (with address)
    (fields :firstName :lastName :address.state)
    (where {:email "korma@sqlkorma.com"}))
  ```

### descrption
- 기본적으로는 SQL 자체가 dsl이기 때문에 복잡한 라이브러리를 선호하지 않는다. 결국 라이브러리의 언어자체가 SQL과 비슷해지기 때문에
- 하지만 동적인 SQL 생성할 때는 SQL을 문자열로 SQL를 만들어내는 것보다는 라이브러리가 있으면 편리하다.


## Database - SQL

- honeysql
  - SQL에 대응하는 매크로로 SQL문을 생성하는 라이브러리
  - clojure.jdbc를 직접 사용해야 함
  - 단순히 SQL문을 생성하기 때문에 다른 database 라이브러리들과 조화롭게 사용 가능

  ```clojure
  (-> (select :*)
    (from :foo)
    (where [:= :a 1] [:< :b 100])
    sql/format)
  => ["SELECT * FROM foo WHERE (a = 1 AND b < 100)"]
  ```

### descrption
- connection 관리를 직접하기 편리한 honeysql를 선택

## Database - Connection Pool

- HikariCP
  - 가볍고 벤치 마크 결과도 좋고 Clojure Wrapper도 잘 되있음
  - https://github.com/tomekw/hikari-cp
  - Weavejester의 component 기반 웹 프레임워크인 duct에서 사용하고 있음
    - https://github.com/weavejester/duct-hikaricp-component

- 벤치 마크 자료 (https://github.com/brettwooldridge/HikariCP)

## Database - Migration

- Migartus / Ragtime
  - 두 라이브러리 모두 비슷한 형태와 기능을 하고 있음
  - Lumius 웹 템플릿은 Migratus를 사용
  - Weavejester의 Ragtime 라이브러리를 선택

  ```clojure
  ;; resources/migrations/001-foo.edn
  {:up ["CREATE TABLE foo (id int);"]
   :down ["DROP TABLE foo;"]}

  (def config
    {:datastore   (jdbc/sql-database {:connection-uri "..."})
     :migrations (jdbc/load-resources "migrations")})

  user=> (repl/migrate config)
  Applying 001-foo
  nil
  user=> (repl/rollback config)
  Rolling back 001-foo
  nil
  ```

## Etc - Resource Life Cycle Manager

- Connection Pool / Server Life Cycle 관리

```clojure
(defn -main [& args]
  (let [pool (HikariDataSource. config)
        server (server/start pool)]
    (.addShutdownHook
      (Runtime/getRuntime)
        (Thread. #(do
                    (.close pool)
                    (.stop server))))))
```

## Etc - Resource Life Cycle Manager

- stuartsierra component
  - Lifecycle 관리를 위한 라이브러리
  - start/stop 프로토콜을 구현
  - system으로 컴포넌트의 의존 관계를 정하고 start/stop

```clojure
(defrecord Database []
  component/Lifecycle
  (start [component]
    (assoc component :pool (HikariDataSource. config)))
  (stop [component]
    (.close (:pool component))
    (dissoc component :pool)))
```

```clojure
(defrecord Server [database]
  component/Lifecycle
  (start [component]
    (assoc component :server (server/start (:pool database))))
  (stop [component]
    (.stop (:server component))
    (dissoc component :server)))
```

```clojure
(def system
  (-> (component/system-map
        :database (new-database)
        :server (new-server))
      (component/system-using
        {:server [:database]})))

(defn -main [& args]
  (.addShutdownHook
    (Runtime/getRuntime)
      (Thread. #(alter-var-root #'system component/stop))
  (alter-var-root #'system component/start))
```

## Etc - Doc

- Swagger (http://swagger.io)
  - HTTP API를 정의하는 Spec
  - Swaager UI / Codegen / Editor등의 많은 툴이 있음

- ring-swagger
  - schema를 이용해 swagger spec을 생성
  - validation 기능

- pedestal-swagger
  - pedestal 핸들러와 인터셉터 별로 spec을 지정 할 수 있음
  - Swagger UI 제공

### description
- Swagger API 문서 관리에 대한 부담을 줄여준다.
- 덤으로 스키마를 이용한 파라미터 체크 및 응답 체크 (validation)이 가능했다.

## Summary - 라이브러리의 선택 기준

- Contextual vs Composable
  - http://javing.blogspot.kr/2014/01/contextual-vs-composable-design.html
  - 그림 추가
- Composable
  - 장점 : 유연하다 / 유지보수가 쉽다 / 다목적 / 익숙한 사람은 빠름
  - 단점 : 큰 책임이 따른다 / 경험이 적은 사람들에게는 훈련이 필요 / 정해진 규칙이 없음 - 잘 못 사용할 가능성
- Contextual
  - 장점 : 문제에 대한 해결 / 사용이 편리함 /
  - 단점 : 다른 문제를 해결 하지 못함 / 유지보수가 필요함 / Dietzler’s Law (80%의 사용자는 편리함을 원함)

### description
- Clojure는 언어가 Composable
- Framework를 선호하지 않음 / Libraries의 조합으로 표현
- 만든 소프트웨어는 컴포저블 해야하지만 엔드 유저 단까지 컴포저블 할 수 없다.
- 어디까지 컴포저블 해야하는가?

## Summary - 라이브러리의 선택 기준

- 표1
  - GUI vs Terminal
  - Framework vs Programmatical approach
  - Wizard vs copy&paste files into directories

- 표2
  - Pedstal vs (Ring + Compojure + Immutant2)
  - sqlkorma vs honeysql

### description
- 확장성을 생각했을 때 기반이 되는 부분은 서비스를 운영하면서 변경되지 않을것 같아 편리한 Pedstal을 선택
- 데이터 접속 부분은 Component + hikari-cp + clojure.jdbc를 조합하기 위해 조합형 SQL 라이브러리인 Honeysql을 선택
- Restful 라이브러리인 liberator는 서비스 운영중 다양한 요청/응답 형태가 생길 수 있기 때문에 보통의 Web 라이브러리로 조합하기로 함

## Libraries

- pedestal (https://github.com/pedestal/pedestal)
- component (https://github.com/stuartsierra/component)
- pedestal-swagger (https://github.com/frankiesardo/pedestal-swagger)
- hikari-cp (https://github.com/tomekw/hikari-cp)
- ragtime (https://github.com/weavejester/ragtime)
- honeysql (https://github.com/jkk/honeysql)
- schema (https://github.com/Prismatic/schema)
- clj-http (https://github.com/dakrone/clj-http)

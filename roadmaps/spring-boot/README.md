---
title: Spring Boot
roadmap: spring-boot
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, java, backend]
---

# Spring Boot

> roadmap.sh: https://roadmap.sh/spring-boot

Track for the **Spring Boot** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Prerequisites
- [ ] Core Java
- [ ] Build tools (Maven, Gradle)
- [ ] HTTP and REST basics
- [ ] Relational databases and SQL

### Spring Core
- [ ] What is Spring Framework
- [ ] Inversion of Control
- [ ] Dependency injection
- [ ] Beans and the application context
- [ ] Bean scopes
- [ ] Bean lifecycle
- [ ] Component scanning
- [ ] Stereotype annotations
- [ ] Configuration classes
- [ ] Profiles
- [ ] Spring Expression Language (SpEL)
- [ ] Aspect-Oriented Programming (AOP)
- [ ] Event publishing

### Spring Boot Basics
- [ ] What is Spring Boot
- [ ] Spring Initializr
- [ ] Auto-configuration
- [ ] Starters
- [ ] Application properties and YAML
- [ ] Externalized configuration
- [ ] @ConfigurationProperties
- [ ] Spring Boot DevTools
- [ ] Embedded servers (Tomcat, Jetty, Undertow)
- [ ] CommandLineRunner and ApplicationRunner

### Web and REST
- [ ] Spring MVC
- [ ] @RestController and @Controller
- [ ] Request mapping
- [ ] Path variables and request params
- [ ] Request and response bodies
- [ ] Content negotiation
- [ ] Validation (Bean Validation)
- [ ] Exception handling (@ControllerAdvice)
- [ ] Interceptors and filters
- [ ] CORS
- [ ] HATEOAS
- [ ] OpenAPI / Swagger
- [ ] WebFlux and reactive

### Data Access
- [ ] Spring Data overview
- [ ] JDBC Template
- [ ] JPA and Hibernate
- [ ] Spring Data JPA repositories
- [ ] Entity mapping
- [ ] Query methods and JPQL
- [ ] Transactions
- [ ] Pagination and sorting
- [ ] Database migrations (Flyway, Liquibase)
- [ ] Spring Data MongoDB
- [ ] Caching abstraction

### Security
- [ ] Spring Security basics
- [ ] Authentication
- [ ] Authorization
- [ ] Password encoding
- [ ] JWT
- [ ] OAuth2 and OpenID Connect
- [ ] Method-level security

### Messaging and Integration
- [ ] REST clients (RestTemplate, WebClient, RestClient)
- [ ] Spring for Apache Kafka
- [ ] RabbitMQ / JMS
- [ ] Scheduling tasks
- [ ] Async methods

### Testing
- [ ] Unit testing with JUnit and Mockito
- [ ] @SpringBootTest
- [ ] Slice tests (@WebMvcTest, @DataJpaTest)
- [ ] MockMvc
- [ ] Testcontainers

### Observability and Production
- [ ] Spring Boot Actuator
- [ ] Health checks and metrics
- [ ] Micrometer
- [ ] Logging configuration
- [ ] Profiles for environments
- [ ] Packaging and running JARs
- [ ] Docker and containerization
- [ ] GraalVM native images

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a REST API for a bookstore with Spring Data JPA, Bean Validation, and Flyway migrations.
- Secure an existing API with Spring Security using JWT auth and method-level authorization.
- Create an order-processing service that consumes Kafka events and exposes Actuator metrics.

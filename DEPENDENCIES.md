# Dependencies (pom.xml)

As this is a Java project using Maven, dependencies are managed via the `pom.xml` file rather than a `package.json` or `requirements.txt`.

The existing `pom.xml` handles dependency resolution automatically. Here is a breakdown of the core dependencies used in this project and exactly why they are required.

## Core Dependencies

### Servlet API & JSP
```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
    <scope>provided</scope>
</dependency>
<dependency>
    <groupId>javax.servlet.jsp</groupId>
    <artifactId>javax.servlet.jsp-api</artifactId>
    <version>2.3.3</version>
    <scope>provided</scope>
</dependency>
```
**Why:** These are the core Java EE specifications required to handle HTTP requests (`HttpServletRequest`, `HttpServletResponse`) and compile JavaServer Pages (JSP). They are marked as `<scope>provided</scope>` because the application server (Jetty/Tomcat) provides these libraries at runtime.

### JSTL (JavaServer Pages Standard Tag Library)
```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jstl</artifactId>
    <version>1.2</version>
</dependency>
```
**Why:** Enables the use of logic tags (`<c:forEach>`, `<c:if>`) directly within the JSP HTML files. This allows us to cleanly loop through product lists (like the Featured Collection and New Arrivals) without writing raw Java scriplets (`<% ... %>`) in the HTML.

### Database Driver (MySQL)
```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.0.33</version>
</dependency>
```
**Why:** The JDBC driver that allows the Java DAOs (Data Access Objects) to communicate with the MySQL 8.0 database. Without this, `DriverManager.getConnection()` will fail to find the database URL.

## Build Plugins (Scripts Equivalent)

In Node.js, you have npm scripts (`npm run start`). In Maven, we use build plugins to achieve similar tasks.

### Maven Compiler Plugin
**Why:** Instructs Maven to compile the Java source code using Java 11. Equivalent to running `tsc` in a TypeScript project or `babel` in a modern JS project.

### Jetty Maven Plugin
**Why:** Provides an embedded web server for local development. 
- **Equivalent to:** `npm run dev`
- **Command:** `mvn jetty:run`
- **Usage:** This starts a local server on port 8080 and serves the web app dynamically, recompiling when changes are detected. This should NEVER be used in a real production environment (production should use a dedicated Tomcat or Jetty standalone server).

# FRK Collectives - Setup & Deployment Guide

Welcome to the **FRK Collectives** project. This is a premium, minimalist E-Commerce web application built using Java Servlets, JSP, JSTL, React (Landing Page), and MySQL.

## 1. Prerequisites

Ensure you have the following installed on your system:
- **Java JDK 11** or higher
- **Apache Maven 3.6+**
- **Apache Tomcat 9.x+**
- **MySQL Server 8.0+**

---

### 👤 Pre-configured Accounts

| Role | Email | Password |
|------|-------|----------|
| **Admin** | `admin@frkcollectives.com` | `Admin@123` |
| **Test Customer** | `farhan@example.com` | `Customer@123` |

---

## 2. Database Setup

1. Open your MySQL client (e.g., MySQL Workbench, DBeaver, or command line).
2. Execute the `src/main/resources/frk_schema.sql` script:
   ```sql
   source src/main/resources/frk_schema.sql;
   ```
3. Create a `.env` file in the root directory (template provided) and update your MySQL credentials.

---

## 3. Configuration (.env)

The application uses a `.env` file for database configuration. Ensure the following variables are set:
```env
DB_URL=jdbc:mysql://localhost:3306/frk_collectives?...
DB_USER=root
DB_PASSWORD=your_password
```


---

## 3. Project Configuration

### Adding MySQL Connector JAR
If you are using Maven, the MySQL Connector JAR is automatically downloaded and included via the `pom.xml` dependencies:
```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>
```
If you manage dependencies manually, download the `mysql-connector-java-8.0.33.jar` and place it inside the `src/main/webapp/WEB-INF/lib/` folder.

### Connection String Strategy
The JDBC connection string should follow this format:
```java
String url = "jdbc:mysql://localhost:3306/frk_collectives?useSSL=false&serverTimezone=UTC";
```

### Configuring Tomcat
1. Download [Apache Tomcat 9](https://tomcat.apache.org/download-90.cgi) and extract it.
2. If using an IDE like IntelliJ Ultimate or Eclipse Enterprise, add the Tomcat server in the Run/Debug configurations and point it to your extracted Tomcat directory.
3. If running independently, continue to Step 4.

---

## 4. Building the WAR File

From the root directory of the project (`C:\Users\farha\OneDrive\Desktop\E-COM`), open your terminal/command prompt and run:

```bash
mvn clean package
```

This command will:
1. Compile the Java source code.
2. Package the compiled classes and web resources (JSPs, CSS, etc.) into a single Web ARchive (`.war`) file.
3. The resulting file will be located at `target/frk-collectives.war`.

---

## 5. Deployment to Tomcat

1. Copy the generated `frk-collectives.war` from the `target` directory.
2. Paste it into the `webapps` folder inside your Tomcat installation directory (e.g., `C:\apache-tomcat-9.X\webapps\`).
3. Start the Tomcat server by running `bin/startup.bat` (Windows) or `bin/startup.sh` (Mac/Linux).
4. Tomcat will automatically extract the `.war` file and deploy the application.
5. Open your browser and navigate to:
   `http://localhost:8080/frk-collectives/`

---

## 6. Architecture & Technical Explanations

### Architecture Overview (MVC Pattern)
This application strictly follows the Model-View-Controller architecture:
- **Model**: JavaBeans (`Product.java`, `CartItem.java`) represent data. Data Access Objects (`ProductDAO.java`) handle database interactions using JDBC.
- **View**: JSP pages handle dynamic rendering (`products.jsp`, `cart.jsp`, `checkout.jsp`). React handles the heavy UI components on the landing page (`index.jsp`) via CDN. Custom JSTL tags and CSS format the presentation.
- **Controller**: Java Servlets (`HomeServlet.java`, `CartServlet.java`, `CheckoutServlet.java`) manage the application flow. They receive HTTP requests, interact with Models/DAOs, and forward data to Views. **No business logic or direct database access is inside JSP.**

### Session vs. Cookie Analysis
- **HttpSession**: Used for the **Shopping Cart**. Sessions securely store data on the server during the user's visit. A session ID is stored in a temporary cookie on the client. It handles state (the list of `CartItem`s) that shouldn't be tampered with. We've configured a 30-minute timeout in `web.xml`.
- **Cookies**: Used for personalizing the experience between visits (e.g., a "Welcome Back" message or remembering a username). Cookies persist on the user's browser for a longer, set expiration date and are read directly by the server in subsequent requests.

### JDBC Optimization Strategy
We use **`try-with-resources`** for all JDBC operations inside the DAO layer.
```java
try (Connection conn = DBConnection.getConnection();
     PreparedStatement pstmt = conn.prepareStatement(query)) {
     // ... execute and process
} catch (SQLException e) {
     e.printStackTrace();
}
```
**Why this is essential:** Database connections, statements, and result sets hold critical memory and network resources. `try-with-resources` guarantees that these resources are automatically properly closed in reverse order of creation, even if exceptions occur, preventing connection leaks that crash modern multi-user applications.

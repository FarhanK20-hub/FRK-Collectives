# FRK Collectives

> A high-end, cinematic e-commerce platform built for luxury apparel.

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Java](https://img.shields.io/badge/Java-11-orange)
![Maven](https://img.shields.io/badge/Build-Maven-blue)
![GSAP](https://img.shields.io/badge/Animation-GSAP-green)

---

## What is this?

**FRK Collectives** is a modern e-commerce storefront designed to deliver a premium, editorial shopping experience. Unlike standard online stores that feel rigid and template-driven, FRK Collectives uses fluid cinematic animations, custom cursor interactions, and seamless page transitions to make shopping feel like interacting with a high-end digital lookbook. 

It solves the problem of brand presentation for luxury apparel. Customers expect luxury brands to have a digital presence that matches the quality of their physical products. This platform provides that highly tactile, engaging experience out of the box, allowing users to browse curated collections, add items to a stylized cart, and manage their wishlists—all wrapped in a highly responsive, performant interface.

## How it works

FRK Collectives is a monolithic web application structured around a robust Java Servlet backend and a highly dynamic, vanilla-JS-driven frontend. 

1.  **The Backend (Java/JSP)**: The core logic is built on Java 11 using standard Servlets to handle routing (e.g., `/products`, `/cart`, `/checkout`) and Data Access Objects (DAOs) to interact with a MySQL database. Pages are rendered server-side using JavaServer Pages (JSP) and the JavaServer Pages Standard Tag Library (JSTL) for templating and data injection.
2.  **The Frontend (HTML/CSS/JS)**: We serve standard HTML enriched with a sophisticated CSS architecture. Instead of a heavy JavaScript framework, the UI leverages **GSAP (GreenSock Animation Platform)** injected via CDN. This allows us to orchestrate complex timeline animations (like text split-reveals) and scroll-triggered staggers directly on the DOM without the overhead of a Virtual DOM.
3.  **Micro-Components**: Certain isolated interactive elements (like the Hero carousel) utilize React 18, imported entirely via CDN and compiled in the browser via Babel. This hybrid approach keeps the initial load lightweight while enabling complex state management where necessary.

## Tech Stack

| Technology | Version | Used for | Why this over alternatives |
| :--- | :--- | :--- | :--- |
| **Java** | 11 | Backend logic & routing | Industry standard for robust, scalable enterprise web applications. |
| **JSP / JSTL** | 2.3 / 1.2 | Server-side templating | Native integration with Java Servlets for seamless data binding. |
| **MySQL** | 8.0.33 | Relational database | Reliable, ACID-compliant storage for users, products, and orders. |
| **Maven** | 3.x | Build tool & dependency mgmt | Standardizes the build process and automatically fetches libraries. |
| **GSAP** | 3.12.5 | Cinematic UI animations | Unmatched performance and timeline control for complex DOM animations. |
| **React (CDN)** | 18 | Hero carousel state | Allows component-based logic without requiring a Node.js build step. |

## Features

-   **Cinematic Page Transitions**: Smooth dark-overlay wipes trigger between internal page navigations, eliminating harsh browser reloads.
-   **Hardware-Accelerated Scroll Reveals**: Product grids stagger into view using GSAP `ScrollTrigger` and CSS IntersectionObservers, achieving 60fps without layout thrashing.
-   **Context-Aware Custom Cursor**: A dark ring with a gold trailing dot dynamically scales when hovering over interactive elements (auto-disabled on touch devices).
-   **Accessibility-First Motion**: All animations automatically disable themselves if the user's OS has `prefers-reduced-motion` enabled.
-   **Editorial Minimalist Design**: Icon-only navigation (using Feather Icons) and a bespoke dark/gold color palette.

## Prerequisites

| Tool | Minimum version | How to install |
| :--- | :--- | :--- |
| **Java JDK** | 11 | [Download Oracle JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) or OpenJDK |
| **Apache Maven** | 3.6.0 | [Install Maven](https://maven.apache.org/install.html) |
| **MySQL** | 8.0 | [Download MySQL Community Server](https://dev.mysql.com/downloads/mysql/) |

## Setup

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/frk-collectives.git
    cd frk-collectives
    ```

2.  **Configure Environment Variables**
    Copy the template file to create your active environment config.
    ```bash
    cp .env.example .env
    ```
    *Open `.env` in your editor and update `DB_PASSWORD` with your local MySQL password.*

3.  **Database Setup**
    Log into your MySQL instance and run the schema setup:
    ```sql
    mysql -u root -p
    CREATE DATABASE frk_collectives_db;
    -- Import the initial schema (assuming a schema.sql file exists)
    -- source src/main/resources/schema.sql;
    ```

4.  **Build the Project**
    Use Maven to resolve dependencies and compile the Java code.
    ```bash
    mvn clean compile
    ```

5.  **Run the Local Server**
    Start the embedded Jetty server.
    ```bash
    mvn jetty:run
    ```

6.  **Verify**
    Open your browser and navigate to: `http://localhost:8080/frk-collectives/`

## Environment Variables

Refer to `.env.example` for all required configurations.
-   `DB_URL`: Ensure the timezone parameter (`serverTimezone=UTC`) matches your local MySQL configuration to avoid JDBC connection errors.
-   `SESSION_SECRET_KEY`: While optional for local testing, this must be securely generated for production deployments.

## Project Structure

```text
frk-collectives/
├── .env                  # Local secrets (ignored by git)
├── pom.xml               # Maven configuration and dependencies
├── src/
│   └── main/
│       ├── java/         # Backend source code
│       │   └── com/frk/  # Controllers (Servlets), DAOs, and Models
│       ├── resources/    # Application properties and database schemas
│       └── webapp/       # Frontend assets and views
│           ├── css/      # Global styles and animation keyframes
│           ├── js/       # GSAP transition and cursor logic
│           ├── WEB-INF/  # Private server configurations and JSP fragments
│           └── *.jsp     # Publicly accessible views (index, product, cart)
```

## How to run tests

Currently, tests are run via the Maven Surefire plugin.
```bash
mvn test
```
*Expected output: A summary of passed/failed unit tests for the DAOs and Servlets.*

## Common errors and fixes

**Error**: `java.sql.SQLException: Access denied for user 'root'@'localhost'`
**Cause**: The `DB_PASSWORD` in your `.env` file is incorrect or MySQL is not running.
**Fix**: Verify your MySQL credentials and ensure the service is active (`services.msc` on Windows or `brew services start mysql` on Mac).

**Error**: `Address already in use: bind`
**Cause**: Another application is using port 8080.
**Fix**: Kill the existing process (e.g., `Stop-Process -Name java -Force` on Windows) or change the Jetty port in `pom.xml`.

**Error**: `NullPointerException` on page load
**Cause**: The database connection succeeded, but the tables are empty or missing.
**Fix**: Ensure you have run the schema and seed scripts to populate `requestScope.featuredProducts`.

## Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please refer to `COMMIT_GUIDE.md` for our conventional commit standards and pre-commit checklist.

## License

This project is licensed under the MIT License - you are free to use, modify, and distribute this software.

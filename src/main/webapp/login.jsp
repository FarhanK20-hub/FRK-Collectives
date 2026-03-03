<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login | FRK Collectives</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
        </head>

        <body>

            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-brand">
                        <h1>FRK COLLECTIVES</h1>
                        <p>Wear the Vision</p>
                    </div>

                    <h2 class="auth-title">Sign In</h2>

                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-error">${requestScope.error}</div>
                    </c:if>
                    <c:if test="${not empty requestScope.success}">
                        <div class="alert alert-success">${requestScope.success}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control"
                                value="${requestScope.email}" required placeholder="your@email.com">
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" class="form-control" required
                                placeholder="Enter your password">
                        </div>
                        <div class="form-group">
                            <label class="form-check">
                                <input type="checkbox" name="remember"> Remember me
                            </label>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">Sign In</button>
                    </form>

                    <div class="auth-footer">
                        <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Create
                                Account</a></p>
                        <p style="margin-top:8px;"><a href="${pageContext.request.contextPath}/home"
                                style="font-weight:400;">← Back to Home</a></p>
                    </div>
                </div>
            </div>

        </body>

        </html>
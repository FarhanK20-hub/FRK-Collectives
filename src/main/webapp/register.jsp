<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Create Account | FRK Collectives</title>
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

                    <h2 class="auth-title">Create Account</h2>

                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-error">${requestScope.error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" class="form-control" value="${requestScope.name}"
                                required placeholder="Your full name">
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control"
                                value="${requestScope.email}" required placeholder="your@email.com">
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="form-control" value="${requestScope.phone}"
                                placeholder="9876543210">
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" id="password" name="password" class="form-control" required
                                    placeholder="Min 6 characters">
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Confirm Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                                    required placeholder="Confirm password">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">Create Account</button>
                    </form>

                    <div class="auth-footer">
                        <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign In</a></p>
                        <p style="margin-top:8px;"><a href="${pageContext.request.contextPath}/home"
                                style="font-weight:400;">← Back to Home</a></p>
                    </div>
                </div>
            </div>

        </body>

        </html>
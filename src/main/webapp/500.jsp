<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Server Error | FRK Collectives</title>
        <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=DM+Sans:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css?v=4.0">
    </head>

    <body>
        <div class="error-container">
            <div class="error-code">500</div>
            <h1 class="error-title">Internal Server Error</h1>
            <p class="error-message">Something went wrong on our end. Please try again later.</p>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Back to Home</a>
        </div>
    </body>

    </html>
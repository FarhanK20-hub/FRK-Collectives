<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Premium Sticky Navbar -->
<nav class="navbar page-navbar" id="mainNav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/home" class="nav-brand">FRK COLLECTIVES</a>

        <div class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('active')">
            <span></span><span></span><span></span>
        </div>

        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/products">Shop</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/wishlist">Wishlist</a>
                    <a href="${pageContext.request.contextPath}/dashboard">Account</a>
                    <c:if test="${sessionScope.user.admin}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">Login</a>
                </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/cart" class="cart-link">
                Bag
                <c:if test="${not empty sessionScope.cart}">
                    <span class="cart-count">${sessionScope.cart.size()}</span>
                </c:if>
            </a>
        </div>
    </div>
</nav>

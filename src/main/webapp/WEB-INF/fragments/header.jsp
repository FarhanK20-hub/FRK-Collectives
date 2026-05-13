<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Premium Dark Navbar -->
<nav class="navbar page-navbar" id="mainNav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/home" class="nav-brand">FRK Collectives</a>

        <div class="nav-center">
            <!-- Centered content removed in favor of minimalist icon-only navigation -->
        </div>

        <div class="nav-right">
            <a href="${pageContext.request.contextPath}/products" class="nav-icon-link" aria-label="Shop">
                <i data-feather="grid" style="width: 20px; height: 20px;"></i>
            </a>
            
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/login" class="nav-icon-link" aria-label="Login">
                    <i data-feather="user" style="width: 20px; height: 20px;"></i>
                </a>
            </c:if>

            <c:if test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/dashboard" class="nav-icon-link" aria-label="Account">
                    <i data-feather="user" style="width: 20px; height: 20px;"></i>
                </a>
                <a href="${pageContext.request.contextPath}/wishlist" class="nav-icon-link" aria-label="Wishlist">
                    <i data-feather="heart" style="width: 20px; height: 20px;"></i>
                </a>
            </c:if>

            <c:if test="${not empty sessionScope.user && sessionScope.user.admin}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-icon-link" aria-label="Admin">
                    <i data-feather="shield" style="width: 20px; height: 20px;"></i>
                </a>
            </c:if>

            <a href="${pageContext.request.contextPath}/cart" class="nav-icon-link cart-link" aria-label="Cart">
                <i data-feather="shopping-bag" style="width: 20px; height: 20px;"></i>
                <c:if test="${not empty sessionScope.cart}">
                    <span class="cart-count">${sessionScope.cart.size()}</span>
                </c:if>
            </a>

            <c:if test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/logout" class="nav-icon-link" aria-label="Logout">
                    <i data-feather="log-out" style="width: 20px; height: 20px;"></i>
                </a>
            </c:if>
        </div>

        <button class="nav-toggle" onclick="document.querySelector('.nav-overlay').classList.add('active')" aria-label="Menu">
            <span></span><span></span>
        </button>
    </div>
</nav>

<!-- Mobile Full-Screen Overlay Menu -->
<div class="nav-overlay" id="navOverlay">
    <button class="nav-overlay-close" onclick="this.parentElement.classList.remove('active')" aria-label="Close menu">&times;</button>
    <div class="nav-overlay-links">
        <a href="${pageContext.request.contextPath}/products" onclick="this.closest('.nav-overlay').classList.remove('active')">Shop</a>
        <c:if test="${not empty sessionScope.user}">
            <a href="${pageContext.request.contextPath}/wishlist">Wishlist</a>
            <a href="${pageContext.request.contextPath}/dashboard">Account</a>
            <a href="${pageContext.request.contextPath}/cart">Bag</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </c:if>
        <c:if test="${empty sessionScope.user}">
            <a href="${pageContext.request.contextPath}/login">Login</a>
            <a href="${pageContext.request.contextPath}/register">Register</a>
        </c:if>
    </div>
</div>

<!-- Toast Container -->
<div id="toastContainer" class="toast-container"></div>

<script>
// Toast notification system
function showToast(message, type) {
    var container = document.getElementById('toastContainer');
    var toast = document.createElement('div');
    toast.className = 'toast toast-' + (type || 'success');
    toast.textContent = message;
    container.appendChild(toast);
    requestAnimationFrame(function() { toast.classList.add('show'); });
    setTimeout(function() {
        toast.classList.remove('show');
        setTimeout(function() { toast.remove(); }, 300);
    }, 3000);
}
</script>

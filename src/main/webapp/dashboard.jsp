<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>My Account | FRK Collectives</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
            </head>

            <body class="bg-light">

                <%@ include file="/WEB-INF/fragments/header.jsp" %>

                    <div class="container">
                        <div class="dashboard-layout">
                            <!-- Sidebar Nav -->
                            <aside class="dashboard-sidebar">
                                <div class="dashboard-nav">
                                    <a href="${pageContext.request.contextPath}/dashboard"
                                        class="${activeTab == 'profile' ? 'active' : ''}">Profile</a>
                                    <a href="${pageContext.request.contextPath}/dashboard/orders"
                                        class="${activeTab == 'orders' ? 'active' : ''}">Orders</a>
                                    <a href="${pageContext.request.contextPath}/dashboard/addresses"
                                        class="${activeTab == 'addresses' ? 'active' : ''}">Addresses</a>
                                    <a href="${pageContext.request.contextPath}/wishlist">Wishlist</a>
                                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                                </div>
                            </aside>

                            <!-- Content -->
                            <div class="dashboard-content">

                                <!-- Profile Tab -->
                                <c:if test="${activeTab == 'profile'}">
                                    <div class="dashboard-section">
                                        <h2>My Profile</h2>

                                        <c:if test="${not empty requestScope.success}">
                                            <div class="alert alert-success">${requestScope.success}</div>
                                        </c:if>
                                        <c:if test="${not empty requestScope.error}">
                                            <div class="alert alert-error">${requestScope.error}</div>
                                        </c:if>

                                        <form action="${pageContext.request.contextPath}/dashboard/profile"
                                            method="post">
                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label>Full Name</label>
                                                    <input type="text" name="name" class="form-control"
                                                        value="${profileUser != null ? profileUser.name : sessionScope.user.name}"
                                                        required>
                                                </div>
                                                <div class="form-group">
                                                    <label>Email</label>
                                                    <input type="email" class="form-control"
                                                        value="${sessionScope.user.email}" disabled>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label>Phone</label>
                                                <input type="tel" name="phone" class="form-control"
                                                    value="${profileUser != null ? profileUser.phone : sessionScope.user.phone}">
                                            </div>
                                            <button type="submit" class="btn btn-primary">Save Changes</button>
                                        </form>
                                    </div>
                                </c:if>

                                <!-- Orders Tab -->
                                <c:if test="${activeTab == 'orders'}">
                                    <div class="dashboard-section">
                                        <h2>Order History</h2>
                                        <c:choose>
                                            <c:when test="${empty requestScope.orders}">
                                                <div class="empty-state">
                                                    <p>No orders yet.</p>
                                                    <a href="${pageContext.request.contextPath}/products"
                                                        class="btn btn-primary mt-4">Start Shopping</a>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="order" items="${requestScope.orders}">
                                                    <div class="order-card">
                                                        <div class="order-header">
                                                            <span class="order-id">Order #FRK${order.id}</span>
                                                            <span
                                                                class="order-status status-${order.status.toLowerCase()}">${order.status}</span>
                                                        </div>
                                                        <div class="order-details">
                                                            <p>${order.createdAt} · ${order.itemCount} item(s)</p>
                                                            <c:forEach var="item" items="${order.items}">
                                                                <p>${item.productName} (${item.size}) × ${item.quantity}
                                                                </p>
                                                            </c:forEach>
                                                        </div>
                                                        <p class="order-total">
                                                            <frk:formatCurrency value="${order.grandTotal}" />
                                                        </p>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>

                                <!-- Addresses Tab -->
                                <c:if test="${activeTab == 'addresses'}">
                                    <div class="dashboard-section">
                                        <h2>Saved Addresses</h2>

                                        <c:forEach var="addr" items="${requestScope.addresses}">
                                            <div class="order-card">
                                                <div class="order-header">
                                                    <span class="order-id">${addr.name}</span>
                                                    <c:if test="${addr.isDefault}">
                                                        <span class="order-status status-confirmed">Default</span>
                                                    </c:if>
                                                </div>
                                                <div class="order-details">
                                                    <p>${addr.fullAddress}</p>
                                                    <p>Phone: ${addr.phone}</p>
                                                </div>
                                                <form
                                                    action="${pageContext.request.contextPath}/dashboard/address/delete"
                                                    method="post" style="margin-top:8px;">
                                                    <input type="hidden" name="addressId" value="${addr.id}">
                                                    <button type="submit" class="btn-link text-danger">Delete</button>
                                                </form>
                                            </div>
                                        </c:forEach>

                                        <!-- Add Address Form -->
                                        <h3 style="margin-top:32px; margin-bottom:16px;">Add New Address</h3>
                                        <form action="${pageContext.request.contextPath}/dashboard/address/add"
                                            method="post">
                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label>Full Name</label>
                                                    <input type="text" name="addressName" class="form-control" required>
                                                </div>
                                                <div class="form-group">
                                                    <label>Phone</label>
                                                    <input type="tel" name="addressPhone" class="form-control" required>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label>Address Line 1</label>
                                                <input type="text" name="line1" class="form-control" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Address Line 2</label>
                                                <input type="text" name="line2" class="form-control">
                                            </div>
                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label>City</label>
                                                    <input type="text" name="city" class="form-control" required>
                                                </div>
                                                <div class="form-group">
                                                    <label>State</label>
                                                    <input type="text" name="state" class="form-control" required>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label>Pincode</label>
                                                    <input type="text" name="pincode" class="form-control" required>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-check" style="margin-top:24px;">
                                                        <input type="checkbox" name="isDefault"> Set as Default
                                                    </label>
                                                </div>
                                            </div>
                                            <button type="submit" class="btn btn-primary">Add Address</button>
                                        </form>
                                    </div>
                                </c:if>

                            </div>
                        </div>
                    </div>

                    <%@ include file="/WEB-INF/fragments/footer.jsp" %>

            </body>

            </html>
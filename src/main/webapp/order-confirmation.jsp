<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Order Confirmed | FRK Collectives</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
            </head>

            <body class="bg-light">

                <%@ include file="/WEB-INF/fragments/header.jsp" %>

                    <div class="container main-content">
                        <div class="confirmation-container">
                            <div class="confirmation-icon">&#10003;</div>
                            <h1 class="confirmation-title">Order Confirmed</h1>
                            <p class="confirmation-message">
                                Thank you for your order, ${order.shippingName}. We'll send you a confirmation email
                                shortly.
                            </p>

                            <div class="confirmation-details">
                                <h3 style="margin-bottom:16px;">Order Details</h3>
                                <div class="summary-line">
                                    <span>Order ID</span>
                                    <span><strong>#FRK${order.id}</strong></span>
                                </div>
                                <div class="summary-line">
                                    <span>Status</span>
                                    <span class="order-status status-confirmed">Confirmed</span>
                                </div>
                                <hr>
                                <c:forEach var="item" items="${order.items}">
                                    <div class="summary-line">
                                        <span>${item.productName} (${item.size}) x${item.quantity}</span>
                                        <span>
                                            <frk:formatCurrency value="${item.lineTotal}" />
                                        </span>
                                    </div>
                                </c:forEach>
                                <hr>
                                <div class="summary-line">
                                    <span>Subtotal</span>
                                    <span>
                                        <frk:formatCurrency value="${order.subtotal}" />
                                    </span>
                                </div>
                                <c:if test="${order.discount > 0}">
                                    <div class="summary-line text-success">
                                        <span>Discount (${order.couponCode})</span>
                                        <span>-
                                            <frk:formatCurrency value="${order.discount}" />
                                        </span>
                                    </div>
                                </c:if>
                                <div class="summary-line">
                                    <span>GST (18%)</span>
                                    <span>
                                        <frk:formatCurrency value="${order.gst}" />
                                    </span>
                                </div>
                                <div class="summary-line">
                                    <span>Shipping</span>
                                    <span>${order.shipping == 0 ? 'Free' : ''}<c:if test="${order.shipping > 0}">
                                            <frk:formatCurrency value="${order.shipping}" />
                                        </c:if></span>
                                </div>
                                <hr>
                                <div class="summary-line total-line">
                                    <span>Grand Total</span>
                                    <span>
                                        <frk:formatCurrency value="${order.grandTotal}" />
                                    </span>
                                </div>
                            </div>

                            <div style="display:flex; gap:12px; justify-content:center; flex-wrap:wrap;">
                                <a href="${pageContext.request.contextPath}/dashboard/orders"
                                    class="btn btn-primary">View Orders</a>
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">Continue
                                    Shopping</a>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/WEB-INF/fragments/footer.jsp" %>

            </body>

            </html>
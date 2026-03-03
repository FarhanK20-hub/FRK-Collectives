<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Checkout | FRK Collectives</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
            </head>

            <body class="bg-light">

                <%@ include file="/WEB-INF/fragments/header.jsp" %>

                    <div class="container main-content">
                        <h2 class="section-title">Checkout</h2>

                        <c:if test="${not empty requestScope.error}">
                            <div class="alert alert-error">${requestScope.error}</div>
                        </c:if>

                        <div class="checkout-layout">
                            <!-- Shipping Form -->
                            <div class="checkout-form-section">
                                <h3>Shipping Information</h3>
                                <form action="${pageContext.request.contextPath}/checkout" method="post">
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="shippingName">Full Name</label>
                                            <input type="text" id="shippingName" name="shippingName"
                                                class="form-control" value="${sessionScope.user.name}" required>
                                        </div>
                                        <div class="form-group">
                                            <label for="shippingPhone">Phone Number</label>
                                            <input type="tel" id="shippingPhone" name="shippingPhone"
                                                class="form-control" value="${sessionScope.user.phone}" required>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="shippingAddress">Shipping Address</label>
                                        <textarea id="shippingAddress" name="shippingAddress" class="form-control"
                                            rows="3" required
                                            placeholder="Street address, City, State, Pincode"><c:if test="${not empty requestScope.addresses}">${requestScope.addresses[0].fullAddress}</c:if></textarea>
                                    </div>

                                    <!-- Saved Addresses -->
                                    <c:if test="${not empty requestScope.addresses}">
                                        <div class="form-group">
                                            <label>Saved Addresses</label>
                                            <c:forEach var="addr" items="${requestScope.addresses}">
                                                <div class="alert alert-info" style="cursor:pointer; margin-bottom:8px;"
                                                    onclick="document.getElementById('shippingName').value='${addr.name}'; document.getElementById('shippingPhone').value='${addr.phone}'; document.getElementById('shippingAddress').value='${addr.fullAddress}';">
                                                    <strong>${addr.name}</strong> — ${addr.fullAddress}
                                                    ${addr.isDefault ? '(Default)' : ''}
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <!-- Coupon Code -->
                                    <div class="form-group">
                                        <label for="couponCode">Coupon Code (Optional)</label>
                                        <div class="coupon-row">
                                            <input type="text" id="couponCode" name="couponCode" class="form-control"
                                                placeholder="e.g. FRK10">
                                        </div>
                                        <small class="text-muted">Try FRK10 (10% off) or FRK20 (20% off)</small>
                                    </div>

                                    <button type="submit" class="btn btn-primary btn-block btn-lg">Place Order</button>
                                </form>
                            </div>

                            <!-- Order Summary -->
                            <div class="checkout-summary-section">
                                <h3>Order Summary</h3>
                                <c:forEach var="item" items="${sessionScope.cart}">
                                    <div class="checkout-item">
                                        <span>
                                            <span class="checkout-item-qty">x${item.quantity}</span>
                                            ${item.product.name} (${item.selectedSize})
                                        </span>
                                        <span>
                                            <frk:formatCurrency value="${item.subtotal}" />
                                        </span>
                                    </div>
                                </c:forEach>
                                <hr>
                                <div class="summary-line">
                                    <span>Subtotal</span>
                                    <span>
                                        <frk:formatCurrency value="${requestScope.subtotal}" />
                                    </span>
                                </div>
                                <div class="summary-line">
                                    <span>GST (18%)</span>
                                    <span>
                                        <frk:formatCurrency value="${requestScope.gst}" />
                                    </span>
                                </div>
                                <div class="summary-line">
                                    <span>Shipping</span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${requestScope.shipping == 0}"><span
                                                    class="text-success">Free</span></c:when>
                                            <c:otherwise>
                                                <frk:formatCurrency value="${requestScope.shipping}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <hr>
                                <div class="summary-line total-line">
                                    <span>Grand Total</span>
                                    <span>
                                        <frk:formatCurrency value="${requestScope.grandTotal}" />
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/WEB-INF/fragments/footer.jsp" %>

            </body>

            </html>
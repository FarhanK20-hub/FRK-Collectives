package com.frk.util;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 * Application-wide constants for FRK Collectives.
 * Centralizes session keys, business rules, and enum values.
 */
public final class Constants {

    private Constants() {} // Prevent instantiation

    // ==================== SESSION ATTRIBUTE KEYS ====================
    public static final String SESSION_USER = "user";
    public static final String SESSION_CART = "cart";
    public static final String SESSION_REDIRECT = "redirectAfterLogin";

    // ==================== USER ROLES ====================
    public static final String ROLE_CUSTOMER = "CUSTOMER";
    public static final String ROLE_ADMIN = "ADMIN";

    // ==================== ORDER STATUSES ====================
    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_CONFIRMED = "CONFIRMED";
    public static final String STATUS_SHIPPED = "SHIPPED";
    public static final String STATUS_DELIVERED = "DELIVERED";
    public static final String STATUS_CANCELLED = "CANCELLED";

    public static final Set<String> VALID_ORDER_STATUSES = Collections.unmodifiableSet(
            new HashSet<>(Arrays.asList(
                    STATUS_PENDING, STATUS_CONFIRMED, STATUS_SHIPPED,
                    STATUS_DELIVERED, STATUS_CANCELLED)));

    // ==================== BUSINESS RULES ====================
    public static final double GST_RATE = 0.18;
    public static final double FREE_SHIPPING_THRESHOLD = 2999.0;
    public static final double SHIPPING_FEE = 199.0;
    public static final int SESSION_TIMEOUT_MINUTES = 30;

    // ==================== VALIDATION ====================
    public static final int MIN_PASSWORD_LENGTH = 6;
    public static final int MAX_REVIEW_RATING = 5;
    public static final int MIN_REVIEW_RATING = 1;

    /**
     * Checks if a string is null or blank.
     */
    public static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /**
     * Safely parses an integer, returning a default value on failure.
     */
    public static int safeParseInt(String s, int defaultValue) {
        if (isBlank(s)) return defaultValue;
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Safely parses a double, returning a default value on failure.
     */
    public static double safeParseDouble(String s, double defaultValue) {
        if (isBlank(s)) return defaultValue;
        try {
            return Double.parseDouble(s.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Validates that a redirect URL is safe (same-origin).
     */
    public static boolean isSafeRedirect(String url, String contextPath) {
        if (isBlank(url)) return false;
        // Must start with the context path (relative) and not contain protocol markers
        return url.startsWith(contextPath) && !url.contains("://") && !url.startsWith("//");
    }
}

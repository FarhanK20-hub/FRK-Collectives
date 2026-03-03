package com.frk.filter;

import com.frk.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AuthFilter — Protects customer routes that require authentication.
 * Redirects unauthenticated users to the login page.
 */
@WebFilter(urlPatterns = { "/dashboard/*", "/checkout", "/wishlist", "/wishlist/*" })
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpRes = (HttpServletResponse) response;

        HttpSession session = httpReq.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Store the requested URL for redirect after login
            String requestedUrl = httpReq.getRequestURI();
            String queryString = httpReq.getQueryString();
            if (queryString != null) {
                requestedUrl += "?" + queryString;
            }

            if (session == null) {
                session = httpReq.getSession(true);
            }
            session.setAttribute("redirectAfterLogin", requestedUrl);

            httpRes.sendRedirect(httpReq.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

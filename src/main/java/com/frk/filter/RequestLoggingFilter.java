package com.frk.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * RequestLoggingFilter — Logs method, URI, and response time for every request.
 */
@WebFilter(urlPatterns = "/*")
public class RequestLoggingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        String uri = httpReq.getRequestURI();

        // Skip logging for static resources
        if (uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") ||
            uri.endsWith(".jpg") || uri.endsWith(".jpeg") || uri.endsWith(".gif") ||
            uri.endsWith(".ico") || uri.endsWith(".woff") || uri.endsWith(".woff2")) {
            chain.doFilter(request, response);
            return;
        }

        long startTime = System.currentTimeMillis();
        String method = httpReq.getMethod();

        chain.doFilter(request, response);

        long duration = System.currentTimeMillis() - startTime;
        System.out.println("[FRK] " + method + " " + uri + " — " + duration + "ms");
    }

    @Override
    public void destroy() {
    }
}

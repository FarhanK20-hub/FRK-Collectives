package com.frk.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * StaticResourceFilter — Sets cache headers for static assets (CSS, JS, images).
 */
@WebFilter(urlPatterns = { "/css/*", "/images/*", "*.js" })
public class StaticResourceFilter implements Filter {

    private static final long ONE_WEEK_SECONDS = 7 * 24 * 60 * 60;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletResponse httpRes = (HttpServletResponse) response;

        // Set cache headers — browser can cache static assets for 1 week
        httpRes.setHeader("Cache-Control", "public, max-age=" + ONE_WEEK_SECONDS);
        httpRes.setDateHeader("Expires", System.currentTimeMillis() + ONE_WEEK_SECONDS * 1000);

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}

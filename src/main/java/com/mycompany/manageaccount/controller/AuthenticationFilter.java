package com.mycompany.manageaccount.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Always prevent caching to avoid back-button showing stale pages
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        httpResponse.setHeader("Pragma", "no-cache"); // HTTP 1.0
        httpResponse.setDateHeader("Expires", 0); // Proxies
        
        // Define public paths that don't require authentication
        boolean isPublicPath = requestURI.equals(contextPath + "/") ||
                              requestURI.equals(contextPath + "/auth/showLogin") ||
                              requestURI.equals(contextPath + "/auth/login") ||
                              requestURI.equals(contextPath + "/auth/showRegister") ||
                              requestURI.equals(contextPath + "/auth/register") ||
                              requestURI.equals(contextPath + "/login.jsp") ||
                              requestURI.equals(contextPath + "/register.jsp") ||
                              requestURI.equals(contextPath + "/Error.jsp") ||
                              requestURI.contains("/css/") ||
                              requestURI.contains("/js/") ||
                              requestURI.contains("/images/");
        
        // Check if user is authenticated
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        // If already logged in and trying to access login/register pages, redirect to dashboard
        boolean isAuthPage = requestURI.equals(contextPath + "/auth/showLogin") ||
                             requestURI.equals(contextPath + "/auth/login") ||
                             requestURI.equals(contextPath + "/login.jsp") ||
                             requestURI.equals(contextPath + "/auth/showRegister") ||
                             requestURI.equals(contextPath + "/auth/register") ||
                             requestURI.equals(contextPath + "/register.jsp");
        if (isLoggedIn && isAuthPage) {
            httpResponse.sendRedirect(contextPath + "/dashboard");
            return;
        }
        
        if (isPublicPath || isLoggedIn) {
            // Allow access to public paths or authenticated users
            chain.doFilter(request, response);
        } else {
            // Redirect to login page for unauthenticated users
            httpResponse.sendRedirect(contextPath + "/auth/showLogin");
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
} 
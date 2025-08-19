<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Error - User Management System</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <style>
            html, body { height: 100%; margin: 0; }
            body {
                background: linear-gradient(135deg, #f3f4f7 0%, #e9eef7 100%);
                font-size: 0.95rem;
            }
            .error-container {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 16px;
            }
            .error-card {
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 12px 24px rgba(0,0,0,0.08);
                width: 100%;
                max-width: 720px;
                padding: 18px 20px;
                text-align: center;
            }
            .error-icon { font-size: 48px; color: #dc3545; margin-bottom: 8px; }
            .error-title { font-size: 1.4rem; margin-bottom: 6px; }
            .error-subtitle { font-size: 0.95rem; color: #6c757d; margin-bottom: 14px; }
            .error-details {
                background-color: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 6px;
                padding: 12px;
                text-align: left;
                max-height: 40vh;
                overflow: auto;
            }
            .btn-compact { padding: 0.45rem 0.9rem; font-size: 0.95rem; border-radius: 6px; }
        </style>
    </head>
    <body>
            <div class="error-container">
            <div class="error-card">
                <div class="error-icon">⚠️</div>
                <h1 class="text-danger error-title">Oops! Something went wrong</h1>
                <p class="error-subtitle">We encountered an error while processing your request.</p>
                
                <div class="error-details">
                    <h6 class="mb-2">Error Details</h6>
                    <% 
                    Exception requestException = (Exception) request.getAttribute("exception");
                    Exception pageException = (Exception) pageContext.getException();                
                    Exception ex = requestException != null ? requestException : pageException;                   
                    if (ex != null) { 
                    %>
                        <p class="mb-1"><strong>Message:</strong> <%= ex.getMessage() %></p>
                        <p class="mb-1"><strong>Type:</strong> <%= ex.getClass().getSimpleName() %></p>
                        <% if (ex.getCause() != null) { %>
                            <p class="mb-1"><strong>Cause:</strong> <%= ex.getCause().getMessage() %></p>
                        <% } %>
                        <% if (ex instanceof java.sql.SQLException) { %>
                            <p class="mb-1"><strong>SQL State:</strong> <%= ((java.sql.SQLException) ex).getSQLState() %></p>
                            <p class="mb-0"><strong>Error Code:</strong> <%= ((java.sql.SQLException) ex).getErrorCode() %></p>
                        <% } %>
                        <% if (ex instanceof java.lang.NumberFormatException) { %>
                            <p class="mb-0"><strong>Issue:</strong> Invalid number format. Please check the ID parameter.</p>
                        <% } %>
                    <% } else { %>
                        <p class="mb-0">No specific error information available.</p>
                    <% } %>
                </div>                
                <div class="mt-3">
                    <a href="<%=request.getContextPath()%>/" class="btn btn-primary btn-compact">Home</a>
                    <a href="javascript:history.back()" class="btn btn-secondary btn-compact">Back</a>
                </div>
            </div>
        </div>
    </body>
</html>
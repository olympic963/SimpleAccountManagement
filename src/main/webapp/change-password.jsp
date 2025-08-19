<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .container-narrow { max-width: 520px; margin: 24px auto; }
        .card { border-radius: 14px; box-shadow: 0 14px 28px rgba(0,0,0,0.12); }
        .card-body { padding: 18px; }
        .form-group label { font-weight: 600; font-size: 0.95rem; }
        .form-control { font-size: 0.95rem; padding: 0.45rem 0.75rem; }
        .btn { font-size: 0.95rem; }
    </style>
</head>
<body>
<header>
    <nav class="navbar navbar-expand-md navbar-dark" style="background-color: tomato">
        <div>
            <a href="/ManageAccount" class="navbar-brand">User Management App</a>
        </div>
        <ul class="navbar-nav ml-auto">
            <li><a href="${pageContext.request.contextPath}/dashboard" class="nav-link">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/auth/logout" class="nav-link">Logout</a></li>
        </ul>
    </nav>
</header>

<div class="container container-narrow">
    <div class="card">
        <div class="card-body">
            <h4 class="mb-3">Change Password</h4>
            <form action="${pageContext.request.contextPath}/do-change-password" method="post">
                <input type="hidden" name="id" value="${targetUserId}"/>
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'admin'}">
                        <div class="alert alert-info py-2">You are changing a password as an admin. Old password is not required.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="form-group">
                            <label>Old password</label>
                            <input type="password" class="form-control" name="oldPassword" required>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="form-group">
                    <label>New password</label>
                    <input type="password" class="form-control" name="newPassword" required>
                </div>
                <div class="form-group">
                    <label>Confirm new password</label>
                    <input type="password" class="form-control" name="confirmPassword" required>
                </div>

                <button type="submit" class="btn btn-success">Save</button>
                <a href="${pageContext.request.contextPath}/profile?id=${sessionScope.user.id}" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </div>
</div>
</body>
</html> 
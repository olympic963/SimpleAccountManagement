<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
    <head>
        <title>User Profile</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            .profile-container {
                min-height: calc(100vh - 56px);
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 16px 0;
            }
            .profile-card {
                background: white;
                border-radius: 14px;
                box-shadow: 0 14px 28px rgba(0,0,0,0.12);
                overflow: hidden;
            }
            .profile-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 18px;
                text-align: center;
            }
            .profile-avatar {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                background: rgba(255,255,255,0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1rem;
                font-size: 2.2rem;
            }
            .profile-body {
                padding: 18px;
            }
            .info-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 0;
                border-bottom: 1px solid #eee;
            }
            .info-row:last-child {
                border-bottom: none;
            }
            .info-label {
                font-weight: 600;
                color: #333;
                font-size: 0.98rem;
            }
            .info-value {
                color: #666;
                font-size: 0.98rem;
            }
            .role-badge {
                font-size: 0.8em;
                padding: 0.25em 0.6em;
            }
            .btn-custom {
                border-radius: 22px;
                padding: 0.45rem 1.2rem;
                font-weight: 500;
                transition: all 0.2s ease;
                font-size: 0.95rem;
            }
            .btn-custom:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            }
        </style>
    </head>

    <body>
        <header>
            <nav class="navbar navbar-expand-md navbar-dark" style="background-color: tomato">
                <div>
                    <a href="/ManageAccount" class="navbar-brand"> 
                        <i class="fas fa-users mr-2"></i>User Management App 
                    </a>
                </div>

                <ul class="navbar-nav ml-auto">
                    <li><a href="${pageContext.request.contextPath}/profile?id=${user.id}" class="nav-link active">
                        <i class="fas fa-user mr-1"></i>Profile
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/auth/logout" class="nav-link">
                        <i class="fas fa-sign-out-alt mr-1"></i>Logout
                    </a></li>
                </ul>
            </nav>
        </header>

        <div class="profile-container">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="profile-card">
                            <div class="profile-header">
                                <div class="profile-avatar">
                                    <i class="fas fa-user"></i>
                                </div>
                                <h3>${user.name}</h3>
                                <c:choose>
                                    <c:when test="${user.role == 'admin'}">
                                        <span class="badge badge-light role-badge">Administrator</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-light role-badge">User</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="profile-body">
                                <div class="info-row">
                                    <span class="info-label">Username:</span>
                                    <span class="info-value">${user.username}</span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">Email:</span>
                                    <span class="info-value">${user.email}</span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">Phone Number:</span>
                                    <span class="info-value">${user.phoneNumber}</span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">Birth Date:</span>
                                    <span class="info-value">
                                        <c:if test="${user.birthDate != null}">
                                            <fmt:formatDate value="${user.birthDate}" pattern="dd/MM/yyyy"/>
                                        </c:if>
                                        <c:if test="${user.birthDate == null}">
                                            <span class="text-muted">Not specified</span>
                                        </c:if>
                                    </span>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">Role:</span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${user.role == 'admin'}">
                                                <span class="badge badge-danger role-badge">Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-primary role-badge">User</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <div class="text-center mt-4">
                                    <a href="edit?id=${user.id}" class="btn btn-primary btn-custom mr-2">
                                        <i class="fas fa-edit mr-1"></i>Edit Profile
                                    </a>
                                    <a href="${pageContext.request.contextPath}/change-password?id=${user.id}" class="btn btn-warning btn-custom mr-2">
                                        <i class="fas fa-key mr-1"></i>Change Password
                                    </a>
                                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary btn-custom">
                                        <i class="fas fa-home mr-1"></i>Home
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

</html> 
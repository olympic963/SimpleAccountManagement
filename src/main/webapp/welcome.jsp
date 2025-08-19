<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Account Management</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            html, body { height: 100%; margin: 0; }
            body { overflow-x: hidden; }
            .welcome-container {
                min-height: 100vh;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                padding: 8px 0;
            }
            .welcome-card {
                background: white;
                border-radius: 16px;
                padding: 24px;
                box-shadow: 0 14px 28px rgba(0,0,0,0.12);
                text-align: center;
                max-width: 560px;
                width: 95%;
            }
            .welcome-icon { font-size: 56px; color: #667eea; margin-bottom: 12px; }
            .feature-card {
                background: #f8f9fa;
                border-radius: 10px;
                padding: 12px;
                margin: 10px 0;
                border-left: 4px solid #667eea;
                font-size: 0.95rem;
            }
            .btn-custom {
                border-radius: 22px;
                padding: 8px 16px;
                font-weight: 600;
                margin: 6px;
                transition: all 0.2s ease;
                font-size: 0.95rem;
            }
            .btn-custom:hover { transform: translateY(-1px); box-shadow: 0 4px 10px rgba(0,0,0,0.15); }
            .user-info {
                background: #e3f2fd;
                border-radius: 10px;
                padding: 16px;
                margin-bottom: 18px;
                border-left: 4px solid #2196f3;
                font-size: 0.95rem;
            }
            .logout-btn {
                position: absolute; top: 10px; right: 10px;
                background: rgba(255, 255, 255, 0.9);
                border: none; border-radius: 22px; padding: 6px 14px;
                color: #dc3545; font-weight: 600; font-size: 0.9rem; transition: all 0.2s ease;
            }
            .logout-btn:hover { background: #dc3545; color: white; transform: translateY(-1px); }
            .role-badge { font-size: 0.8em; padding: 0.2em 0.5em; }
        </style>
    </head>
    <body>
        <div class="welcome-container">
            <c:if test="${not empty sessionScope.user}">
                <a href="<%=request.getContextPath()%>/auth/logout" class="btn logout-btn">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </c:if>
            
            <div class="welcome-card">
                <div class="welcome-icon"><i class="fas fa-users"></i></div>
                
                <c:if test="${not empty sessionScope.user}">
                    <div class="user-info">
                        <h5 class="mb-2"><i class="fas fa-user-circle mr-2"></i>Welcome, ${sessionScope.user.name}!</h5>
                        <p class="mb-1"><strong>Username:</strong> ${sessionScope.user.username}</p>
                        <p class="mb-1"><strong>Email:</strong> ${sessionScope.user.email}</p>
                        <p class="mb-1"><strong>Phone:</strong> ${sessionScope.user.phoneNumber}</p>
                        <p class="mb-1">
                            <strong>Birth Date:</strong>
                            <c:if test="${sessionScope.user.birthDate != null}">
                                <fmt:formatDate value="${sessionScope.user.birthDate}" pattern="dd/MM/yyyy"/>
                            </c:if>
                            <c:if test="${sessionScope.user.birthDate == null}">
                                <span class="text-muted">Not specified</span>
                            </c:if>
                        </p>
                        <p class="mb-0"><strong>Role:</strong>
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'admin'}"><span class="badge badge-danger role-badge">Administrator</span></c:when>
                                <c:otherwise><span class="badge badge-primary role-badge">User</span></c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:if>
                
                <h2 class="text-primary mb-3" style="font-size: 1.6rem;">Welcome!</h2>
                <p class="lead text-muted mb-4" style="font-size: 1rem;">Account management page</p>
                
                <c:if test="${not empty sessionScope.user}">
                    <div class="row mb-3">
                        <c:if test="${sessionScope.user.role == 'admin'}">
                            <div class="col-md-4">
                                <div class="feature-card">
                                    <i class="fas fa-plus-circle text-primary mb-2" style="font-size: 24px;"></i>
                                    <h6 class="mb-1">Create user</h6>
                                    <p class="text-muted mb-0" style="font-size: 0.9rem;">Create a new account</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="feature-card">
                                    <i class="fas fa-search text-success mb-2" style="font-size: 24px;"></i>
                                    <h6 class="mb-1">Search</h6>
                                    <p class="text-muted mb-0" style="font-size: 0.9rem;">Find users quickly</p>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="feature-card">
                                    <i class="fas fa-list text-info mb-2" style="font-size: 24px;"></i>
                                    <h6 class="mb-1">Manage</h6>
                                    <p class="text-muted mb-0" style="font-size: 0.9rem;">Browse all users</p>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${sessionScope.user.role != 'admin'}">
                            <div class="col-md-12">
                                <div class="feature-card">
                                    <i class="fas fa-user-edit text-primary mb-2" style="font-size: 24px;"></i>
                                    <h6 class="mb-1">Edit information</h6>
                                    <p class="text-muted mb-0" style="font-size: 0.9rem;">Update your profile</p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </c:if>
                
                <div class="mt-2">
                    <c:if test="${empty sessionScope.user}">
                        <a href="<%=request.getContextPath()%>/auth/showLogin" class="btn btn-primary btn-custom"><i class="fas fa-sign-in-alt mr-2"></i>Sign In</a>
                        <a href="<%=request.getContextPath()%>/auth/showRegister" class="btn btn-success btn-custom"><i class="fas fa-user-plus mr-2"></i>Sign Up</a>
                    </c:if>
                    <c:if test="${not empty sessionScope.user && sessionScope.user.role == 'admin'}">
                        <a href="<%=request.getContextPath()%>/list" class="btn btn-primary btn-custom"><i class="fas fa-list mr-2"></i>View users</a>
                        <a href="<%=request.getContextPath()%>/new" class="btn btn-success btn-custom"><i class="fas fa-plus mr-2"></i>Create new user</a>
                    </c:if>
                    <c:if test="${not empty sessionScope.user && sessionScope.user.role != 'admin'}">
                        <a href="edit?id=${sessionScope.user.id}" class="btn btn-success btn-custom"><i class="fas fa-edit mr-2"></i>Edit profile</a>
                    </c:if>
                </div>
                
                <div class="mt-3">
                    <small class="text-muted" style="font-size: 0.9rem;"><i class="fas fa-info-circle mr-1"></i>Built with Java Servlet, JSP and MySQL</small>
                </div>
            </div>
        </div>
    </body>
</html> 
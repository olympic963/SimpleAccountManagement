<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
    <head>
        <title>User Management Application</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            body { overflow-x: hidden; }
            .navbar-brand { font-weight: bold; }
            .btn-action { margin: 0 8px 8px 0; }
            .table th { background-color: #f8f9fa; border-top: none; }
            .search-container { margin-bottom: 20px; }
            .role-badge { font-size: 0.8em; padding: 0.25em 0.6em; }
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
                    <li><a href="<%=request.getContextPath()%>/profile?id=${sessionScope.user.id}" class="nav-link">
                        <i class="fas fa-user mr-1"></i>Profile
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/auth/logout" class="nav-link">
                        <i class="fas fa-sign-out-alt mr-1"></i>Logout
                    </a></li>
                </ul>
            </nav>
        </header>
        <br>
            <div class="container">
                <h3 class="text-center">
                    <i class="fas fa-users mr-2"></i>List of Users
                </h3>
                <hr>
                
                <!-- Search Form -->
                <div class="search-container">
                    <form action="<%=request.getContextPath()%>/search" method="get" class="form-inline justify-content-center">
                        <div class="input-group" style="max-width: 400px;">
                            <input type="text" class="form-control" name="search" 
                                   placeholder="Search by name, email, username..." 
                                   value="${searchTerm}">
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                        <c:if test="${not empty searchTerm}">
                            <a href="<%=request.getContextPath()%>/list" class="btn btn-outline-secondary ml-2">
                                <i class="fas fa-times"></i> Clear
                            </a>
                        </c:if>
                    </form>
                </div>
                
                <div class="container text-left">
                    <a href="<%=request.getContextPath()%>/new" class="btn btn-success">
                        <i class="fas fa-plus mr-1"></i>Add New User
                    </a>
                </div>
                <br>
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Phone Number</th>
                            <th>Birth Date</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${listUser}">
                            <tr>
                                <td><c:out value="${user.id}" /></td>
                                <td><c:out value="${user.name}" /></td>
                                <td><c:out value="${user.username}" /></td>
                                <td><c:out value="${user.email}" /></td>
                                <td><c:out value="${user.phoneNumber}" /></td>
                                <td>
                                    <c:if test="${user.birthDate != null}"><fmt:formatDate value="${user.birthDate}" pattern="dd/MM/yyyy"/></c:if>
                                    <c:if test="${user.birthDate == null}"><span class="text-muted">-</span></c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.role == 'admin'}"><span class="badge badge-danger role-badge">Admin</span></c:when>
                                        <c:otherwise><span class="badge badge-primary role-badge">User</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="edit?id=<c:out value='${user.id}' />" class="btn btn-primary btn-sm btn-action">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <a href="change-password?id=<c:out value='${user.id}' />" class="btn btn-warning btn-sm btn-action">
                                        <i class="fas fa-key"></i> Change Password
                                    </a>
                                    <a href="delete?id=<c:out value='${user.id}' />" class="btn btn-danger btn-sm btn-action" onclick="return confirm('Are you sure you want to delete this user?')">
                                        <i class="fas fa-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <c:if test="${empty listUser}">
                    <div class="text-center text-muted">
                        <i class="fas fa-info-circle mr-2"></i>No users found.
            </div>
                </c:if>
        </div>
    </body>

</html>

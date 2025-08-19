<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>

    <head>
        <title>User Management Application</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <style>
            body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
            .card { border-radius: 14px; box-shadow: 0 14px 28px rgba(0,0,0,0.12); }
            .card-body { padding: 18px; }
            .container.col-md-5 { margin-top: 12px; }
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
                    <li><a href="${pageContext.request.contextPath}/profile?id=${sessionScope.user.id}" class="nav-link">Profile</a></li>
                    <li><a href="${pageContext.request.contextPath}/auth/logout" class="nav-link"><i class="fas fa-sign-out-alt mr-1"></i>Logout</a></li>
                </ul>
            </nav>
        </header>
        <br>
        <div class="container col-md-5">
            <div class="card">
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty editingUser}">
                        <form action="update" method="post">
                                <input type="hidden" name="id" value="<c:out value='${editingUser.id}' />" />
                        </c:when>
                        <c:otherwise>
                            <form action="insert" method="post">
                        </c:otherwise>
                    </c:choose>

                            <caption>
                        <h4 style="font-size: 1.1rem;">
                            <c:choose>
                                <c:when test="${not empty editingUser}">Edit User</c:when>
                                <c:otherwise>Add New User</c:otherwise>
                            </c:choose>
                        </h4>
                            </caption>

                    <fieldset class="form-group">
                        <label>Full Name</label>
                        <input type="text" value="<c:out value='${editingUser.name}' />" class="form-control" name="name" required="required">
                    </fieldset>

                    <fieldset class="form-group">
                        <label>Email</label>
                        <input type="email" value="<c:out value='${editingUser.email}' />" class="form-control" name="email" required="required">
                    </fieldset>

                            <fieldset class="form-group">
                        <label>Phone Number</label>
                        <input type="text" value="<c:out value='${editingUser.phoneNumber}' />" class="form-control" name="phoneNumber" required="required">
                            </fieldset>

                            <fieldset class="form-group">
                        <label>Birth Date</label>
                        <input type="date" value="<c:if test='${editingUser.birthDate != null}'><fmt:formatDate value='${editingUser.birthDate}' pattern='yyyy-MM-dd'/></c:if>" class="form-control" name="birthDate">
                            </fieldset>

                            <fieldset class="form-group">
                        <label>Username</label>
                        <c:choose>
                            <c:when test="${not empty editingUser}">
                                <c:choose>
                                    <c:when test="${sessionScope.user.role == 'admin'}">
                                        <input type="text" value="<c:out value='${editingUser.username}' />" class="form-control" name="username" required="required">
                                    </c:when>
                                    <c:otherwise>
                                        <input type="text" value="<c:out value='${editingUser.username}' />" class="form-control" readonly>
                                        <input type="hidden" name="username" value="<c:out value='${editingUser.username}' />">
                                        <small class="text-muted">Username cannot be changed</small>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <input type="text" class="form-control" name="username" required="required">
                            </c:otherwise>
                        </c:choose>
                            </fieldset>

                    
                    <c:if test="${sessionScope.user.role == 'admin'}">
                        <fieldset class="form-group">
                            <label>Role</label>
                            <select class="form-control" name="role" required="required">
                                <option value="user" <c:if test="${editingUser.role == 'user'}">selected</c:if>>User</option>
                                <option value="admin" <c:if test="${editingUser.role == 'admin'}">selected</c:if>>Admin</option>
                            </select>
                        </fieldset>
                    </c:if>

                            <button type="submit" class="btn btn-success">Save</button>
                    <a href="${pageContext.request.contextPath}/profile?id=${sessionScope.user.id}" class="btn btn-secondary">Cancel</a>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-light">Home</a>
                        </form>
                </div>
            </div>
        </div>
    </body>

</html>

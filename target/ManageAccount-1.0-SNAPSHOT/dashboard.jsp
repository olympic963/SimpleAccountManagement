<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
      .container-full {
        min-height: calc(100vh - 56px);
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .card-dash {
        background: #fff;
        border-radius: 16px;
        box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        padding: 40px;
        text-align: center;
        max-width: 520px;
        width: 100%;
      }
      .card-dash h1 { margin-bottom: 10px; }
      .card-dash p { color: #6c757d; }
      .btn-big {
        border-radius: 30px;
        padding: 14px 28px;
        font-weight: 600;
      }
    </style>
  </head>
  <body>
    <header>
      <nav class="navbar navbar-expand-md navbar-dark" style="background-color: tomato">
        <div>
          <a href="/ManageAccount" class="navbar-brand">
            <i class="fas fa-users mr-2"></i> User Management App
          </a>
        </div>
        <ul class="navbar-nav ml-auto">
          <li><a href="${pageContext.request.contextPath}/profile?id=${sessionScope.user.id}" class="nav-link">
            <i class="fas fa-user mr-1"></i>Profile
          </a></li>
          <li><a href="${pageContext.request.contextPath}/auth/logout" class="nav-link">
            <i class="fas fa-sign-out-alt mr-1"></i>Logout
          </a></li>
        </ul>
      </nav>
    </header>

    <div class="container-full">
      <div class="card-dash">
        <h1 class="text-primary mb-3">Dashboard</h1>
        <p class="mb-4">Choose an option below to continue</p>

        <div class="mb-4">
          <h5 class="mb-3">My account</h5>
          <a class="btn btn-primary btn-big" href="${pageContext.request.contextPath}/profile?id=${sessionScope.user.id}">
            <i class="fas fa-user mr-2"></i>Go to my profile
          </a>
        </div>

        <c:if test="${sessionScope.user.role == 'admin'}">
          <div class="mb-2">
            <h5 class="mb-3">User account management</h5>
            <a class="btn btn-success btn-big" href="${pageContext.request.contextPath}/list">
              <i class="fas fa-users-cog mr-2"></i>Go to user list
            </a>
          </div>
        </c:if>
      </div>
    </div>
  </body>
</html> 
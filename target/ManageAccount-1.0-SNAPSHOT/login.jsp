<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Manage Account</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        html, body { height: 100%; margin: 0; }
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden; /* tránh cuộn dọc cho login */
        }
        .login-container {
            background: white;
            padding: 0.9rem;
            border-radius: 10px;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.12);
            width: 100%;
            max-width: 340px;
        }
        .login-header { text-align: center; margin-bottom: 0.75rem; }
        .login-header h1 { color: #333; font-size: 1.25rem; margin-bottom: 0.2rem; }
        .login-header p { color: #666; font-size: 0.85rem; }
        .form-group { margin-bottom: 0.55rem; }
        .form-group label { display: block; margin-bottom: 0.28rem; color: #333; font-weight: 500; font-size: 0.9rem; }
        .form-group input {
            width: 100%;
            padding: 0.5rem 0.6rem;
            border: 2px solid #e1e5e9;
            border-radius: 5px;
            font-size: 0.9rem;
            transition: border-color 0.2s ease;
        }
        .form-group input:focus { outline: none; border-color: #667eea; }
        .login-btn, .home-btn {
            width: 100%;
            padding: 0.52rem;
            border: none;
            border-radius: 6px;
            font-size: 0.92rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.15s ease;
        }
        .login-btn { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff; }
        .home-btn { background: #f1f3f5; color: #333; margin-top: 0.5rem; }
        .login-btn:hover, .home-btn:hover { transform: translateY(-1px); }
        .register-link { text-align: center; margin-top: 0.6rem; padding-top: 0.6rem; border-top: 1px solid #e1e5e9; font-size: 0.9rem; }
        .register-link a { color: #667eea; text-decoration: none; font-weight: 500; }
        .register-link a:hover { text-decoration: underline; }
        .error-message, .success-message { padding: 0.55rem; border-radius: 5px; margin-bottom: 0.6rem; font-size: 0.9rem; }
        .error-message { background: #fee; color: #c33; border: 1px solid #fcc; }
        .success-message { background: #efe; color: #363; border: 1px solid #cfc; }
        .password-wrapper { position: relative; }
        .toggle-password { position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: transparent; border: none; color: #667eea; font-weight: 600; cursor: pointer; font-size: 0.85rem; }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>Welcome Back</h1>
            <p>Sign in to your account</p>
        </div>
        
        <c:if test="${not empty errorMessage}"><div class="error-message">${errorMessage}</div></c:if>
        <c:if test="${not empty successMessage}"><div class="success-message">${successMessage}</div></c:if>
        
        <form action="${pageContext.request.contextPath}/auth/login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" value="${username}" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <div class="password-wrapper">
                    <input type="password" id="password" name="password" required>
                    <button type="button" class="toggle-password" data-target="password">Show</button>
                </div>
            </div>
            <button type="submit" class="login-btn">Sign In</button>
        </form>
        
        <div class="register-link">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/auth/showRegister">Sign up</a></p>
        </div>
        
        <button type="button" class="home-btn" onclick="location.href='${pageContext.request.contextPath}/'">
            <i class="fas fa-home mr-1"></i> Home
        </button>
    </div>

    <script>
        (function(){
            var buttons = document.querySelectorAll('.toggle-password');
            Array.prototype.forEach.call(buttons, function(btn){
                btn.addEventListener('click', function(){
                    var targetId = btn.getAttribute('data-target');
                    var input = document.getElementById(targetId);
                    if (!input) return;
                    var isPwd = input.getAttribute('type') === 'password';
                    input.setAttribute('type', isPwd ? 'text' : 'password');
                    btn.textContent = isPwd ? 'Hide' : 'Show';
                });
            });
        })();
    </script>
</body>
</html> 
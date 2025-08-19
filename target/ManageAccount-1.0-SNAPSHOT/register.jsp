<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Manage Account</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        html, body { height: 100%; margin: 0; }
        * { box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: block;
            padding: 1.25rem 0;
            overflow-y: auto;
            overflow-x: hidden;
        }
        .register-container {
            background: white; padding: 1.25rem; border-radius: 10px;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.12);
            width: 100%; max-width: 520px; margin: 0 auto;
            /* Thu nhỏ hiển thị như 75% nhưng giữ zoom 100% */
            zoom: 0.75;
        }
        /* Fallback cho Firefox (zoom không hỗ trợ) */
        @supports not (zoom: 1) {
            .register-container { transform: scale(0.75); transform-origin: top center; }
        }
        .register-header { text-align: center; margin-bottom: 1rem; }
        .register-header h1 { color: #333; font-size: 1.4rem; margin-bottom: 0.25rem; }
        .register-header p { color: #666; font-size: 0.9rem; }
        .form-row { display: flex; gap: 0.75rem; margin-bottom: 0.9rem; }
        .form-group { flex: 1; }
        .form-group.full-width { flex: none; width: 100%; margin-bottom: 0.9rem; }
        .form-group label { display: block; margin-bottom: 0.4rem; color: #333; font-weight: 500; font-size: 0.95rem; }
        .form-group input { width: 100%; padding: 0.6rem 0.75rem; border: 2px solid #e1e5e9; border-radius: 5px; font-size: 0.95rem; transition: border-color 0.2s ease; }
        .form-group input:focus { outline: none; border-color: #667eea; }
        .register-btn, .home-btn { width: 100%; padding: 0.6rem; border: none; border-radius: 6px; font-size: 0.95rem; font-weight: 600; cursor: pointer; transition: transform 0.15s ease; }
        .register-btn { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .home-btn { background: #f1f3f5; color: #333; margin-top: 0.6rem; }
        .register-btn:hover, .home-btn:hover { transform: translateY(-1px); }
        .login-link { text-align: center; margin-top: 0.9rem; padding-top: 0.9rem; border-top: 1px solid #e1e5e9; font-size: 0.95rem; }
        .login-link a { color: #667eea; text-decoration: none; font-weight: 500; }
        .login-link a:hover { text-decoration: underline; }
        .error-message { background: #fee; color: #c33; padding: 0.65rem; border-radius: 5px; margin-bottom: 0.9rem; border: 1px solid #fcc; }
        @media (max-width: 600px) { .form-row { flex-direction: column; gap: 0; } }
        .password-wrapper { position: relative; }
        .toggle-password { position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: transparent; border: none; color: #667eea; font-weight: 600; cursor: pointer; }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>Create Account</h1>
            <p>Join us today</p>
        </div>
        
        <c:if test="${not empty errorMessage}"><div class="error-message">${errorMessage}</div></c:if>
        
        <form action="${pageContext.request.contextPath}/auth/register" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" value="${name}" required>
                </div>
                <div class="form-group">
                    <label for="phoneNumber">Phone Number</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" value="${phoneNumber}" required>
                </div>
            </div>
            <div class="form-group full-width">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${email}" required>
            </div>
            <div class="form-group full-width">
                <label for="birthDate">Birth Date</label>
                <input type="date" id="birthDate" name="birthDate" value="${birthDate}">
            </div>
            <div class="form-row">
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
            </div>
            <div class="form-group full-width">
                <label for="confirmPassword">Confirm Password</label>
                <div class="password-wrapper">
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                    <button type="button" class="toggle-password" data-target="confirmPassword">Show</button>
                </div>
            </div>
            <button type="submit" class="register-btn">Create Account</button>
        </form>
        
        <div class="login-link">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/auth/showLogin">Sign in</a></p>
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
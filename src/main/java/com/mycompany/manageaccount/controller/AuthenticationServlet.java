package com.mycompany.manageaccount.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.mycompany.manageaccount.dao.UserDAO;
import com.mycompany.manageaccount.model.User;

@WebServlet("/auth/*")
public class AuthenticationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getPathInfo();

        try {
            switch (action) {
                case "/login":
                    login(request, response);
                    break;
                case "/register":
                    register(request, response);
                    break;
                case "/logout":
                    logout(request, response);
                    break;
                case "/showLogin":
                    showLoginForm(request, response);
                    break;
                case "/showRegister":
                    showRegisterForm(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/auth/showLogin");
                    break;
            }
        } catch (SQLException ex) {
            System.err.println("SQL Exception occurred: " + ex.getMessage());
            request.setAttribute("errorMessage", "Database error occurred: " + ex.getMessage());
            showErrorPage(request, response);
        } catch (Exception ex) {
            System.err.println("Unexpected Exception: " + ex.getMessage());
            request.setAttribute("errorMessage", "An unexpected error occurred: " + ex.getMessage());
            showErrorPage(request, response);
        }
    }

    private void showLoginForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
        dispatcher.forward(request, response);
    }

    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/register.jsp");
        dispatcher.forward(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
    throws SQLException, IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required");
            showLoginForm(request, response);
            return;
        }

        User user = userDAO.authenticateUser(username, password);
        
        if (user != null) {
            // Login successful
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userId", user.getId());
            
            // Redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            // Login failed
            request.setAttribute("errorMessage", "Invalid username or password");
            request.setAttribute("username", username);
            showLoginForm(request, response);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
    throws SQLException, IOException, ServletException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String birthDateStr = request.getParameter("birthDate");

        // Validation
        if (name == null || email == null || phoneNumber == null || username == null || 
            password == null || confirmPassword == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || username.trim().isEmpty() || 
            password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("username", username);
            request.setAttribute("birthDate", birthDateStr);
            showRegisterForm(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("username", username);
            request.setAttribute("birthDate", birthDateStr);
            showRegisterForm(request, response);
            return;
        }

        // Check if username already exists
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("errorMessage", "Username already exists");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("birthDate", birthDateStr);
            showRegisterForm(request, response);
            return;
        }

        // Check if email already exists
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Email already exists");
            request.setAttribute("name", name);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("username", username);
            request.setAttribute("birthDate", birthDateStr);
            showRegisterForm(request, response);
            return;
        }

        // Parse birth date
        Date birthDate = null;
        if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
            try {
                birthDate = dateFormat.parse(birthDateStr);
            } catch (ParseException e) {
                System.err.println("Error parsing birth date: " + e.getMessage());
            }
        }

        // Create new user with default role 'user'
        User newUser = new User(name, email, phoneNumber, username, password, birthDate, "user");
        userDAO.insertUser(newUser);

        // Registration successful
        request.setAttribute("successMessage", "Registration successful! Please login.");
        showLoginForm(request, response);
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
    throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Redirect to root after logout
        response.sendRedirect(request.getContextPath() + "/");
    }

    private void showErrorPage(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/Error.jsp");
        dispatcher.forward(request, response);
    }
} 
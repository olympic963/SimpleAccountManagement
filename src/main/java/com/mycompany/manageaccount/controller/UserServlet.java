package com.mycompany.manageaccount.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.mycompany.manageaccount.dao.UserDAO;
import com.mycompany.manageaccount.model.User;

@WebServlet("/")
public class UserServlet extends HttpServlet {
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
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/insert":
                    insertUser(request, response);
                    break;
                case "/delete":
                    deleteUser(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateUser(request, response);
                    break;
                case "/list":
                    listUser(request, response);
                    break;
                case "/search":
                    searchUsers(request, response);
                    break;
                case "/profile":
                    showProfile(request, response);
                    break;
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/change-password":
                    showChangePasswordForm(request, response);
                    break;
                case "/do-change-password":
                    changePassword(request, response);
                    break;
                default:
                    showWelcomeOrDashboard(request, response);
                    break;
            }
        } catch (SQLException ex) {
            System.err.println("SQL Exception occurred: " + ex.getMessage());
            request.setAttribute("exception", ex);
            showErrorPage(request, response);
        } catch (NumberFormatException ex) {
            System.err.println("Number Format Exception: " + ex.getMessage());
            request.setAttribute("exception", ex);
            showErrorPage(request, response);
        } catch (ServletException | IOException ex) {
            // Handle any other unexpected exceptions
            System.err.println("Unexpected Exception: " + ex.getMessage());
            request.setAttribute("exception", ex);
            showErrorPage(request, response);
        }
    }

    private void showWelcomeOrDashboard(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        showWelcomePage(request, response);
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
        dispatcher.forward(request, response);
    }

    private void showWelcomePage(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("welcome.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showErrorPage(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Set response status to indicate error
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        
        // Log additional information
        Exception ex = (Exception) request.getAttribute("exception");
        if (ex != null) {
            System.err.println("Forwarding to error page for exception: " + ex.getClass().getSimpleName());
        }
        
        // Forward to error page
        RequestDispatcher dispatcher = request.getRequestDispatcher("Error.jsp");
        dispatcher.forward(request, response);
    }

    private void listUser(HttpServletRequest request, HttpServletResponse response)
    throws SQLException, IOException, ServletException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        List < User > listUser = userDAO.selectAllUsers();
        request.setAttribute("listUser", listUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("user-list.jsp");
        dispatcher.forward(request, response);
    }

    private void searchUsers(HttpServletRequest request, HttpServletResponse response)
    throws SQLException, IOException, ServletException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        String searchTerm = request.getParameter("search");
        List<User> listUser;
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            listUser = userDAO.searchUsers(searchTerm);
            request.setAttribute("searchTerm", searchTerm);
        } else {
            listUser = userDAO.selectAllUsers();
        }
        
        request.setAttribute("listUser", listUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("user-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
    throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/showLogin");
            return;
        }
        
        // Get fresh user data from database
        User user = userDAO.selectUser(currentUser.getId());
        request.setAttribute("user", user);
        RequestDispatcher dispatcher = request.getRequestDispatcher("user-profile.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("user-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
    throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is admin or editing their own profile
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/showLogin");
            return;
        }
        
        if (!currentUser.isAdmin() && currentUser.getId() != id) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        User existingUser = userDAO.selectUser(id);
        System.out.println(existingUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("user-form.jsp");
        request.setAttribute("editingUser", existingUser);
        dispatcher.forward(request, response);
    }

    private void showChangePasswordForm(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/showLogin");
            return;
        }
        // Allow admin to change any password via query param id; user can only change own
        String idParam = request.getParameter("id");
        int targetId = (idParam != null && !idParam.isEmpty()) ? Integer.parseInt(idParam) : currentUser.getId();
        if (!currentUser.isAdmin() && targetId != currentUser.getId()) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        request.setAttribute("targetUserId", targetId);
        RequestDispatcher dispatcher = request.getRequestDispatcher("change-password.jsp");
        dispatcher.forward(request, response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
    throws IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/showLogin");
            return;
        }
        int targetId = Integer.parseInt(request.getParameter("id"));
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Load target user first
        User target = userDAO.selectUser(targetId);
        if (target == null) {
            request.setAttribute("exception", new IllegalArgumentException("User not found"));
            try { showErrorPage(request, response); } catch (ServletException e) { throw new IOException(e); }
            return;
        }
        
        // 1) For non-admins: verify old password first
        if (!currentUser.isAdmin()) {
            String stored = target.getPassword() == null ? "" : target.getPassword();
            if (oldPassword == null || !stored.equals(oldPassword)) {
                request.setAttribute("exception", new IllegalArgumentException("Old password is incorrect"));
                try { showErrorPage(request, response); } catch (ServletException e) { throw new IOException(e); }
                return;
            }
        }
        
        // 2) Then check new password confirmation
        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("exception", new IllegalArgumentException("Password confirmation does not match"));
            try { showErrorPage(request, response); } catch (ServletException e) { throw new IOException(e); }
            return;
        }
        
        try {
            userDAO.updatePassword(targetId, newPassword);
        } catch (SQLException ex) {
            request.setAttribute("exception", ex);
            try { showErrorPage(request, response); } catch (ServletException e) { throw new IOException(e); }
            return;
        }
        // If changed own password, reuse relogin flow
        if (currentUser.getId() == targetId) {
            session.invalidate();
            request.setAttribute("reloginSeconds", 5);
            request.setAttribute("reloginMessage", "Your password has been changed. Please log in again.");
            try {
                RequestDispatcher dispatcher = request.getRequestDispatcher("relogin.jsp");
                dispatcher.forward(request, response);
            } catch (ServletException e) { throw new IOException(e); }
        } else {
            response.sendRedirect("list");
        }
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response)
    throws SQLException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String birthDateStr = request.getParameter("birthDate");
        String role = request.getParameter("role");
        
        // Validate duplicates
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("exception", new IllegalArgumentException("Username already exists"));
            try { showErrorPage(request, response); } catch (ServletException e) { throw new IOException(e); }
            return;
        }
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("exception", new IllegalArgumentException("Email already exists"));
            try { showErrorPage(request, response); } catch (ServletException e) { throw new IOException(e); }
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
        
        try {
            // Create user with username and password
            User newUser = new User(name, email, phoneNumber, username, password, birthDate, role);
            userDAO.insertUser(newUser);
            response.sendRedirect("list");
        } catch (SQLException ex) {
            request.setAttribute("exception", ex);
            try { showErrorPage(request, response); } catch (ServletException e) { throw new IOException(e); }
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
    throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/showLogin");
            return;
        }
        
        if (!currentUser.isAdmin() && currentUser.getId() != id) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String username = request.getParameter("username");
        String passwordParam = request.getParameter("password");
        String birthDateStr = request.getParameter("birthDate");
        String roleParam = request.getParameter("role");
        
        Date birthDate = null;
        if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
            try {
                birthDate = dateFormat.parse(birthDateStr);
            } catch (ParseException e) {
                System.err.println("Error parsing birth date: " + e.getMessage());
            }
        }
        
        // Load current record to compare
        User beforeUpdate = userDAO.selectUser(id);
        if (beforeUpdate == null) {
            request.setAttribute("exception", new IllegalArgumentException("User not found"));
            try { showErrorPage(request, response); } catch (ServletException e) { throw new IOException(e); }
            return;
        }
        
        // Role to store
        String roleToStore = roleParam;
        if (!currentUser.isAdmin()) {
            roleToStore = beforeUpdate.getRole();
        } else if (roleToStore == null || roleToStore.isEmpty()) {
            roleToStore = beforeUpdate.getRole();
        }
        
        // Password to store: if not provided in request, keep existing and do not trigger passwordChanged
        String passwordToStore = (passwordParam != null && !passwordParam.isEmpty()) ? passwordParam : beforeUpdate.getPassword();
        boolean isSelfUpdate = currentUser.getId() == id;
        boolean passwordChanged = (passwordParam != null && !passwordParam.isEmpty()) && isSelfUpdate && !passwordParam.equals(beforeUpdate.getPassword());
        boolean roleChanged = isSelfUpdate && (roleToStore != null) && !roleToStore.equals(beforeUpdate.getRole());
        
        User user = new User(id, name, email, phoneNumber, username, passwordToStore, birthDate, roleToStore);
        userDAO.updateUser(user);
        
        if (passwordChanged || roleChanged) {
            session.invalidate();
            request.setAttribute("reloginSeconds", 5);
            String msg = passwordChanged ? "Your password has been changed. Please log in again." : "Your role has been changed. Please log in again.";
            request.setAttribute("reloginMessage", msg);
            try {
                RequestDispatcher dispatcher = request.getRequestDispatcher("relogin.jsp");
                dispatcher.forward(request, response);
            } catch (ServletException e) {
                throw new IOException(e);
            }
            return;
        }
        
        if (isSelfUpdate) {
            session.setAttribute("user", user);
            response.sendRedirect("profile");
        } else {
            response.sendRedirect("list");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
    throws SQLException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteUser(id);
        response.sendRedirect("list");
    }
}

package com.mycompany.manageaccount.dao;

import com.mycompany.manageaccount.model.User;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/demo?useSSL=false&allowPublicKeyRetrieval=true";
    private String jdbcUsername = "root";
    private String jdbcPassword = "anacondaxs5";

    private static final String INSERT_USERS_SQL = "INSERT INTO users" + "  (name, email, phone_number, username, password, birth_date, role) VALUES " +
        " (?, ?, ?, ?, ?, ?, ?);";

    private static final String SELECT_USER_BY_ID = "select id,name,email,phone_number,username,password,birth_date,role from users where id =?";
    private static final String SELECT_ALL_USERS = "select * from users";
    private static final String DELETE_USERS_SQL = "delete from users where id = ?;";
    private static final String UPDATE_USERS_SQL = "update users set name = ?,email= ?, phone_number =?, username = ?, password = ?, birth_date = ?, role = ? where id = ?;";
    private static final String UPDATE_PASSWORD_SQL = "update users set password = ? where id = ?";
    
    // Authentication queries
    private static final String SELECT_USER_BY_USERNAME = "select id,name,email,phone_number,username,password,birth_date,role from users where username = ?";
    private static final String SELECT_USER_BY_EMAIL = "select id,name,email,phone_number,username,password,birth_date,role from users where email = ?";
    private static final String CHECK_USERNAME_EXISTS = "select count(*) from users where username = ?";
    private static final String CHECK_EMAIL_EXISTS = "select count(*) from users where email = ?";
    
    // Search queries
    private static final String SEARCH_USERS = "SELECT * FROM users WHERE name LIKE ? OR email LIKE ? OR username LIKE ? OR phone_number LIKE ?";

    public UserDAO() {}

    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    public void insertUser(User user) throws SQLException {
        System.out.println(INSERT_USERS_SQL);
        try (Connection connection = getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USERS_SQL)) {
            preparedStatement.setString(1, user.getName());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getPhoneNumber());
            preparedStatement.setString(4, user.getUsername());
            preparedStatement.setString(5, user.getPassword());
            preparedStatement.setDate(6, user.getBirthDate() != null ? new Date(user.getBirthDate().getTime()) : null);
            preparedStatement.setString(7, user.getRole() != null ? user.getRole() : "user");
            System.out.println(preparedStatement);
            preparedStatement.executeUpdate();
        }
    }

    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        try (Connection connection = getConnection(); PreparedStatement ps = connection.prepareStatement(UPDATE_PASSWORD_SQL)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public User selectUser(int id) {
        User user = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_ID);) {
            preparedStatement.setInt(1, id);
            System.out.println(preparedStatement);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                String name = rs.getString("name");
                String email = rs.getString("email");
                String phoneNumber = rs.getString("phone_number");
                String username = rs.getString("username");
                String password = rs.getString("password");
                Date birthDate = rs.getDate("birth_date");
                String role = rs.getString("role");
                user = new User(id, name, email, phoneNumber, username, password, birthDate, role);
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return user;
    }

    public List < User > selectAllUsers() {
        List < User > users = new ArrayList < > ();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_USERS);) {
            System.out.println(preparedStatement);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String phoneNumber = rs.getString("phone_number");
                String username = rs.getString("username");
                String password = rs.getString("password");
                Date birthDate = rs.getDate("birth_date");
                String role = rs.getString("role");
                users.add(new User(id, name, email, phoneNumber, username, password, birthDate, role));
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return users;
    }

    public boolean deleteUser(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(DELETE_USERS_SQL);) {
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    public boolean updateUser(User user) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(UPDATE_USERS_SQL);) {
            statement.setString(1, user.getName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPhoneNumber());
            statement.setString(4, user.getUsername());
            statement.setString(5, user.getPassword());
            statement.setDate(6, user.getBirthDate() != null ? new Date(user.getBirthDate().getTime()) : null);
            statement.setString(7, user.getRole() != null ? user.getRole() : "user");
            statement.setInt(8, user.getId());

            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    // Authentication methods
    public User authenticateUser(String username, String password) {
        User user = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_USERNAME)) {
            preparedStatement.setString(1, username);
            System.out.println(preparedStatement);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                String storedPassword = rs.getString("password");
                if (password.equals(storedPassword)) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String email = rs.getString("email");
                    String phoneNumber = rs.getString("phone_number");
                    Date birthDate = rs.getDate("birth_date");
                    String role = rs.getString("role");
                    user = new User(id, name, email, phoneNumber, username, storedPassword, birthDate, role);
                }
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return user;
    }

    public User getUserByUsername(String username) {
        User user = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_USERNAME)) {
            preparedStatement.setString(1, username);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String phoneNumber = rs.getString("phone_number");
                String password = rs.getString("password");
                Date birthDate = rs.getDate("birth_date");
                String role = rs.getString("role");
                user = new User(id, name, email, phoneNumber, username, password, birthDate, role);
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return user;
    }

    public boolean isUsernameExists(String username) {
        boolean exists = false;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(CHECK_USERNAME_EXISTS)) {
            preparedStatement.setString(1, username);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return exists;
    }

    public boolean isEmailExists(String email) {
        boolean exists = false;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(CHECK_EMAIL_EXISTS)) {
            preparedStatement.setString(1, email);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return exists;
    }

    public List<User> searchUsers(String searchTerm) {
        List<User> users = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SEARCH_USERS)) {
            
            String searchPattern = "%" + searchTerm + "%";
            preparedStatement.setString(1, searchPattern);
            preparedStatement.setString(2, searchPattern);
            preparedStatement.setString(3, searchPattern);
            preparedStatement.setString(4, searchPattern);
            
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String phoneNumber = rs.getString("phone_number");
                String username = rs.getString("username");
                String password = rs.getString("password");
                Date birthDate = rs.getDate("birth_date");
                String role = rs.getString("role");
                users.add(new User(id, name, email, phoneNumber, username, password, birthDate, role));
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return users;
    }

    private void printSQLException(SQLException ex) {
        for (Throwable e: ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }
}

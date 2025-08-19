/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.manageaccount.model;

import java.util.Date;

/**
 *
 * @author Administrator
 */
public class User {
    protected int id;
    protected String name;
    protected String email;
    protected String phoneNumber;
    protected String username;
    protected String password;
    protected Date birthDate;
    protected String role;

    public User() {}

    public User(String name, String email, String phoneNumber) {
        super();
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
    }

    public User(int id, String name, String email, String phoneNumber) {
        super();
        this.id = id;
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
    }

    public User(String name, String email, String phoneNumber, String username, String password) {
        super();
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.username = username;
        this.password = password;
        this.role = "user"; // Default role
    }

    public User(int id, String name, String email, String phoneNumber, String username, String password) {
        super();
        this.id = id;
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.username = username;
        this.password = password;
        this.role = "user"; // Default role
    }

    public User(String name, String email, String phoneNumber, String username, String password, String role) {
        super();
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public User(int id, String name, String email, String phoneNumber, String username, String password, String role) {
        super();
        this.id = id;
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public User(String name, String email, String phoneNumber, String username, String password, Date birthDate, String role) {
        super();
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.username = username;
        this.password = password;
        this.birthDate = birthDate;
        this.role = role;
    }

    public User(int id, String name, String email, String phoneNumber, String username, String password, Date birthDate, String role) {
        super();
        this.id = id;
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.username = username;
        this.password = password;
        this.birthDate = birthDate;
        this.role = role;
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getPhoneNumber() {
        return phoneNumber;
    }
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public Date getBirthDate() {
        return birthDate;
    }
    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }
    public String getRole() {
        return role;
    }
    public void setRole(String role) {
        this.role = role;
    }
    
    // Helper method to check if user is admin
    public boolean isAdmin() {
        return "admin".equals(this.role);
    }
}

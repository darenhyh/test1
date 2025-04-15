/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String DRIVER = "com.mysql.jdbc.Driver"; // Change based on your DB driver
    private static final String URL = "jdbc:mysql://localhost:3306/glowydays"; // Change database name as needed
    private static final String USER = "root"; // Change username as needed
    private static final String PASSWORD = ""; // Change password as needed
    
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName(DRIVER);
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

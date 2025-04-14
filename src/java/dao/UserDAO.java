package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserDAO {

    private static final String DB_URL = "jdbc:derby://localhost:1527/Client";
    private static final String DB_USER = "nbuser";
    private static final String DB_PASSWORD = "nbuser";

    // Existing method
    public boolean registerUser(User user) {
        boolean isRegistered = false;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "INSERT INTO \"USER\" (\"name\",\"username\", \"birth\", \"email\", \"mobileNo\", \"password\") VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, user.getName());
            pst.setString(2, user.getUsername());
            pst.setString(3, user.getBirth().toString()); // Converting LocalDate to String
            pst.setString(4, user.getEmail());
            pst.setString(5, user.getMobileNo());
            pst.setString(6, user.getPassword());

            int rowCount = pst.executeUpdate();
            if (rowCount > 0) {
                isRegistered = true;
            }

            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return isRegistered;
    }
    
    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            String sql = "SELECT * FROM \"USER\"";
            Statement statement = con.createStatement();
            ResultSet rs = statement.executeQuery(sql);
            
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("id"));
                user.setName(rs.getString("name"));
                user.setUsername(rs.getString("username"));
                user.setBirth(LocalDate.parse(rs.getString("birth")));
                user.setEmail(rs.getString("email"));
                user.setMobileNo(rs.getString("mobileNo"));
                user.setPassword(rs.getString("password"));
                
                users.add(user);
            }
            
            rs.close();
            statement.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return users;
    }
    
    // Get user by ID
    public User getUserById(Long id) {
        User user = null;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            String sql = "SELECT * FROM \"USER\" WHERE \"id\" = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setLong(1, id);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setId(rs.getLong("id"));
                user.setName(rs.getString("name"));
                user.setUsername(rs.getString("username"));
                user.setBirth(LocalDate.parse(rs.getString("birth")));
                user.setEmail(rs.getString("email"));
                user.setMobileNo(rs.getString("mobileNo"));
                user.setPassword(rs.getString("password"));
            }
            
            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return user;
    }
    
    // Update user
    public boolean updateUser(User user) {
        boolean isUpdated = false;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            String sql = "UPDATE \"USER\" SET \"name\" = ?, \"username\" = ?, \"birth\" = ?, \"email\" = ?, \"mobileNo\" = ?, \"password\" = ? WHERE \"id\" = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, user.getName());
            pst.setString(2, user.getUsername());
            pst.setString(3, user.getBirth().toString());
            pst.setString(4, user.getEmail());
            pst.setString(5, user.getMobileNo());
            pst.setString(6, user.getPassword());
            pst.setLong(7, user.getId());
            
            int rowCount = pst.executeUpdate();
            if (rowCount > 0) {
                isUpdated = true;
            }
            
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return isUpdated;
    }
    
    // Delete user
    public boolean deleteUser(Long id) {
        boolean isDeleted = false;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            String sql = "DELETE FROM \"USER\" WHERE \"id\" = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setLong(1, id);
            
            int rowCount = pst.executeUpdate();
            if (rowCount > 0) {
                isDeleted = true;
            }
            
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return isDeleted;
    }
    
    // Check if username exists (excluding given ID for updates)
    public boolean isUsernameExists(String username, Long excludeId) {
        boolean exists = false;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            String sql = "SELECT COUNT(*) FROM \"USER\" WHERE \"username\" = ?";
            if (excludeId != null) {
                sql += " AND \"id\" != ?";
            }
            
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, username);
            
            if (excludeId != null) {
                pst.setLong(2, excludeId);
            }
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                exists = true;
            }
            
            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return exists;
    }
    
    // Check if email exists (excluding given ID for updates)
    public boolean isEmailExists(String email, Long excludeId) {
        boolean exists = false;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            String sql = "SELECT COUNT(*) FROM \"USER\" WHERE \"email\" = ?";
            if (excludeId != null) {
                sql += " AND \"id\" != ?";
            }
            
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, email);
            
            if (excludeId != null) {
                pst.setLong(2, excludeId);
            }
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                exists = true;
            }
            
            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return exists;
    }
    
    // Check if mobile number exists (excluding given ID for updates)
    public boolean isMobileNoExists(String mobileNo, Long excludeId) {
        boolean exists = false;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            String sql = "SELECT COUNT(*) FROM \"USER\" WHERE \"mobileNo\" = ?";
            if (excludeId != null) {
                sql += " AND \"id\" != ?";
            }
            
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, mobileNo);
            
            if (excludeId != null) {
                pst.setLong(2, excludeId);
            }
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                exists = true;
            }
            
            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return exists;
    }
}
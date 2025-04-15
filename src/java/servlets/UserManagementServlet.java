package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.DBConnection;

@WebServlet(name = "UserManagementServlet", urlPatterns = {"/UserManagement"})
public class UserManagementServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            // Default action: list all users
            listUsers(request, response);
        } else {
            switch (action) {
                case "delete":
                    deleteUser(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "update":
                    updateUser(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<User> users = new ArrayList<>();
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM customers";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setMobileNo(rs.getString("mobileNo"));
                user.setBirth(rs.getString("birth"));
                
                users.add(user);
            }
            
            rs.close();
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/JSP/RegisteredUsers.jsp").forward(request, response);
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM customers WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                request.getSession().setAttribute("message", "User deleted successfully.");
            } else {
                request.getSession().setAttribute("message", "Failed to delete user.");
            }
            
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/UserManagement");
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        User user = null;
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM customers WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setMobileNo(rs.getString("mobileNo"));
                user.setBirth(rs.getString("birth"));
                user.setPassword(rs.getString("password"));
            }
            
            rs.close();
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        }
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("/JSP/EditUser.jsp").forward(request, response);
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String birth = request.getParameter("birth");
        String email = request.getParameter("email");
        String mobileNo = request.getParameter("mobileNo");
        String password = request.getParameter("password");
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE customers SET name = ?, username = ?, birth = ?, email = ?, mobileNo = ?, password = ? WHERE id = ?";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, username);
            pstmt.setString(3, birth);
            pstmt.setString(4, email);
            pstmt.setString(5, mobileNo);
            pstmt.setString(6, password);
            pstmt.setInt(7, id);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                request.getSession().setAttribute("message", "User updated successfully.");
            } else {
                request.getSession().setAttribute("message", "Failed to update user.");
            }
            
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/UserManagement");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "User Management Servlet";
    }
}
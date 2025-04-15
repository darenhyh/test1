package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.DBConnection;

@WebServlet(name = "UserRegistrationServlet", urlPatterns = {"/UserRegistration"})
public class UserRegistrationServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from the form
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String birth = request.getParameter("birth");
        String email = request.getParameter("email");
        String mobileNo = request.getParameter("mobileNo");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("Cpassword");
        
        // Basic validation
        if (name == null || username == null || birth == null || email == null 
                || mobileNo == null || password == null || confirmPassword == null) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/JSP/Register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/JSP/Register.jsp").forward(request, response);
            return;
        }
        
        try {
            // Get database connection
            Connection conn = DBConnection.getConnection();
            
            // SQL query to insert user
            String sql = "INSERT INTO customers (name, username, birth, email, mobileNo, password) VALUES (?, ?, ?, ?, ?, ?)";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, username);
            pstmt.setString(3, birth);
            pstmt.setString(4, email);
            pstmt.setString(5, mobileNo);
            pstmt.setString(6, password);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Registration successful - redirect to login page
                request.getSession().setAttribute("message", "Registration successful. Please login.");
                response.sendRedirect(request.getContextPath() + "/JSP/Login.jsp");
            } else {
                // Registration failed
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/JSP/Register.jsp").forward(request, response);
            }
            
            // Close resources
            pstmt.close();
            conn.close();
            
        } catch (SQLException e) {
            // Database error
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/JSP/Register.jsp").forward(request, response);
        } catch (Exception e) {
            // Other errors
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/JSP/Register.jsp").forward(request, response);
        }
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
        return "User Registration Servlet";
    }
}
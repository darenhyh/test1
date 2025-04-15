package servlet;

import java.io.IOException;
import java.time.LocalDate;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/UserRegistration")
public class UserRegistration extends HttpServlet {
    
    private static final EntityManagerFactory emf = 
            Persistence.createEntityManagerFactory("GlowyDaysPU"); // Your persistence unit name

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from the request
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String birthStr = request.getParameter("birth");
        String email = request.getParameter("email");
        String mobileNo = request.getParameter("mobileNo");
        String password = request.getParameter("password");
        
        // Convert birthStr to LocalDate
        LocalDate birthDate = LocalDate.parse(birthStr);
        
        // Create a new User entity
        User user = new User(name, username, birthDate, email, mobileNo, password);
        
        EntityManager em = null;
        EntityTransaction tx = null;
        
        try {
            // Get the EntityManager
            em = emf.createEntityManager();
            tx = em.getTransaction();
            tx.begin();
            
            // Persist the User entity
            em.persist(user);
            tx.commit();
            
            // Store success message in session
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Registration successful! Please login.");
            
            // Redirect to Login page
            response.sendRedirect("JSP/Login.jsp");
            
        } catch (Exception e) {
            // Rollback transaction in case of error
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            
            // Handle specific database errors
            String errorMessage;
            if (e.getMessage().contains("unique constraint") || e.getMessage().contains("duplicate")) {
                errorMessage = "Username or email already exists. Please try different values.";
            } else {
                errorMessage = "Registration failed: " + e.getMessage();
            }
            
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("JSP/Register.jsp").forward(request, response);
            
        } finally {
            // Close EntityManager
            if (em != null) {
                em.close();
            }
        }
    }
    
    @Override
    public void destroy() {
        // Close the EntityManagerFactory when the servlet is destroyed
        if (emf != null) {
            emf.close();
        }
    }
}
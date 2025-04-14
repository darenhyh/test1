import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CheckEmail")
public class CheckEmail extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        // Email validation using regex (must contain "@" and ".")
        if (email == null || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            response.setContentType("text/plain");
            response.getWriter().print("Invalid Email Format");
            return;
        }

        try {
            // Load Derby Driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            // Connect to the Derby Database
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Client", "nbuser", "nbuser");

            // Check if email already exists
            String query = "SELECT * FROM \"USER\" WHERE \"email\" = ?";
            pst = conn.prepareStatement(query);
            pst.setString(1, email);
            rs = pst.executeQuery();

            response.setContentType("text/plain");
            PrintWriter out = response.getWriter();

            if (rs.next()) {
                out.print("Already Exists"); // Email is already taken
            } else {
                out.print("Available"); // Email is available
            }
        } catch (Exception e) {
            response.getWriter().print("Database Error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet("/CheckName")
public class CheckName extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Load Derby Driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            // Connect to the Database
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Client", "nbuser", "nbuser");

            // Check if username already exists
            String query = "SELECT * FROM \"USER\" WHERE \"username\" = ?";
            pst = conn.prepareStatement(query);
            pst.setString(1, username);
            rs = pst.executeQuery();

            response.setContentType("text/plain");
            PrintWriter out = response.getWriter();

            if (rs.next()) {
                out.print("Already Exists"); // Username is taken
            } else {
                out.print(""); // Username is available
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

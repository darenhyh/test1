import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ValidateName")
public class ValidateName extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");

        String fullName = request.getParameter("name");

        // Regex: Allows only letters (A-Z, a-z), spaces, and '/'
        if (fullName != null && fullName.matches("^[A-Za-z\\s/]+$")) {
            response.getWriter().write("Valid Name");
        } else {
            response.getWriter().write("Invalid Name");
        }
    }
}

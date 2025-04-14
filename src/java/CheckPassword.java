import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CheckPassword")
public class CheckPassword extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String password = request.getParameter("password");
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        // Password validation rules
        boolean hasLowerCase = password.matches(".*[a-z].*");
        boolean hasUpperCase = password.matches(".*[A-Z].*");
        boolean hasNumber = password.matches(".*[0-9].*");
        boolean hasMinLength = password.length() >= 8;

        if (!hasLowerCase) {
            out.print("Password must contain at least one lowercase letter.");
        } else if (!hasUpperCase) {
            out.print("Password must contain at least one uppercase letter.");
        } else if (!hasNumber) {
            out.print("Password must contain at least one number.");
        } else if (!hasMinLength) {
            out.print("Password must be at least 8 characters long.");
        } else {
            out.print("Valid");
        }
    }
}

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.UserDAO;
import model.User;

@WebServlet("/UserRegistration")
public class UserRegistration extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String name = request.getParameter("name");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String mobileNo = request.getParameter("mobileNo");
            String password = request.getParameter("password");
            String Cpassword = request.getParameter("Cpassword");
            String birth = request.getParameter("birth");

            if (password.equals(Cpassword)) {
                // Create the User object
                User user = new User(name, username, java.time.LocalDate.parse(birth), email, mobileNo, password);

                // Use the DAO to register the user
                UserDAO userDAO = new UserDAO();
                boolean isRegistered = userDAO.registerUser(user);

                if (isRegistered) {
                    response.sendRedirect("/GlowyDays/JSP/UserHome.jsp");
                } else {
                    out.println("Registration Failed!");
                }
            } else {
                out.println("Passwords do not match!");
            }
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
        return "Short description";
    }
}

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.UserDAO;
import model.User;
import java.util.List;

@WebServlet("/CustomerManagement")
public class CustomerManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list"; // Default action
        }
        
        switch (action) {
            case "list":
                listCustomers(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCustomer(request, response);
                break;
            case "new":
                showNewForm(request, response);
                break;
            default:
                listCustomers(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list"; // Default action
        }
        
        switch (action) {
            case "create":
                createCustomer(request, response);
                break;
            case "update":
                updateCustomer(request, response);
                break;
            default:
                listCustomers(request, response);
                break;
        }
    }
    
    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        List<User> customers = userDAO.getAllUsers();
        request.setAttribute("customers", customers);
        request.getRequestDispatcher("/JSP/Admin/CustomerManagement.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long userId = Long.parseLong(request.getParameter("id"));
            UserDAO userDAO = new UserDAO();
            User customer = userDAO.getUserById(userId);
            
            if (customer != null) {
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("/JSP/Admin/CustomerEdit.jsp").forward(request, response);
            } else {
                request.setAttribute("message", "Customer not found");
                listCustomers(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            listCustomers(request, response);
        }
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/JSP/Admin/CustomerAdd.jsp").forward(request, response);
    }
    
    private void createCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String username = request.getParameter("username");
            String birthStr = request.getParameter("birth");
            String email = request.getParameter("email");
            String mobileNo = request.getParameter("mobileNo");
            String password = request.getParameter("password");
            
            java.time.LocalDate birth = java.time.LocalDate.parse(birthStr);
            
            User newUser = new User(name, username, birth, email, mobileNo, password);
            
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.registerUser(newUser);
            
            if (success) {
                request.setAttribute("message", "Customer created successfully");
            } else {
                request.setAttribute("message", "Failed to create customer");
            }
            
            listCustomers(request, response);
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("/JSP/Admin/CustomerAdd.jsp").forward(request, response);
        }
    }
    
    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            String name = request.getParameter("name");
            String username = request.getParameter("username");
            String birthStr = request.getParameter("birth");
            String email = request.getParameter("email");
            String mobileNo = request.getParameter("mobileNo");
            String password = request.getParameter("password");
            
            java.time.LocalDate birth = java.time.LocalDate.parse(birthStr);
            
            User user = new User(name, username, birth, email, mobileNo, password);
            user.setId(id);
            
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updateUser(user);
            
            if (success) {
                request.setAttribute("message", "Customer updated successfully");
            } else {
                request.setAttribute("message", "Failed to update customer");
            }
            
            listCustomers(request, response);
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            showEditForm(request, response);
        }
    }
    
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long userId = Long.parseLong(request.getParameter("id"));
            
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.deleteUser(userId);
            
            if (success) {
                request.setAttribute("message", "Customer deleted successfully");
            } else {
                request.setAttribute("message", "Failed to delete customer");
            }
            
            listCustomers(request, response);
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            listCustomers(request, response);
        }
    }
}
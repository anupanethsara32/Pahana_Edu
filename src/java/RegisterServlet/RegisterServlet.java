// ------------------------------
// RegisterServlet.java
// ------------------------------
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pahana_edu_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String nic = request.getParameter("nic");
        String telephone = request.getParameter("telephone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("message", "Passwords do not match!");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        String accountNo = generateAccountNumber();
        String username = nic;  // NIC used as username

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                // Check if NIC already exists
                String checkSql = "SELECT nic FROM users WHERE nic = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, nic);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    request.setAttribute("message", "This NIC is already registered!");
                    request.getRequestDispatcher("Register.jsp").forward(request, response);
                    return;
                }

                // Insert new user
                String sql = "INSERT INTO users (account_no, first_name, last_name, nic, telephone, address, password, username, created_at) "
                           + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setString(1, accountNo);
                pst.setString(2, firstName);
                pst.setString(3, lastName);
                pst.setString(4, nic);
                pst.setString(5, telephone);
                pst.setString(6, address);
                pst.setString(7, password);
                pst.setString(8, username);
                pst.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));

                int rows = pst.executeUpdate();

                if (rows > 0) {
                    // Redirect to a styled success page
                   response.sendRedirect("Register.jsp?message=success");

                } else {
                    request.setAttribute("message", "Registration failed. Please try again.");
                    request.getRequestDispatcher("Register.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Server error: " + e.getMessage());
            request.getRequestDispatcher("Register.jsp").forward(request, response);
        }
    }

    // Generates a random account number
    private String generateAccountNumber() {
        int random = (int) (Math.random() * 100000);
        return "PAH-" + String.format("%05d", random);
    }
}

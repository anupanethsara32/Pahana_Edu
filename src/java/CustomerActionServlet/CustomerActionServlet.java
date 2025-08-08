// ------------------------------
// CustomerActionServlet.java
// ------------------------------
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CustomerActionServlet")
public class CustomerActionServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pahana_edu_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String username = request.getParameter("username");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            if ("update".equals(action)) {
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String telephone = request.getParameter("telephone");
                String address = request.getParameter("address");

                String sql = "UPDATE users SET first_name=?, last_name=?, telephone=?, address=? WHERE username=?";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setString(1, firstName);
                pst.setString(2, lastName);
                pst.setString(3, telephone);
                pst.setString(4, address);
                pst.setString(5, username);
                pst.executeUpdate();
                pst.close();

            } else if ("delete".equals(action)) {
                String sql = "DELETE FROM users WHERE username=?";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setString(1, username);
                pst.executeUpdate();
                pst.close();
            }

            conn.close();
            response.sendRedirect("ManageCustomers.jsp");

        } catch (Exception e) {
            response.getWriter().println("Error processing request: " + e.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);  // Optional: Support both GET and POST
    }
}

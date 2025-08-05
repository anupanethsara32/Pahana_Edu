import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/pahana_edu_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form fields
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to DB
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Insert into contact_messages table
            String sql = "INSERT INTO contact_messages (name, email, phone, subject, message) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, name);
            pst.setString(2, email);
            pst.setString(3, phone);
            pst.setString(4, subject);
            pst.setString(5, message);
            pst.executeUpdate();
            pst.close();
            conn.close();

            // Redirect back with success message
            response.sendRedirect("ContactUs.jsp?success=true");

        } catch (Exception e) {
            throw new ServletException("Error submitting contact form: " + e.getMessage(), e);
        }
    }
}

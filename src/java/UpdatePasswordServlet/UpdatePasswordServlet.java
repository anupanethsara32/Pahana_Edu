// UpdatePasswordServlet.java
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {
    private static final String DB_URL  = "jdbc:mysql://localhost:3306/pahana_edu_db?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String nic = req.getParameter("nic");
        String newPassword = req.getParameter("newPassword");

        if (nic == null || nic.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
            resp.sendRedirect("UserDashboard.jsp?pwd=fail");
            return;
        }
        if (newPassword.length() < 6) {
            resp.sendRedirect("UserDashboard.jsp?pwd=short");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 PreparedStatement ps = con.prepareStatement("UPDATE users SET password=? WHERE nic=?")) {

                // NOTE: For production, hash the password (BCrypt/Argon2).
                ps.setString(1, newPassword);
                ps.setString(2, nic);

                int updated = ps.executeUpdate();
                if (updated > 0) {
                    resp.sendRedirect("UserDashboard.jsp?pwd=ok");
                } else {
                    resp.sendRedirect("UserDashboard.jsp?pwd=notfound");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("UserDashboard.jsp?pwd=err");
        }
    }
}

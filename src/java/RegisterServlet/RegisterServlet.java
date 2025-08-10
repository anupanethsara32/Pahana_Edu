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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean adminMode = "1".equals(request.getParameter("adminMode"));

        String firstName = t(request.getParameter("firstName"));
        String lastName  = t(request.getParameter("lastName"));
        String nic       = t(request.getParameter("nic"));
        String telephone = t(request.getParameter("telephone"));
        String address   = t(request.getParameter("address"));
        String password  = request.getParameter("password");
        String confirm   = request.getParameter("confirmPassword");

        if (firstName.isEmpty() || lastName.isEmpty() || nic.isEmpty()
                || telephone.isEmpty() || address.isEmpty() || password==null || confirm==null) {
            fail("All fields are required.", adminMode, request, response);
            return;
        }
        if (!password.equals(confirm)) {
            fail("Passwords do not match!", adminMode, request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                conn.setAutoCommit(false);

                // NIC duplicate check
                try (PreparedStatement chk = conn.prepareStatement("SELECT 1 FROM users WHERE nic=?")) {
                    chk.setString(1, nic);
                    if (chk.executeQuery().next()) {
                        conn.rollback();
                        fail("This NIC is already registered!", adminMode, request, response);
                        return;
                    }
                }

                // Generate next account no (server-side, ignore any client value)
                String accountNo = nextAccountNo(conn);

                String sql = "INSERT INTO users (account_no, first_name, last_name, nic, telephone, address, password, username, created_at) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement pst = conn.prepareStatement(sql)) {
                    pst.setString(1, accountNo);
                    pst.setString(2, firstName);
                    pst.setString(3, lastName);
                    pst.setString(4, nic);
                    pst.setString(5, telephone);
                    pst.setString(6, address);
                    pst.setString(7, password); // TODO: hash with BCrypt in production
                    pst.setString(8, nic);      // username = NIC
                    pst.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));

                    int rows = pst.executeUpdate();
                    if (rows > 0) {
                        conn.commit();
                        if (adminMode) {
                            response.sendRedirect("RegisterAdmin.jsp?message=success");
                        } else {
                            response.sendRedirect("RegisterPublic.jsp?message=success");
                        }
                        return;
                    } else {
                        conn.rollback();
                        fail("Registration failed. Please try again.", adminMode, request, response);
                        return;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            fail("Server error: " + e.getMessage(), adminMode, request, response);
        }
    }

    private static String t(String s){ return s==null? "": s.trim(); }

    private String nextAccountNo(Connection conn) throws SQLException {
        String q = "SELECT COALESCE(MAX(CAST(SUBSTRING(account_no,5) AS UNSIGNED)),10000) AS max_acc FROM users";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            int max = 10000; if (rs.next()) max = rs.getInt("max_acc");
            return "PAH-" + (max + 1);
        }
    }

    private void fail(String msg, boolean adminMode, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("message", msg);
        if (adminMode) request.getRequestDispatcher("RegisterAdmin.jsp").forward(request, response);
        else request.getRequestDispatcher("RegisterPublic.jsp").forward(request, response);
    }
}

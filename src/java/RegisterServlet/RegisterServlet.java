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

    // DB config (keep simple)
    private static final String DB_URL  = "jdbc:mysql://localhost:3306/pahana_edu_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If this comes from admin form, we redirect back to admin page on success.
        boolean adminMode = "1".equals(request.getParameter("adminMode"));

        // 1) Read form params
        String firstName = nv(request.getParameter("firstName"));
        String lastName  = nv(request.getParameter("lastName"));
        String nic       = nv(request.getParameter("nic"));
        String telephone = nv(request.getParameter("telephone"));
        String address   = nv(request.getParameter("address"));
        String password  = request.getParameter("password");          // NOTE: hash in prod
        String confirm   = request.getParameter("confirmPassword");

        // 2) Quick validation
        if (firstName.isEmpty() || lastName.isEmpty() || nic.isEmpty()
                || telephone.isEmpty() || address.isEmpty()
                || password == null || confirm == null) {
            fail("All fields are required.", adminMode, request, response);
            return;
        }
        if (!password.equals(confirm)) {
            fail("Passwords do not match!", adminMode, request, response);
            return;
        }

        // 3) DB work (simple transaction)
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                boolean oldAuto = conn.getAutoCommit();
                conn.setAutoCommit(false);

                // 3a) NIC duplicate check
                try (PreparedStatement chk = conn.prepareStatement(
                        "SELECT 1 FROM users WHERE nic=?")) {
                    chk.setString(1, nic);
                    try (ResultSet rs = chk.executeQuery()) {
                        if (rs.next()) {
                            conn.rollback();
                            fail("This NIC is already registered!", adminMode, request, response);
                            return;
                        }
                    }
                }

                
                String accountNo = nextAccountNo(conn);
                String username  = nic; // use NIC as username

                
                try (PreparedStatement pst = conn.prepareStatement(
                        "INSERT INTO users (account_no, first_name, last_name, nic, telephone, address, password, username, created_at) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)")) {

                    pst.setString(1, accountNo);
                    pst.setString(2, firstName);
                    pst.setString(3, lastName);
                    pst.setString(4, nic);
                    pst.setString(5, telephone);
                    pst.setString(6, address);
                    pst.setString(7, password); // TODO: hash in production
                    pst.setString(8, username);
                    pst.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));

                    int rows = pst.executeUpdate();
                    if (rows > 0) {
                        conn.commit();
                        // Success → redirect (prevents duplicate on refresh)
                        response.sendRedirect(adminMode
                                ? "RegisterAdmin.jsp?message=success"
                                : "RegisterPublic.jsp?message=success");
                    } else {
                        conn.rollback();
                        fail("Registration failed. Please try again.", adminMode, request, response);
                    }
                } finally {
                    conn.setAutoCommit(oldAuto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            fail("Server error: " + e.getMessage(), adminMode, request, response);
        }
    }

    // Generate PAH-xxxxx using MAX + 1 (kept simple)
    private String nextAccountNo(Connection conn) throws SQLException {
        String sql = "SELECT COALESCE(MAX(CAST(SUBSTRING(account_no,5) AS UNSIGNED)),10000) AS max_acc FROM users";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            int max = 10000;
            if (rs.next()) max = rs.getInt("max_acc");
            return "PAH-" + (max + 1);
        }
    }

    // Small helper: fail & forward back to correct JSP
    private void fail(String msg, boolean adminMode,
                      HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("message", msg);
        request.getRequestDispatcher(adminMode ? "RegisterAdmin.jsp" : "RegisterPublic.jsp")
               .forward(request, response);
    }

    private static String nv(String s){ return s == null ? "" : s.trim(); }
}

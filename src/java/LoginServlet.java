// ------------------------------
// LoginServlet.java
// ------------------------------
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pahana_edu_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("Admin".equals(username) && "518173".equals(password)) {
            response.sendRedirect("AdminDashboard.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, username);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("name", rs.getString("first_name"));
                session.setAttribute("accountNo", rs.getString("account_no"));
                session.setAttribute("address", rs.getString("address"));
                session.setAttribute("telephone", rs.getString("telephone"));

                // Instead of redirecting directly to dashboard, set a flag
                session.setAttribute("loginSuccess", "true");
                response.sendRedirect("Index.jsp");
            } else {
                request.setAttribute("errorMessage", "Invalid NIC or password!");
                RequestDispatcher rd = request.getRequestDispatcher("Index.jsp");
                rd.forward(request, response);
            }

            rs.close();
            pst.close();
            conn.close();

        } catch (Exception e) {
            throw new ServletException("Login failed", e);
        }
    }
}

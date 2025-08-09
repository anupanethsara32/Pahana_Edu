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

    // Singleton DBConnection (inner static class)
    static class DBConnection {
        private static DBConnection instance;
        private static final String DB_URL = "jdbc:mysql://localhost:3306/pahana_edu_db";
        private static final String DB_USER = "root";
        private static final String DB_PASS = "";

        private DBConnection() {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new RuntimeException("JDBC Driver not found", e);
            }
        }

        public static synchronized DBConnection getInstance() {
            if (instance == null) {
                instance = new DBConnection();
            }
            return instance;
        }

        public Connection getConnection() throws SQLException {
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        }
    }

    // Strategy Interface
    interface LoginStrategy {
        String login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
    }

    // Admin Strategy (sets role + session + loginSuccess flag)
    static class AdminLoginStrategy implements LoginStrategy {
        @Override
        public String login(HttpServletRequest request, HttpServletResponse response) {
            HttpSession session = request.getSession(true);
            session.setAttribute("username", "Admin");
            session.setAttribute("name", "System Admin");
            session.setAttribute("role", "ADMIN");
            session.setAttribute("loginSuccess", "true");  // <-- show success overlay on AdminDashboard.jsp
            session.setMaxInactiveInterval(30 * 60);
            return "AdminDashboard.jsp";
        }
    }

    // User Strategy (validates via DB; sets role + loginSuccess flag)
    static class UserLoginStrategy implements LoginStrategy {
        @Override
        public String login(HttpServletRequest request, HttpServletResponse response) throws ServletException {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            try (Connection conn = DBConnection.getInstance().getConnection()) {
                String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setString(1, username);
                pst.setString(2, password);

                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("name", rs.getString("first_name"));
                    session.setAttribute("accountNo", rs.getString("account_no"));
                    session.setAttribute("address", rs.getString("address"));
                    session.setAttribute("telephone", rs.getString("telephone"));
                    session.setAttribute("role", "USER");
                    session.setAttribute("loginSuccess", "true"); // <-- show overlay on user flow (Index.jsp)
                    session.setMaxInactiveInterval(30 * 60);
                    return "Index.jsp";
                } else {
                    request.setAttribute("errorMessage", "Invalid NIC or password!");
                    return "LoginFailed";
                }
            } catch (SQLException e) {
                throw new ServletException("Database login error", e);
            }
        }
    }

    // Factory
    static class LoginStrategyFactory {
        public static LoginStrategy getStrategy(String username, String password) {
            if ("Admin".equals(username) && "1212".equals(password)) { // <-- your admin password
                return new AdminLoginStrategy();
            }
            return new UserLoginStrategy();
        }
    }

    // Main Servlet Handler
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        LoginStrategy strategy = LoginStrategyFactory.getStrategy(username, password);
        String result = strategy.login(request, response);

        if ("LoginFailed".equals(result)) {
            RequestDispatcher rd = request.getRequestDispatcher("Index.jsp");
            rd.forward(request, response);
        } else {
            response.sendRedirect(result);
        }
    }
}

// ------------------------------
// AuthFilter.java
// ------------------------------
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter(urlPatterns = {
    "/AdminDashboard.jsp",
    "/ManageCustomers.jsp",
    "/ManageItems.jsp",
    "/Billing.jsp",
    "/Billinghistory.jsp",
    "/AdminMessages.jsp",
    "/AdminHelp.jsp"
})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no-op
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Prevent cached admin pages after logout/back-button
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP/1.1
        response.setHeader("Pragma", "no-cache"); // HTTP/1.0
        response.setDateHeader("Expires", 0);     // Proxies

        HttpSession session = request.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("username") != null);
        String role = (session == null) ? null : (String) session.getAttribute("role");
        boolean isAdmin = "ADMIN".equals(role);

        if (loggedIn && isAdmin) {
            chain.doFilter(req, res); // allow access
        } else {
            // Optional message
            request.setAttribute("errorMessage", "Please login as Admin to access that page.");
            request.getRequestDispatcher("Index.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        // no-op
    }
}

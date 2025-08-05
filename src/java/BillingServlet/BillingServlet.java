import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.Base64;

public class BillingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        PrintWriter out = res.getWriter();

        String nic = req.getParameter("nic");
        String accountNo = req.getParameter("account_no");
        String[] itemCodes = req.getParameterValues("item_code");
        String[] prices = req.getParameterValues("price");
        String[] quantities = req.getParameterValues("quantity");
        String[] totals = req.getParameterValues("total");
        String imageData = req.getParameter("billImage");

        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");

            // Insert bill items
            if (itemCodes != null && prices != null && quantities != null && totals != null) {
                PreparedStatement pst = con.prepareStatement(
                    "INSERT INTO bills(nic, account_no, item_code, price, quantity, total) VALUES (?, ?, ?, ?, ?, ?)"
                );

                for (int i = 0; i < itemCodes.length; i++) {
                    pst.setString(1, nic);
                    pst.setString(2, accountNo);
                    pst.setString(3, itemCodes[i]);
                    pst.setDouble(4, Double.parseDouble(prices[i]));
                    pst.setInt(5, Integer.parseInt(quantities[i]));
                    pst.setDouble(6, Double.parseDouble(totals[i]));
                    pst.addBatch();
                }

                pst.executeBatch();
                pst.close();
            }

            // Insert bill image
            if (imageData != null && imageData.startsWith("data:image/png;base64,")) {
                imageData = imageData.substring("data:image/png;base64,".length());
                byte[] imageBytes = Base64.getDecoder().decode(imageData);

                PreparedStatement imgStmt = con.prepareStatement(
                    "INSERT INTO bill_images(nic, account_no, image) VALUES (?, ?, ?)"
                );
                imgStmt.setString(1, nic);
                imgStmt.setString(2, accountNo);
                imgStmt.setBytes(3, imageBytes);
                imgStmt.executeUpdate();
                imgStmt.close();
            }

            con.close();
            res.sendRedirect("Billing.jsp?success=true");

        } catch (Exception e) {
            res.setContentType("text/html;charset=UTF-8");
            PrintWriter outErr = res.getWriter();
            outErr.println("<h2 style='color:red;'>Error saving bill. Full details:</h2>");
            outErr.println("<pre>");
            e.printStackTrace(outErr);
            outErr.println("</pre>");
            e.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

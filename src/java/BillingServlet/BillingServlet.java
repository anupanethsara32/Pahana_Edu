// BillingServlet.java
// Single-file version with Service + DAO + Models + DB helper inside.
// Behavior preserved: reads nic/account_no/item_code[]/price[]/quantity[]/total[]/billImage
// Writes to tables: bills, bill_images
// Redirects to: Billing.jsp?success=true

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.sql.DataSource;

@WebServlet(name = "BillingServlet", urlPatterns = {"/BillingServlet"})
public class BillingServlet extends HttpServlet {

    // --- Controller (kept thin) ------------------------------------------------
    private final BillingService service = new BillingService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        // Same parameter names as original
        String nic = req.getParameter("nic");
        String accountNo = req.getParameter("account_no");
        String[] itemCodes = req.getParameterValues("item_code");
        String[] prices = req.getParameterValues("price");
        String[] quantities = req.getParameterValues("quantity");
        String[] totals = req.getParameterValues("total");
        String imageData = req.getParameter("billImage");

        try {
            service.saveBill(nic, accountNo, itemCodes, prices, quantities, totals, imageData);
            res.sendRedirect("Billing.jsp?success=true"); // unchanged
        } catch (IllegalArgumentException iae) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST, iae.getMessage());
        } catch (Exception e) {
            // Don't leak stack traces to users; log server-side instead
            log("Error saving bill", e);
            res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error saving bill");
        }
    }

    // --- Service Layer ----------------------------------------------------------
    static class BillingService {
        private final BillingDAO dao = new BillingDAO();

        /**
         * Saves bill items and optional image in a single DB transaction.
         * Contract unchanged from original servlet.
         */
        public void saveBill(String nic, String accountNo,
                             String[] itemCodes, String[] prices, String[] quantities, String[] totals,
                             String imageDataUrl) throws SQLException {

            // Minimal contract validation (keeps original semantics)
            if (isBlank(nic))       throw new IllegalArgumentException("NIC is required");
            if (isBlank(accountNo)) throw new IllegalArgumentException("Account No is required");

            List<BillItem> items = toBillItems(nic, accountNo, itemCodes, prices, quantities, totals);
            BillImage image = decodeImage(nic, accountNo, imageDataUrl);

            try (Connection con = DB.getConnection()) {
                boolean oldAuto = con.getAutoCommit();
                con.setAutoCommit(false);   
                try {
                    dao.insertBillItems(con, items);
                    dao.insertBillImage(con, image);
                    con.commit();
                } catch (SQLException ex) {
                    con.rollback();
                    throw ex;
                } finally {
                    con.setAutoCommit(oldAuto);
                }
            }
        }

        private static boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }

        private List<BillItem> toBillItems(String nic, String accountNo,
                                           String[] itemCodes, String[] prices,
                                           String[] quantities, String[] totals) {
            List<BillItem> list = new ArrayList<>();
            if (itemCodes == null) return list;

            int len = itemCodes.length;
            for (int i = 0; i < len; i++) {
                String code = idx(itemCodes, i);
                String pStr = idx(prices, i);
                String qStr = idx(quantities, i);
                String tStr = idx(totals, i);
                if (code == null || pStr == null || qStr == null || tStr == null) continue;

                BigDecimal price = toMoney(pStr);
                int qty = toInt(qStr);
                BigDecimal total = toMoney(tStr);

                // Server-side recomputation to avoid tampering
                BigDecimal recomputed = price.multiply(BigDecimal.valueOf(qty));
                if (recomputed.compareTo(total) != 0) {
                    total = recomputed;
                }

                list.add(new BillItem(nic, accountNo, code, price, qty, total));
            }
            return list;
        }

        private BillImage decodeImage(String nic, String accountNo, String dataUrl) {
            if (dataUrl == null) return null;
            String prefix = "data:image/png;base64,";
            if (!dataUrl.startsWith(prefix)) return null;
            byte[] bytes = Base64.getDecoder().decode(dataUrl.substring(prefix.length()));
            return new BillImage(nic, accountNo, bytes);
        }

        private static String idx(String[] arr, int i) {
            return (arr != null && i < arr.length) ? arr[i] : null;
        }

        private static BigDecimal toMoney(String s) {
            try {
                // Using deprecated ROUND_HALF_UP constant for Java 8 compatibility; OK here
                return new BigDecimal(s).setScale(2, BigDecimal.ROUND_HALF_UP);
            } catch (Exception e) {
                return BigDecimal.ZERO.setScale(2, BigDecimal.ROUND_HALF_UP);
            }
        }

        private static int toInt(String s) {
            try { return Integer.parseInt(s); } catch (Exception e) { return 0; }
        }
    }

    // --- DAO Layer --------------------------------------------------------------
    static class BillingDAO {

        private static final String INSERT_ITEM_SQL =
                "INSERT INTO bills(nic, account_no, item_code, price, quantity, total) VALUES (?, ?, ?, ?, ?, ?)";

        private static final String INSERT_IMAGE_SQL =
                "INSERT INTO bill_images(nic, account_no, image) VALUES (?, ?, ?)";

        public void insertBillItems(Connection con, List<BillItem> items) throws SQLException {
            if (items == null || items.isEmpty()) return;
            try (PreparedStatement pst = con.prepareStatement(INSERT_ITEM_SQL)) {
                for (BillItem it : items) {
                    pst.setString(1, it.getNic());
                    pst.setString(2, it.getAccountNo());
                    pst.setString(3, it.getItemCode());
                    pst.setBigDecimal(4, it.getPrice());
                    pst.setInt(5, it.getQuantity());
                    pst.setBigDecimal(6, it.getTotal());
                    pst.addBatch();
                }
                pst.executeBatch();
            }
        }

        public void insertBillImage(Connection con, BillImage img) throws SQLException {
            if (img == null || img.getImageBytes() == null) return;
            try (PreparedStatement pst = con.prepareStatement(INSERT_IMAGE_SQL)) {
                pst.setString(1, img.getNic());
                pst.setString(2, img.getAccountNo());
                pst.setBytes(3, img.getImageBytes());
                pst.executeUpdate();
            }
        }
    }

    // --- Models -----------------------------------------------------------------
    static class BillItem {
        private final String nic;
        private final String accountNo;
        private final String itemCode;
        private final BigDecimal price;
        private final int quantity;
        private final BigDecimal total;

        public BillItem(String nic, String accountNo, String itemCode,
                        BigDecimal price, int quantity, BigDecimal total) {
            this.nic = nic;
            this.accountNo = accountNo;
            this.itemCode = itemCode;
            this.price = price;
            this.quantity = quantity;
            this.total = total;
        }

        public String getNic() { return nic; }
        public String getAccountNo() { return accountNo; }
        public String getItemCode() { return itemCode; }
        public BigDecimal getPrice() { return price; }
        public int getQuantity() { return quantity; }
        public BigDecimal getTotal() { return total; }
    }

    static class BillImage {
        private final String nic;
        private final String accountNo;
        private final byte[] imageBytes;

        public BillImage(String nic, String accountNo, byte[] imageBytes) {
            this.nic = nic;
            this.accountNo = accountNo;
            this.imageBytes = imageBytes;
        }

        public String getNic() { return nic; }
        public String getAccountNo() { return accountNo; }
        public byte[] getImageBytes() { return imageBytes; }
    }

    // --- DB Helper (JNDI DataSource with DriverManager fallback) ----------------
    static class DB {
        private static DataSource ds;

        static {
            // Try JNDI DataSource first (configure in server: java:comp/env/jdbc/pahana_edu_db)
            try {
                InitialContext ctx = new InitialContext();
                ds = (DataSource) ctx.lookup("java:comp/env/jdbc/pahana_edu_db");
            } catch (NamingException ignore) {
                ds = null;
            }
            // Ensure driver present for fallback
            try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (ClassNotFoundException e) {    /* ignore */ }
        }

        static Connection getConnection() throws SQLException {
            if (ds != null) return ds.getConnection();
            // Fallback (dev): keep same connection string as original code
            String url = "jdbc:mysql://localhost:3306/pahana_edu_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            String user = "root";
            String pass = "";
            return DriverManager.getConnection(url, user, pass);
        }
    }
}

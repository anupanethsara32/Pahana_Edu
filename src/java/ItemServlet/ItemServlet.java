import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ItemServlet")
@MultipartConfig(maxFileSize = 16177215) // 16MB max file size
public class ItemServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/pahana_edu_db";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                if ("add".equals(action)) {
                    String itemCode = request.getParameter("item_code");
                    String itemName = request.getParameter("item_name");
                    String category = request.getParameter("category");
                    double price = Double.parseDouble(request.getParameter("price"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    String description = request.getParameter("description");

                    Part imagePart = request.getPart("image");
                    InputStream imageStream = (imagePart != null && imagePart.getSize() > 0) ? imagePart.getInputStream() : null;

                    String sql = "INSERT INTO items (item_code, item_name, category, price, quantity, description, image, created_at) " +
                                 "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

                    try (PreparedStatement pst = conn.prepareStatement(sql)) {
                        pst.setString(1, itemCode);
                        pst.setString(2, itemName);
                        pst.setString(3, category);
                        pst.setDouble(4, price);
                        pst.setInt(5, quantity);
                        pst.setString(6, description);
                        if (imageStream != null) {
                            pst.setBlob(7, imageStream);
                        } else {
                            pst.setNull(7, Types.BLOB);
                        }
                        pst.executeUpdate();
                    }

                    request.getSession().setAttribute("message", "Item added successfully!");

                } else if ("delete".equals(action)) {
                    String code = request.getParameter("item_code");

                    String sql = "DELETE FROM items WHERE item_code = ?";
                    try (PreparedStatement pst = conn.prepareStatement(sql)) {
                        pst.setString(1, code);
                        pst.executeUpdate();
                    }

                    request.getSession().setAttribute("message", "Item deleted successfully!");

                } else if ("update".equals(action)) {
                    String itemCode = request.getParameter("item_code");
                    String itemName = request.getParameter("item_name");
                    String category = request.getParameter("category");
                    double price = Double.parseDouble(request.getParameter("price"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    String description = request.getParameter("description");

                    Part imagePart = request.getPart("image");
                    InputStream imageStream = (imagePart != null && imagePart.getSize() > 0) ? imagePart.getInputStream() : null;

                    String sql;
                    if (imageStream != null) {
                        sql = "UPDATE items SET item_name=?, category=?, price=?, quantity=?, description=?, image=? WHERE item_code=?";
                    } else {
                        sql = "UPDATE items SET item_name=?, category=?, price=?, quantity=?, description=? WHERE item_code=?";
                    }

                    try (PreparedStatement pst = conn.prepareStatement(sql)) {
                        pst.setString(1, itemName);
                        pst.setString(2, category);
                        pst.setDouble(3, price);
                        pst.setInt(4, quantity);
                        pst.setString(5, description);

                        if (imageStream != null) {
                            pst.setBlob(6, imageStream);
                            pst.setString(7, itemCode);
                        } else {
                            pst.setString(6, itemCode);
                        }

                        pst.executeUpdate();
                    }

                    request.getSession().setAttribute("message", "Item updated successfully!");
                }
            }

        } catch (Exception e) {
            throw new ServletException("ItemServlet error: " + e.getMessage(), e);
        }

        response.sendRedirect("ManageItems.jsp");
    }
}

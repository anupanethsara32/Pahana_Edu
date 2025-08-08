import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteBillServlet extends HttpServlet {
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String id = request.getParameter("id");

    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
      PreparedStatement pst = con.prepareStatement("DELETE FROM bill_images WHERE id = ?");
      pst.setString(1, id);
      pst.executeUpdate();
      pst.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
    }

    response.sendRedirect("Billinghistory.jsp");
  }
}

package servlets;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/UploadProfilePicServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Max 5MB
public class UploadProfilePicServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String nic = request.getParameter("nic");
        Part filePart = request.getPart("profilePic");

        if (filePart != null && nic != null && !nic.trim().isEmpty()) {
            try {
                InputStream inputStream = filePart.getInputStream();

                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");

                PreparedStatement pst = con.prepareStatement("UPDATE users SET profile_pic = ? WHERE nic = ?");
                pst.setBlob(1, inputStream);
                pst.setString(2, nic);

                int rows = pst.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect("UserDashboard.jsp");
                } else {
                    response.getWriter().println("Profile picture update failed. Invalid NIC?");
                }

                pst.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Error: " + e.getMessage());
            }
        } else {
            response.getWriter().println("NIC or image file is missing.");
        }
    }
}

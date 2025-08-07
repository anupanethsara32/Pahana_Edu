<%@ page import="java.util.*, java.sql.*" %>
<%@ page session="true" %>
<%
    String accountNo = (String) session.getAttribute("accountNo");
    if (accountNo == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Bills - Pahana Edu</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <style>
    body {
      background: #f8f9fa;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    .card {
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    .bill-image {
      max-width: 100%;
      border-radius: 10px;
      cursor: pointer;
      transition: 0.3s;
    }
    .bill-image:hover {
      transform: scale(1.02);
    }
    .modal-img {
      width: 100%;
      border-radius: 10px;
    }
  </style>
</head>
<body class="container py-5">
  <h2 class="mb-4 text-center text-primary">My Generated Bills</h2>
  <div class="row g-4">
    <% 
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
        PreparedStatement pst = con.prepareStatement("SELECT id, image, created_at FROM bill_images WHERE account_no = ? ORDER BY created_at DESC");
        pst.setString(1, accountNo);
        ResultSet rs = pst.executeQuery();
        while (rs.next()) {
          int id = rs.getInt("id");
          Blob imgBlob = rs.getBlob("image");
          String created = rs.getString("created_at");
          byte[] imgBytes = imgBlob.getBytes(1, (int) imgBlob.length());
          String base64Image = Base64.getEncoder().encodeToString(imgBytes);
    %>
    <div class="col-md-4">
      <div class="card p-3">
        <img src="data:image/png;base64,<%=base64Image%>" class="bill-image" alt="Bill Image" data-bs-toggle="modal" data-bs-target="#viewModal<%=id%>">
        <p class="mt-2 text-muted">Created At: <%=created%></p>
      </div>
    </div>

    <!-- Modal for Enlarged Image -->
    <div class="modal fade" id="viewModal<%=id%>" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Bill Preview</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body text-center">
            <img src="data:image/png;base64,<%=base64Image%>" class="modal-img" />
          </div>
        </div>
      </div>
    </div>
    <% } rs.close(); pst.close(); con.close();
      } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error loading bills: " + e.getMessage() + "</div>");
      }
    %>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

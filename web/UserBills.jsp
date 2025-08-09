<%@ page import="java.util.*, java.sql.*, java.util.Base64" %>
<%@ page session="true" %>
<%
    String accountNo = (String) session.getAttribute("accountNo");
    if (accountNo == null) {
        response.sendRedirect("Index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Bills - Pahana Edu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- Bootstrap + FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

  <style>
    body { background-color: #f0f4f8; font-family: 'Segoe UI', sans-serif; margin:0; }

    /* --- Sidebar (copied from UserDashboard.jsp) --- */
    .sidebar {
      display: flex; flex-direction: column; justify-content: space-between;
      height: 100vh; width: 250px; position: fixed; left: 0; top: 0;
      background-color: #0097c2; color: #fff; padding: 30px 0;
    }
    .sidebar h4 { text-align: center; font-weight: bold; margin-bottom: 30px; }
    .sidebar a { display: block; padding: 12px 20px; color: #fff; text-decoration: none; transition: background 0.3s; }
    .sidebar a:hover { background-color: #007ba3; }
    .logout-btn {
      margin: 20px; background-color: #dc3545 !important; border-radius: 30px; padding: 12px 0;
      font-weight: bold; text-align: center; color: #fff !important; text-decoration: none; display: block;
    }
    .logout-btn:hover { background-color: #b02a37 !important; }

    /* --- Page content --- */
    .content { margin-left: 250px; padding: 30px; }
    .header-bar {
      background: linear-gradient(to right, #0abcf9, #0097c2);
      color: #fff; padding: 30px; border-radius: 0 0 20px 20px; text-align: center;
    }

    .bill-card {
      background-color: #fff; border-radius: 15px; padding: 20px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.07); transition: 0.3s; height: 100%;
    }
    .bill-image { max-width: 100%; border-radius: 10px; cursor: pointer; transition: transform 0.3s; }
    .bill-image:hover { transform: scale(1.03); }

    .modal-img { width: 100%; border-radius: 10px; }

    .footer { text-align: center; margin-top: 60px; padding: 20px; font-size: 14px; color: #888; }

    @media (max-width: 768px) {
      .sidebar { width: 100%; height: auto; position: relative; }
      .content { margin-left: 0; padding: 20px; }
    }
  </style>
</head>
<body>

<!-- Sidebar (same as UserDashboard.jsp) -->
<div class="sidebar">
  <div>
    <h4><i class="fas fa-user-circle me-2"></i>My Dashboard</h4>
    <a href="UserDashboard.jsp"><i class="fas fa-home me-2"></i>Home</a>
    <a href="UserBills.jsp"><i class="fas fa-file-invoice me-2"></i>View Bills</a>
  </div>
  <a href="#" class="logout-btn" data-bs-toggle="modal" data-bs-target="#logoutModal">
    <i class="fas fa-power-off me-2"></i>Exit System
  </a>
</div>

<!-- Page Content -->
<div class="content">
  <!-- Header -->
  <div class="header-bar">
    <h2>My Bill History</h2>
    <p>All your saved bills in one place</p>
  </div>

  <!-- Bill List -->
  <div class="container mt-5">
    <div class="row g-4">
      <%
        try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
          PreparedStatement pst = con.prepareStatement(
            "SELECT id, image, created_at FROM bill_images WHERE account_no = ? ORDER BY created_at DESC");
          pst.setString(1, accountNo);
          ResultSet rs = pst.executeQuery();
          boolean hasBills = false;
          while (rs.next()) {
            hasBills = true;
            int id = rs.getInt("id");
            Blob imgBlob = rs.getBlob("image");
            String created = rs.getString("created_at");
            byte[] imgBytes = imgBlob.getBytes(1, (int) imgBlob.length());
            String base64Image = Base64.getEncoder().encodeToString(imgBytes);
      %>
      <div class="col-md-4">
        <div class="bill-card text-center">
          <img src="data:image/png;base64,<%=base64Image%>" class="bill-image" alt="Bill Image"
               data-bs-toggle="modal" data-bs-target="#viewModal<%=id%>">
          <p class="mt-3 text-muted">Created At: <%=created%></p>
        </div>
      </div>

      <!-- Preview Modal for this bill -->
      <div class="modal fade" id="viewModal<%=id%>" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Bill Preview</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
              <img src="data:image/png;base64,<%=base64Image%>" class="modal-img" alt="Bill Full Image" />
            </div>
          </div>
        </div>
      </div>
      <%
          } // while
          if (!hasBills) {
            out.println("<div class='col-12'><div class='alert alert-info text-center'>No bills found yet.</div></div>");
          }
          rs.close(); pst.close(); con.close();
        } catch (Exception e) {
          out.println("<div class='alert alert-danger'>Error loading bills: " + e.getMessage() + "</div>");
        }
      %>
    </div>

    <!-- Back Button -->
    <div class="text-center mt-4">
      <a href="UserDashboard.jsp" class="btn btn-outline-primary">
        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
      </a>
    </div>
  </div>

  <!-- Footer -->
  <div class="footer">
    &copy; 2025 Pahana Edu. All rights reserved.
  </div>
</div>

<!-- Logout Confirmation Modal -->
<div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-danger">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title" id="logoutModalLabel">Confirm Exit</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">Are you sure you want to exit the system?</div>
      <div class="modal-footer">
        <a href="logout.jsp" class="btn btn-danger">Yes, Exit</a>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

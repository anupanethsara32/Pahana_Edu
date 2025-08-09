<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Bill History - Pahana Edu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f8f9fa;
      margin: 0;
    }
    .sidebar {
      height: 100vh;
      width: 250px;
      position: fixed;
      left: 0;
      top: 0;
      background-color: #0097c2;
      color: white;
      padding-top: 20px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }
    .sidebar h4 {
      text-align: center;
      font-weight: bold;
      margin-bottom: 20px;
    }
    .sidebar a {
      display: block;
      padding: 12px 20px;
      color: white;
      text-decoration: none;
      transition: background 0.3s;
    }
    .sidebar a:hover {
      background-color: #0abcf9;
    }
    .logout-btn {
      margin: 20px;
      background-color: #dc3545 !important;
      border-radius: 30px;
      padding: 12px 0;
      font-weight: bold;
      text-align: center;
      color: white !important;
      text-decoration: none;
      display: block;
      transition: background-color 0.3s ease;
    }
    .logout-btn:hover {
      background-color: #b02a37 !important;
    }
    .content {
      margin-left: 250px;
      padding: 30px;
    }
    .bill-card {
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .bill-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
    }
    .bill-img {
      width: 100%;
      height: 250px;
      object-fit: contain;
      cursor: pointer;
      border-radius: 10px;
    }
    .modal-img {
      width: 100%;
      border-radius: 8px;
    }
    .nic-label {
      font-size: 0.85rem;
      font-weight: 500;
    }
    .card-footer {
      background: transparent;
      border-top: none;
    }
    @media (max-width: 768px) {
      .sidebar {
        width: 100%;
        height: auto;
        position: relative;
      }
      .content {
        margin-left: 0;
      }
    }
  </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
  <div>
    <h4>Pahana Edu</h4>
    <a href="AdminDashboard.jsp"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a>
    <a href="Register.jsp"><i class="fas fa-user-plus me-2"></i>Add New Customer</a>
    <a href="ManageCustomers.jsp"><i class="fas fa-users me-2"></i>Manage Customers</a>
    <a href="ManageItems.jsp"><i class="fas fa-book me-2"></i>Manage Items</a>
    <a href="Billing.jsp"><i class="fas fa-file-invoice me-2"></i>Billing</a>
    <a href="Billinghistory.jsp"><i class="fas fa-history me-2"></i>Bill History</a>
    <a href="AdminMessages.jsp"><i class="fas fa-envelope me-2"></i>Contact Messages</a>
    <a href="AdminHelp.jsp"><i class="fas fa-info-circle me-2"></i>Help</a>
  </div>
  <a href="logout.jsp" class="logout-btn" data-bs-toggle="modal" data-bs-target="#logoutModal">
  <i class="fas fa-power-off me-2"></i>Exit System
</a>

</div>

<!-- Main Content -->
<div class="content">
  <h2 class="mb-4 text-center " style="color:#000;">Bill History</h2>

  <!-- Message display -->
  <%
    String msg = (String) session.getAttribute("message");
    if (msg != null) {
      String alertType = msg.toLowerCase().contains("error") ? "danger" : "success";
  %>
    <div class="alert alert-<%= alertType %> alert-dismissible fade show" role="alert">
      <%= msg %>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  <%
      session.removeAttribute("message");
    }
  %>

  <div class="row g-4">
    <%
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT id, nic, image FROM bill_images ORDER BY id DESC");

        while (rs.next()) {
          String id = rs.getString("id");
          String nic = rs.getString("nic");
          byte[] imgBytes = rs.getBytes("image");
          String base64 = java.util.Base64.getEncoder().encodeToString(imgBytes);
    %>
    <div class="col-md-4">
      <div class="card bill-card p-3">
        <img src="data:image/png;base64,<%=base64%>" class="bill-img" data-bs-toggle="modal" data-bs-target="#viewModal<%=id%>">
        <div class="card-footer mt-3 d-flex justify-content-between align-items-center flex-wrap">
          <span class="text-muted nic-label">NIC: <%=nic%></span>
          <div class="btn-group">
            <a href="data:image/png;base64,<%=base64%>" download="Bill_<%=nic%>_<%=id%>.png" class="btn btn-sm btn-outline-success" title="Download"><i class="fas fa-download"></i></a>
            <button onclick="printImage('<%=base64%>')" class="btn btn-sm btn-outline-primary" title="Print"><i class="fas fa-print"></i></button>
            <button class="btn btn-sm btn-outline-danger" title="Delete" data-bs-toggle="modal" data-bs-target="#deleteModal<%=id%>"><i class="fas fa-trash-alt"></i></button>
          </div>
        </div>
      </div>
    </div>

    <!-- View Bill Modal -->
    <div class="modal fade" id="viewModal<%=id%>" tabindex="-1">
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Bill - NIC: <%=nic%></h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <img src="data:image/png;base64,<%=base64%>" class="modal-img">
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal<%=id%>" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0">
          <div class="modal-header bg-danger text-white">
            <h5 class="modal-title">Confirm Delete</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
          </div>
          <form action="DeleteBillServlet" method="post">
            <input type="hidden" name="id" value="<%=id%>">
            <div class="modal-body">
              Are you sure you want to delete this bill?
            </div>
            <div class="modal-footer">
              <button type="submit" class="btn btn-danger">Yes, Delete</button>
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <%
        }
        rs.close(); st.close(); con.close();
      } catch (Exception e) {
        out.print("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
      }
    %>
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
      <div class="modal-body">
        Are you sure you want to exit the system?
      </div>
      <div class="modal-footer">
        <a href="logout.jsp" class="btn btn-danger">Yes, Exit</a>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
  
  
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function printImage(base64) {
    const win = window.open();
    win.document.write('<html><head><title>Print Bill</title></head><body style="margin:0"><img src="data:image/png;base64,' + base64 + '" style="width:100%"></body></html>');
    win.document.close();
    win.focus();
    win.print();
    win.close();
  }
</script>
</body>
</html>

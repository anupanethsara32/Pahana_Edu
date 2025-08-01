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
</head>
<body>

<!-- Sidebar -->
<div class="d-flex flex-column justify-content-between bg-primary text-white p-3" style="width:250px; height:100vh; position:fixed;">
  <div>
    <h4 class="text-center fw-bold mb-4">Pahana Edu</h4>
    <a href="AdminDashboard.jsp" class="text-white text-decoration-none d-block mb-2"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a>
    <a href="Register.jsp" class="text-white text-decoration-none d-block mb-2"><i class="fas fa-user-plus me-2"></i>Add New Customer</a>
    <a href="ManageCustomers.jsp" class="text-white text-decoration-none d-block mb-2"><i class="fas fa-users me-2"></i>Manage Customers</a>
    <a href="ManageItems.jsp" class="text-white text-decoration-none d-block mb-2"><i class="fas fa-book me-2"></i>Manage Items</a>
    <a href="Billing.jsp" class="text-white text-decoration-none d-block mb-2"><i class="fas fa-file-invoice me-2"></i>Billing</a>
    <a href="Billinghistory.jsp" class="text-white text-decoration-none d-block mb-2"><i class="fas fa-history me-2"></i>Bill History</a>
    <a href="AdminMessages.jsp" class="text-white text-decoration-none d-block mb-2"><i class="fas fa-envelope me-2"></i>Contact Messages</a>
    <a href="AdminHelp.jsp" class="text-white text-decoration-none d-block mb-2"><i class="fas fa-info-circle me-2"></i>Help</a>
  </div>
  <a href="logout.jsp" class="btn btn-danger text-white w-100 mt-3" data-bs-toggle="modal" data-bs-target="#logoutModal"><i class="fas fa-power-off me-2"></i>Exit System</a>
</div>

<!-- Main Content -->
<div class="container-fluid" style="margin-left: 260px;">
  <div class="py-4 text-center">
    <h2 class="text-primary">Bill History</h2>
  </div>

  <!-- Message display -->
  <%
    String msg = (String) session.getAttribute("message");
    if (msg != null) {
      String alertType = msg.toLowerCase().contains("error") ? "danger" : "success";
  %>
    <div class="alert alert-<%= alertType %> alert-dismissible fade show" role="alert">
      <%= msg %>
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
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
      <div class="card shadow-sm">
        <img src="data:image/png;base64,<%=base64%>" class="card-img-top" data-bs-toggle="modal" data-bs-target="#viewModal<%=id%>">
        <div class="card-body">
          <p class="card-text">NIC: <%=nic%></p>
          <div class="d-flex justify-content-between">
            <a href="data:image/png;base64,<%=base64%>" download="Bill_<%=nic%>_<%=id%>.png" class="btn btn-sm btn-success"><i class="fas fa-download"></i></a>
            <button onclick="printImage('<%=base64%>')" class="btn btn-sm btn-primary"><i class="fas fa-print"></i></button>
            <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal<%=id%>"><i class="fas fa-trash-alt"></i></button>
          </div>
        </div>
      </div>
    </div>

    <!-- View Modal -->
    <div class="modal fade" id="viewModal<%=id%>" tabindex="-1">
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Bill - NIC: <%=nic%></h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <img src="data:image/png;base64,<%=base64%>" class="img-fluid">
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Modal -->
    <div class="modal fade" id="deleteModal<%=id%>" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <form action="DeleteBillServlet" method="post">
            <input type="hidden" name="id" value="<%=id%>">
            <div class="modal-header bg-danger text-white">
              <h5 class="modal-title">Confirm Delete</h5>
              <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
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
        out.print("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
      }
    %>
  </div>
</div>

<!-- Logout Modal -->
<div class="modal fade" id="logoutModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title">Confirm Exit</h5>
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
    win.document.write('<html><head><title>Print Bill</title></head><body><img src="data:image/png;base64,' + base64 + '" style="width:100%"></body></html>');
    win.document.close();
    win.focus();
    win.print();
    win.close();
  }
</script>
</body>
</html>

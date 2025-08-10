<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // ---- Compute next account number for display (server still generates real one) ----
  String nextAccountNo = "PAH-10001";
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
         Statement stmt = con.createStatement();
         ResultSet rs = stmt.executeQuery("SELECT COALESCE(MAX(CAST(SUBSTRING(account_no,5) AS UNSIGNED)),10000) AS max_acc FROM users")) {
      if (rs.next()) nextAccountNo = "PAH-" + (rs.getInt("max_acc") + 1);
    }
  } catch (Exception e) {
    nextAccountNo = "ERR";
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin • Create Customer</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <style>
    :root{ --brand:#00b7e2; --brand-dark:#009ec5; --soft-border:#e6eef8; }
    body{font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;background:#f6f9fc;margin:0}
    /* Sidebar */
    .sidebar{
      height:100vh;width:250px;position:fixed;left:0;top:0;background:#0097c2;color:#fff;
      padding-top:20px;display:flex;flex-direction:column;justify-content:space-between
    }
    .sidebar h4{text-align:center;font-weight:700;margin-bottom:20px}
    .sidebar a{display:block;padding:12px 20px;color:#fff;text-decoration:none;transition:background .3s}
    .sidebar a:hover{background:#0abcf9}
    .logout-btn{margin:20px;background:#dc3545!important;border-radius:30px;padding:12px 0;font-weight:700;text-align:center;color:#fff!important;display:block}
    .logout-btn:hover{background:#b02a37!important}
    /* Centered content */
    .content{margin-left:250px;min-height:100vh;display:flex;align-items:center;justify-content:center;padding:30px}
    /* Card */
    .form-shell{
      background:#fff;border-radius:18px;padding:36px 32px;border:1px solid var(--soft-border);
      box-shadow:0 10px 30px rgba(9,30,66,.05);width:100%;max-width:650px
    }
    .form-shell h3{font-weight:700;margin-bottom:24px}
    .form-label{font-weight:600;margin-bottom:6px}
    .form-control{padding:14px 16px;border-radius:12px;border:1px solid #dde6ee;font-size:16px}
    .form-control:focus{border-color:var(--brand);box-shadow:0 0 0 .2rem rgba(0,183,226,.18)}
    .help-text{color:#6b7280;font-size:.9rem;margin-top:2px}
    .btn-primary.brand{background:var(--brand);border:none;border-radius:999px;padding:14px;font-weight:700;width:100%}
    .btn-primary.brand:hover{background:var(--brand-dark)}
    @media (max-width: 992px){
      .content{margin-left:0;padding:20px}
      .sidebar{width:100%;height:auto;position:relative}
    }
  </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
  <div>
    <h4>Pahana Edu</h4>
    <a href="AdminDashboard.jsp"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a>
    <a href="RegisterAdmin.jsp"><i class="fas fa-user-plus me-2"></i>Add New Customer</a>
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
  <div class="form-shell">
    <h3>Create Customer <span style="color:#00b7e2">Pahana Edu</span></h3>

    <% String serverMsg = (String) request.getAttribute("message"); %>
    <% if (serverMsg != null && !"success".equals(request.getParameter("message"))) { %>
      <div class="alert alert-warning"><%= serverMsg %></div>
    <% } %>

    <form action="RegisterServlet" method="post" autocomplete="off">
      <input type="hidden" name="adminMode" value="1"/>

      <div class="mb-3">
        <label class="form-label">Account Number</label>
        <input type="text" class="form-control" value="<%= nextAccountNo %>" readonly>
      </div>

      <div class="row g-3">
        <div class="col-md-6">
          <input type="text" class="form-control" name="firstName" placeholder="First Name" required>
        </div>
        <div class="col-md-6">
          <input type="text" class="form-control" name="lastName" placeholder="Last Name" required>
        </div>

        <div class="col-md-6">
          <input type="text" class="form-control" name="nic" placeholder="NIC Number (username)" required>
          <div class="help-text">NIC will be used as the username.</div>
        </div>
        <div class="col-md-6">
          <input type="text" class="form-control" name="telephone" placeholder="Telephone" required>
        </div>

        <div class="col-12">
          <input type="text" class="form-control" name="address" placeholder="Home Address" required>
        </div>

        <div class="col-md-6">
          <input type="password" class="form-control" name="password" placeholder="Password" required>
        </div>
        <div class="col-md-6">
          <input type="password" class="form-control" name="confirmPassword" placeholder="Confirm Password" required>
        </div>
      </div>

      <button class="btn btn-primary brand mt-4">CREATE CUSTOMER</button>
    </form>
  </div>
</div>

<!-- Success Modal -->
<div class="modal fade" id="successModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow-lg">
      <div class="modal-body text-center p-5">
        <div class="display-4 text-success mb-3">
          <i class="fa-solid fa-circle-check"></i>
        </div>
        <h4 class="mb-2">Customer Created!</h4>
        <p class="text-muted mb-0">Redirecting to Manage Customers…</p>
      </div>
    </div>
  </div>
</div>

<!-- Logout Modal -->
<div class="modal fade" id="logoutModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-danger">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title">Confirm Exit</h5>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // If redirected with ?message=success, show modal and redirect
  (function () {
    const params = new URLSearchParams(window.location.search);
    if (params.get('message') === 'success') {
      const m = new bootstrap.Modal(document.getElementById('successModal'));
      m.show();
      setTimeout(() => { window.location.href = 'ManageCustomers.jsp'; }, 1800);
    }
  })();
</script>
</body>
</html>

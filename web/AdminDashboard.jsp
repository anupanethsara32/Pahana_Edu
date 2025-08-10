<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    HttpSession _sess = request.getSession(false);
    String _role = (_sess == null) ? null : (String) _sess.getAttribute("role");
    if (_sess == null || _sess.getAttribute("username") == null || !"ADMIN".equals(_role)) {
        response.sendRedirect("Index.jsp");
        return;
    }
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<%! 
    public static class DashboardStats {
        private int customerCount, itemCount, billCount;
        public int getCustomerCount() { return customerCount; }
        public void setCustomerCount(int v) { customerCount = v; }
        public int getItemCount() { return itemCount; }
        public void setItemCount(int v) { itemCount = v; }
        public int getBillCount() { return billCount; }
        public void setBillCount(int v) { billCount = v; }
    }
    public DashboardStats fetchDashboardStats() {
        DashboardStats stats = new DashboardStats();
        String url = "jdbc:mysql://localhost:3306/pahana_edu_db", user = "root", pass = "";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(url, user, pass);
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery("SELECT COUNT(*) AS total FROM users")) {
                if (rs.next()) stats.setCustomerCount(rs.getInt("total"));
            }
            try (Connection con = DriverManager.getConnection(url, user, pass);
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery("SELECT COUNT(*) AS total FROM items")) {
                if (rs.next()) stats.setItemCount(rs.getInt("total"));
            }
            try (Connection con = DriverManager.getConnection(url, user, pass);
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery("SELECT COUNT(*) AS total FROM bill_images")) {
                if (rs.next()) stats.setBillCount(rs.getInt("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }
%>

<%
    DashboardStats stats = fetchDashboardStats();
    String _loginSuccess = (String) session.getAttribute("loginSuccess");
    if ("true".equals(_loginSuccess)) {
        session.removeAttribute("loginSuccess");
%>
<div style="position:fixed; inset:0; background:rgba(0,0,0,.45); display:flex; align-items:center; justify-content:center; z-index:9999;">
  <div style="background:#fff; padding:30px; border-radius:10px; text-align:center; box-shadow:0 0 20px rgba(0,0,0,.10);">
    <div style="font-size:40px; color:#28a745; margin-bottom:10px;"><i class="fas fa-check-circle"></i></div>
    <h3>Login Successful</h3>
    <p>Welcome back, Admin!</p>
  </div>
</div>
<script>
  setTimeout(() => { document.querySelector('[style*="position:fixed"]').remove(); }, 2000);
</script>
<% } %>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Pahana Edu - Admin Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f8f9fa;
      margin: 0;
    }

    .dashboard-container {
      margin-left: 250px;
      padding: 100px 20px;
    }

    .dashboard-card {
      border-radius: 20px;
      padding: 50px;
      text-align: left;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
      background-color: #fff;
    }

    .dashboard-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
    }

    .dashboard-card .icon {
      float: left;
      margin-right: 25px;
      font-size: 40px;
    }

    .dashboard-card h5 {
      margin: 0;
      font-weight: bold;
    }

    .dashboard-card small {
      color: #6c757d;
      display: block;
      font-size: 20px;
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
    }

    .logout-btn:hover {
      background-color: #b02a37 !important;
    }

    @media (max-width: 768px) {
      .sidebar {
        width: 100%;
        height: auto;
        position: relative;
      }

      .dashboard-container {
        margin-left: 0;
        padding: 20px;
      }
    }
  </style>
</head>

<body>

<!-- Sidebar -->
<div class="sidebar">
  <div>
    <h4>Pahana Edu</h4>
    <a href="#"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a>
    <a href="AdminRegister.jsp"><i class="fas fa-user-plus me-2"></i>Add New Customer</a>
    <a href="ManageCustomers.jsp"><i class="fas fa-users me-2"></i>Manage Customers</a>
    <a href="ManageItems.jsp"><i class="fas fa-book me-2"></i>Manage Items</a>
    <a href="Billing.jsp"><i class="fas fa-file-invoice me-2"></i>Billing</a>
    <a href="Billinghistory.jsp"><i class="fas fa-history me-2"></i>Bill History</a>
    <a href="AdminMessages.jsp"><i class="fas fa-envelope me-2"></i>Contact Messages</a>
    <a href="AdminHelp.jsp"><i class="fas fa-info-circle me-2"></i>Help</a>
  </div>
  <a href="#" class="logout-btn" data-bs-toggle="modal" data-bs-target="#logoutModal">
    <i class="fas fa-power-off me-2"></i>Exit System
  </a>
</div>

<!-- Dashboard Content -->
<div class="dashboard-container text-center">
  <h2 class="mb-4">Admin Dashboard</h2>

  <!-- Row 1: 3 Cards -->
  <div class="row justify-content-center gx-4 gy-4">
    <div class="col-md-3">
      <a href="ManageCustomers.jsp" class="text-decoration-none text-dark">
        <div class="dashboard-card">
          <div class="icon text-primary"><i class="fas fa-users"></i></div>
          <div>
            <small>Total Customers</small>
            <h5><%= stats.getCustomerCount() %></h5>
          </div>
        </div>
      </a>
    </div>
    <div class="col-md-3">
      <a href="ManageItems.jsp" class="text-decoration-none text-dark">
        <div class="dashboard-card">
          <div class="icon text-success"><i class="fas fa-book"></i></div>
          <div>
            <small>Total Items</small>
            <h5><%= stats.getItemCount() %></h5>
          </div>
        </div>
      </a>
    </div>
    <div class="col-md-3">
      <a href="Billing.jsp" class="text-decoration-none text-dark">
        <div class="dashboard-card">
          <div class="icon text-warning"><i class="fas fa-file-invoice-dollar"></i></div>
          <div>
            <small>Bills Generated</small>
            <h5><%= stats.getBillCount() %></h5>
          </div>
        </div>
      </a>
    </div>
  </div>

  <!-- Row 2: 2 Cards -->
  <div class="row justify-content-center gx-4 gy-4 mt-3">
    <div class="col-md-3">
      <a href="RegisterAdmin.jsp" class="text-decoration-none text-dark">
        <div class="dashboard-card">
          <div class="icon text-secondary"><i class="fas fa-user-plus"></i></div>
          <div>
            <small>Add New Customer</small>
            <h5>Create Account</h5>
          </div>
        </div>
      </a>
    </div>
      
    <div class="col-md-3">
      <a href="AdminMessages.jsp" class="text-decoration-none text-dark">
        <div class="dashboard-card">
          <div class="icon text-danger"><i class="fas fa-envelope"></i></div>
          <div>
            <small>Contact Messages</small>
            <h6>View & Reply</h6>
          </div>
        </div>
      </a>
    </div>
  </div>

  <!-- Row 3: 2 Cards -->
  <div class="row justify-content-center gx-4 gy-4 mt-3">
    <div class="col-md-3">
      <a href="Billinghistory.jsp" class="text-decoration-none text-dark">
        <div class="dashboard-card">
          <div class="icon text-primary"><i class="fas fa-history"></i></div>
          <div>
            <small>Bill History</small>
            <h5>View & Manage</h5>
          </div>
        </div>
      </a>
    </div>
    <div class="col-md-3">
      <a href="AdminHelp.jsp" class="text-decoration-none text-dark">
        <div class="dashboard-card">
          <div class="icon text-info"><i class="fas fa-question-circle"></i></div>
          <div>
            <small>System Help</small>
            <h6>Usage Guide</h6>
          </div>
        </div>
      </a>
    </div>
  </div>
</div>

<!-- Logout Modal -->
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
</body>
</html>

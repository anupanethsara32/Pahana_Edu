<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>

<%
    String accountNo = (String) session.getAttribute("accountNo");
    if (accountNo == null) {
        response.sendRedirect("Index.jsp");
        return;
    }

    class User {
        String firstName, lastName, username, nic, address, telephone, createdAt;
        int billCount;
        String getFullName() { return (firstName!=null?firstName:"") + " " + (lastName!=null?lastName:""); }
        String getInitials() {
          String f = (firstName!=null && !firstName.isEmpty()) ? (""+firstName.charAt(0)).toUpperCase() : "U";
          String l = (lastName!=null && !lastName.isEmpty()) ? (""+lastName.charAt(0)).toUpperCase() : "";
          return f + l;
        }
    }

    User user = new User();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");

        PreparedStatement pst1 = con.prepareStatement("SELECT COUNT(*) FROM bill_images WHERE account_no = ?");
        pst1.setString(1, accountNo);
        ResultSet rs1 = pst1.executeQuery();
        if (rs1.next()) user.billCount = rs1.getInt(1);

        PreparedStatement pst2 = con.prepareStatement("SELECT * FROM users WHERE account_no = ?");
        pst2.setString(1, accountNo);
        ResultSet rs2 = pst2.executeQuery();
        if (rs2.next()) {
            user.firstName = rs2.getString("first_name");
            user.lastName = rs2.getString("last_name");
            user.username = rs2.getString("username");
            user.nic = rs2.getString("nic");
            user.address = rs2.getString("address");
            user.telephone = rs2.getString("telephone");
            user.createdAt = rs2.getString("created_at");
        }

        rs1.close(); rs2.close(); pst1.close(); pst2.close(); con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>User Dashboard - Pahana Edu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Bootstrap + FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

  <style>
    :root { --brand:#0097c2; --brand2:#0abcf9; --soft:#eef4fb; --soft-border:#e6eef8; }
    body { font-family:'Segoe UI', sans-serif; background:#f6f9fc; margin:0; }

    /* Sidebar */
    .sidebar{
      display:flex; flex-direction:column; justify-content:space-between;
      height:100vh; width:250px; position:fixed; left:0; top:0;
      background:#0097c2; color:#fff; padding:30px 0;
    }
    .sidebar h4{ text-align:center; font-weight:700; margin-bottom:30px; }
    .sidebar a{ display:block; padding:12px 20px; color:#fff; text-decoration:none; transition:background .3s; }
    .sidebar a:hover{ background:#0abcf9; }
    .logout-btn{
      margin:20px; background:#dc3545!important; border-radius:30px; padding:12px 0;
      font-weight:700; text-align:center; color:#fff!important; display:block; transition:background .3s;
    }
    .logout-btn:hover{ background:#b02a37!important; }

    /* Content */
    .content{ margin-left:250px; padding:30px; }

    /* Header */
    .header-bar{
      background:linear-gradient(135deg, var(--brand2), var(--brand));
      color:#fff; border-radius:18px; padding:24px; margin-bottom:22px;
      box-shadow:0 10px 30px rgba(9,30,66,.08);
    }
    .avatar{
      width:64px; height:64px; border-radius:50%; background:rgba(255,255,255,.2);
      display:flex; align-items:center; justify-content:center; font-weight:800; font-size:22px;
    }
    .copy-btn{ background:rgba(255,255,255,.15); color:#fff; border:0; padding:8px 12px; border-radius:10px; }
    .copy-btn:hover{ background:rgba(255,255,255,.25); }

    /* Cards */
    .card-box{
      background:#fff; border-radius:14px; padding:20px; height:100%;
      border:1px solid var(--soft-border); box-shadow:0 8px 22px rgba(9,30,66,.05);
    }
    .card-header-line{
      font-weight:700; color:#0a2a3a; margin-bottom:14px;
      border-bottom:2px solid var(--soft-border); padding-bottom:6px;
    }

    /* Stat cards */
    .stat{ text-align:center; }
    .stat .icon{
      width:44px; height:44px; border-radius:12px; display:flex; align-items:center; justify-content:center;
      background:#eef6ff; color:#0d6efd; margin:0 auto 8px auto;
    }

    .btn-action{ width:100%; }

    .footer{ text-align:center; font-size:13px; margin-top:40px; color:#777; }

    @media (max-width:768px) {
      .sidebar{ width:100%; height:auto; position:relative; }
      .content{ margin-left:0; padding:20px; }
      .header-bar{ border-radius:12px; }
    }
  </style>
</head>

<body>

<!-- Sidebar -->
<div class="sidebar">
  <div>
    <h4><i class="fas fa-user-circle me-2"></i>My Dashboard</h4>
    <a href="UserDashboard.jsp"><i class="fas fa-home me-2"></i>Home</a>
    <a href="UserBills.jsp"><i class="fas fa-file-invoice me-2"></i>View Bills</a>
  </div>
  <a href="logout.jsp" class="logout-btn" data-bs-toggle="modal" data-bs-target="#logoutModal">
    <i class="fas fa-power-off me-2"></i>Exit System
  </a>
</div>

<!-- Main Content -->
<div class="content">

  <!-- Password update alerts -->
  <%
    String pwd = request.getParameter("pwd");
    if ("ok".equals(pwd)) {
  %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <i class="fa-solid fa-check-circle me-2"></i>Password updated successfully.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  <%
    } else if ("fail".equals(pwd)) {
  %>
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
      <i class="fa-solid fa-triangle-exclamation me-2"></i>Please enter a new password.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  <%
    } else if ("short".equals(pwd)) {
  %>
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
      <i class="fa-solid fa-triangle-exclamation me-2"></i>Password must be at least 6 characters.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  <%
    } else if ("notfound".equals(pwd)) {
  %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <i class="fa-solid fa-circle-xmark me-2"></i>User not found. Try again.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  <%
    } else if ("err".equals(pwd)) {
  %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <i class="fa-solid fa-circle-xmark me-2"></i>Server error. Please try again later.
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  <%
    }
  %>

  <!-- Welcome / header -->
  <div class="header-bar d-flex align-items-center gap-3 flex-wrap">
    <div class="avatar"><%= user.getInitials() %></div>
    <div class="flex-grow-1">
      <h4 class="mb-1">Welcome, <strong><%= user.getFullName() %></strong> 👋</h4>
      <div class="small opacity-75">Account: <strong id="accNoText"><%= accountNo %></strong></div>
    </div>
    <div class="d-flex gap-2 ms-auto">
      <button class="copy-btn" id="copyAcc"><i class="fa-regular fa-copy me-2"></i>Copy Account No</button>
      <a href="UserBills.jsp" class="btn btn-light btn-sm"><i class="fa-solid fa-receipt me-1"></i> My Bill Images</a>
    </div>
  </div>

  <!-- Summary Cards -->
  <div class="row g-4">
    <div class="col-md-4">
      <div class="card-box stat">
        <div class="icon"><i class="fa-regular fa-id-badge"></i></div>
        <div class="text-muted">Account No</div>
        <div class="fs-5 fw-semibold"><%= accountNo %></div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card-box stat">
        <div class="icon" style="background:#fff5e6; color:#f59f00;"><i class="fa-regular fa-file-lines"></i></div>
        <div class="text-muted">Total Bills</div>
        <div class="fs-5 fw-semibold"><%= user.billCount %></div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card-box stat">
        <div class="icon" style="background:#eafaf1; color:#2fb344;"><i class="fa-solid fa-phone"></i></div>
        <div class="text-muted">Telephone</div>
        <div class="fs-5 fw-semibold"><%= user.telephone %></div>
      </div>
    </div>
  </div>

  <!-- Account Info and Actions -->
  <div class="row g-4 mt-1">
    <div class="col-md-6">
      <div class="card-box h-100">
        <div class="card-header-line"><i class="fas fa-user me-2"></i>Account Details</div>
        <div class="row">
          <div class="col-sm-6">
            <p class="mb-2"><span class="text-muted">First Name</span><br><strong><%= user.firstName %></strong></p>
            <p class="mb-2"><span class="text-muted">Last Name</span><br><strong><%= user.lastName %></strong></p>
            <p class="mb-2"><span class="text-muted">Full Name</span><br><strong><%= user.getFullName() %></strong></p>
          </div>
          <div class="col-sm-6">
            <p class="mb-2"><span class="text-muted">NIC</span><br><strong><%= user.nic %></strong></p>
            <p class="mb-2"><span class="text-muted">Username</span><br><strong><%= user.username %></strong></p>
            <p class="mb-0"><span class="text-muted">Created At</span><br><%= user.createdAt %></p>
          </div>
        </div>
        <p class="mt-3 mb-0"><span class="text-muted">Address</span><br><%= user.address %></p>
      </div>
    </div>

    <div class="col-md-6">
      <div class="card-box h-100">
        <div class="card-header-line"><i class="fas fa-bolt me-2"></i>Quick Actions</div>
        <form action="UpdatePasswordServlet" method="post" class="mb-3">
          <label class="form-label">New Password</label>
          <input type="password" name="newPassword" class="form-control mb-3" required>
          <input type="hidden" name="nic" value="<%= user.nic %>">
          <button type="submit" class="btn btn-outline-primary btn-action mb-2">
            <i class="fas fa-key me-2"></i>Update Password
          </button>
        </form>
        <a href="UserBills.jsp" class="btn btn-info text-white btn-action">
          <i class="fas fa-file-invoice me-2"></i>View My Bills
        </a>
      </div>
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

<!-- Bootstrap + helpers -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Copy Account Number
  document.getElementById('copyAcc')?.addEventListener('click', async function(){
    const txt = document.getElementById('accNoText')?.textContent?.trim() || '';
    try {
      await navigator.clipboard.writeText(txt);
      this.innerHTML = '<i class="fa-solid fa-check me-2"></i>Copied!';
      setTimeout(()=> this.innerHTML = '<i class="fa-regular fa-copy me-2"></i>Copy Account No', 1200);
    } catch(e){
      alert('Copy failed. Account No: ' + txt);
    }
  });
</script>
</body>
</html>

<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    // ----------------------------
    // 1. Session Validation
    // ----------------------------
    String accountNo = (String) session.getAttribute("accountNo");
    if (accountNo == null) {
        response.sendRedirect("Index.jsp");
        return;
    }

    // ----------------------------
    // 2. DTO - User Data Object
    // ----------------------------
    class User {
        String name, username, address, telephone, createdAt;
        int billCount;

        // Getters
        String getName() { return name; }
        String getUsername() { return username; }
        String getAccountNo() { return accountNo; }
        String getAddress() { return address; }
        String getTelephone() { return telephone; }
        String getCreatedAt() { return createdAt; }
        int getBillCount() { return billCount; }
    }

    // ----------------------------
    // 3. DAO Logic (DB + Fetch)
    // ----------------------------
    User user = new User();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");

        // Fetch bill count
        PreparedStatement pst1 = con.prepareStatement("SELECT COUNT(*) FROM bill_images WHERE account_no = ?");
        pst1.setString(1, accountNo);
        ResultSet rs1 = pst1.executeQuery();
        if (rs1.next()) user.billCount = rs1.getInt(1);

        // Fetch user details
        PreparedStatement pst2 = con.prepareStatement("SELECT * FROM users WHERE account_no = ?");
        pst2.setString(1, accountNo);
        ResultSet rs2 = pst2.executeQuery();
        if (rs2.next()) {
            user.name = rs2.getString("first_name");
            user.username = rs2.getString("username");
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
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
  <style>
    body {
      background-color: #f0f4f8;
      font-family: 'Segoe UI', sans-serif;
    }

    .header-bar {
      background: linear-gradient(to right, #0abcf9, #0097c2);
      color: white;
      padding: 30px;
      border-radius: 0 0 20px 20px;
      text-align: center;
    }

    .card-summary {
      border-radius: 15px;
      padding: 25px;
      color: white;
      font-size: 16px;
      font-weight: bold;
      text-align: center;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .card-blue { background-color: #0097c2; }
    .card-green { background-color: #28a745; }
    .card-yellow { background-color: #ffc107; }

    .detail-box {
      background-color: white;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 5px 20px rgba(0,0,0,0.05);
      margin-top: 40px;
    }

    .footer {
      text-align: center;
      padding: 20px;
      font-size: 14px;
      color: #888;
    }

    .logout-fixed {
      margin: 50px auto 20px;
      max-width: 300px;
      display: flex;
      justify-content: center;
    }

    .btn-action {
      width: 100%;
    }
  </style>
</head>

<body>

<!-- Header -->
<div class="header-bar">
  <h2>Welcome, <%= user.getName() %></h2>
  <p>Your personalized dashboard</p>
</div>

<!-- Summary Cards -->
<div class="container mt-5">
  <div class="row g-4">
    <div class="col-md-4">
      <div class="card-summary card-blue">
        <i class="fas fa-id-badge fa-2x mb-2"></i><br/>
        Account No: <%= user.getAccountNo() %>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card-summary card-yellow">
        <i class="fas fa-file-invoice fa-2x mb-2"></i><br/>
        Bills: <%= user.getBillCount() %>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card-summary card-green">
        <i class="fas fa-phone fa-2x mb-2"></i><br/>
        Tel: <%= user.getTelephone() %>
      </div>
    </div>
  </div>

  <!-- Details & Actions -->
  <div class="row mt-5">
    <div class="col-md-6">
      <div class="detail-box">
        <h5 class="text-primary mb-4">Account Details</h5>
        <p><strong>Username (NIC):</strong> <%= user.getUsername() %></p>
        <p><strong>Full Name:</strong> <%= user.getName() %></p>
        <p><strong>Address:</strong> <%= user.getAddress() %></p>
        <p><strong>Created On:</strong> <%= user.getCreatedAt() %></p>
      </div>
    </div>

    <div class="col-md-6">
      <div class="detail-box">
        <h5 class="text-primary mb-4">Quick Actions</h5>
        <form action="UpdatePasswordServlet" method="post">
          <label>New Password</label>
          <input type="password" name="newPassword" class="form-control mb-3" required>
          <input type="hidden" name="nic" value="<%= user.getUsername() %>">
          <button type="submit" class="btn btn-outline-primary btn-action mb-3">Update Password</button>
        </form>
        <a href="UserBills.jsp" class="btn btn-info text-white btn-action"><i class="fas fa-file-invoice me-2"></i>View My Bills</a>
      </div>
    </div>
  </div>
</div>

<!-- Logout at Bottom -->
<div class="logout-fixed">
  <a href="Logout.jsp" class="btn btn-danger w-100">
    <i class="fas fa-sign-out-alt me-2"></i> Logout
  </a>
</div>

<!-- Footer -->
<div class="footer">
  &copy; 2025 Pahana Edu. All rights reserved.
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

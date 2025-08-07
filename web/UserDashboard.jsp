<%@ page import="java.sql.*, java.util.*, java.util.Base64" %>
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
        byte[] profilePic;

        String getFullName() { return firstName + " " + lastName; }
    }

    User user = new User();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");

        // Count Bills
        PreparedStatement pst1 = con.prepareStatement("SELECT COUNT(*) FROM bill_images WHERE account_no = ?");
        pst1.setString(1, accountNo);
        ResultSet rs1 = pst1.executeQuery();
        if (rs1.next()) user.billCount = rs1.getInt(1);

        // Fetch User Details
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
            Blob picBlob = rs2.getBlob("profile_pic");
            if (picBlob != null) {
                user.profilePic = picBlob.getBytes(1, (int) picBlob.length());
            }
        }

        rs1.close(); rs2.close(); pst1.close(); pst2.close(); con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    String base64Image = (user.profilePic != null) ? Base64.getEncoder().encodeToString(user.profilePic) : null;
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
      padding: 40px 20px;
      border-radius: 0 0 25px 25px;
      text-align: center;
    }
    .card-summary {
      border-radius: 15px;
      padding: 25px;
      color: white;
      font-weight: bold;
      text-align: center;
      box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      transition: transform 0.3s;
    }
    .card-summary:hover { transform: scale(1.02); }
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
      padding: 25px;
      font-size: 14px;
      color: #777;
      margin-top: 60px;
    }

    .logout-fixed {
      margin: 40px auto 10px;
      max-width: 300px;
    }

    .btn-action {
      width: 100%;
    }

    .profile-pic {
      width: 130px;
      height: 130px;
      object-fit: cover;
      border-radius: 50%;
      border: 4px solid #fff;
      box-shadow: 0 2px 8px rgba(0,0,0,0.2);
      margin-bottom: 15px;
    }

    .upload-form {
      margin-top: 20px;
    }
  </style>
</head>

<body>

<!-- Header -->
<div class="header-bar">
  <% if (base64Image != null) { %>
    <img src="data:image/jpeg;base64,<%= base64Image %>" class="profile-pic" alt="Profile Picture">
  <% } else { %>
    <img src="https://via.placeholder.com/130?text=Profile" class="profile-pic" alt="Default Profile">
  <% } %>
  <h2>Welcome, <%= user.getFullName() %></h2>
  <p>Your personalized dashboard</p>
</div>

<!-- Summary Cards -->
<div class="container mt-5">
  <div class="row g-4">
    <div class="col-md-4">
      <div class="card-summary card-blue">
        <i class="fas fa-id-badge fa-2x mb-2"></i><br/>
        Account No: <%= accountNo %>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card-summary card-yellow">
        <i class="fas fa-file-invoice fa-2x mb-2"></i><br/>
        Bills: <%= user.billCount %>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card-summary card-green">
        <i class="fas fa-phone fa-2x mb-2"></i><br/>
        Tel: <%= user.telephone %>
      </div>
    </div>
  </div>

  <!-- Account Details & Actions -->
  <div class="row mt-5">
    <!-- Left: Account Info -->
    <div class="col-md-6">
      <div class="detail-box">
        <h5 class="text-primary mb-4"><i class="fas fa-user me-2"></i>Account Details</h5>
        <p><strong>First Name:</strong> <%= user.firstName %></p>
        <p><strong>Last Name:</strong> <%= user.lastName %></p>
        <p><strong>Full Name:</strong> <%= user.getFullName() %></p>
        <p><strong>NIC:</strong> <%= user.nic %></p>
        <p><strong>Username:</strong> <%= user.username %></p>
        <p><strong>Telephone:</strong> <%= user.telephone %></p>
        <p><strong>Address:</strong> <%= user.address %></p>
        <p><strong>Created At:</strong> <%= user.createdAt %></p>

        <!-- Upload Profile Picture -->
        <form class="upload-form" action="UploadProfilePicServlet" method="post" enctype="multipart/form-data">
          <label class="form-label">Update Profile Picture</label>
          <input type="file" name="profilePic" class="form-control mb-3" accept="image/*" required>
          <input type="hidden" name="nic" value="<%= user.nic %>">
          <button type="submit" class="btn btn-outline-success w-100"><i class="fas fa-upload me-2"></i>Upload</button>
        </form>
      </div>
    </div>

    <!-- Right: Password + Bill -->
    <div class="col-md-6">
      <div class="detail-box">
        <h5 class="text-primary mb-4"><i class="fas fa-tools me-2"></i>Quick Actions</h5>
        <form action="UpdatePasswordServlet" method="post">
          <label class="form-label">New Password</label>
          <input type="password" name="newPassword" class="form-control mb-3" required>
          <input type="hidden" name="nic" value="<%= user.nic %>">
          <button type="submit" class="btn btn-outline-primary btn-action mb-3">
            <i class="fas fa-key me-2"></i>Update Password
          </button>
        </form>
        <a href="UserBills.jsp" class="btn btn-info text-white btn-action">
          <i class="fas fa-file-invoice me-2"></i>View My Bills
        </a>
      </div>
    </div>
  </div>
</div>

<!-- Logout -->
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

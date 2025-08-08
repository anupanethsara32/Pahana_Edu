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
        String getFullName() { return firstName + " " + lastName; }
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
        }

        .sidebar {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100vh;
            width: 250px;
            position: fixed;
            left: 0;
            top: 0;
            background-color: #0097c2;
            color: white;
            padding: 30px 0;
        }

        .sidebar h4 {
            text-align: center;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .sidebar a {
            display: block;
            padding: 12px 20px;
            color: white;
            text-decoration: none;
            transition: background 0.3s;
        }

        .sidebar a:hover {
            background-color: #007ba3;
        }

        .logout-fixed {
            text-align: center;
            margin-bottom: 30px;
        }

        .content {
            margin-left: 250px;
            padding: 30px;
        }

        .card-box {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            height: 100%;
        }

        .card-header {
            font-weight: bold;
            color: #0097c2;
            margin-bottom: 15px;
            border-bottom: 2px solid #0097c2;
            padding-bottom: 5px;
        }

        .btn-action {
            width: 100%;
        }

        .footer {
            text-align: center;
            font-size: 13px;
            margin-top: 50px;
            color: #777;
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
    <div class="logout">
        <a href="logout.jsp" class="logout-btn" data-bs-toggle="modal" data-bs-target="#logoutModal">
  <i class="fas fa-power-off me-2"></i>Exit System
</a>

    </div>
</div>

<!-- Main Content -->
<div class="content">
    <h2 class="text-primary mb-3">Welcome, <%= user.getFullName() %> 👋</h2>
    <p class="text-muted mb-4">Here is your account overview and quick actions.</p>

    <!-- Summary Cards -->
    <div class="row g-4">
        <div class="col-md-4">       
            <div class="card-box text-center">
                <i class="fas fa-id-badge fa-2x text-primary mb-2"></i>
                <h5>Account No</h5>
                <p><%= accountNo %></p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-box text-center">
                <i class="fas fa-file-alt fa-2x text-warning mb-2"></i>
                <h5>Total Bills</h5>
                <p><%= user.billCount %></p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-box text-center">
                <i class="fas fa-phone fa-2x text-success mb-2"></i>
                <h5>Telephone</h5>
                <p><%= user.telephone %></p>
            </div>
        </div>
    </div>

    <!-- Account Info and Actions -->
    <div class="row g-4 mt-3">
        <div class="col-md-6">
            <div class="card-box h-100">
                <div class="card-header"><i class="fas fa-user me-2"></i>Account Details</div>
                <p><strong>First Name:</strong> <%= user.firstName %></p>
                <p><strong>Last Name:</strong> <%= user.lastName %></p>
                <p><strong>Full Name:</strong> <%= user.getFullName() %></p>
                <p><strong>NIC:</strong> <%= user.nic %></p>
                <p><strong>Username:</strong> <%= user.username %></p>
                <p><strong>Address:</strong> <%= user.address %></p>
                <p><strong>Created At:</strong> <%= user.createdAt %></p>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card-box h-100">
                <div class="card-header"><i class="fas fa-cogs me-2"></i>Quick Actions</div>
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

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

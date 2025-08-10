<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // Handle delete action if POST
  if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("delete_id") != null) {
    try {
      int deleteId = Integer.parseInt(request.getParameter("delete_id"));
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection delCon = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
      PreparedStatement ps = delCon.prepareStatement("DELETE FROM contact_messages WHERE id = ?");
      ps.setInt(1, deleteId);
      ps.executeUpdate();
      ps.close();
      delCon.close();
    } catch (Exception e) {
      out.println("<script>alert('Error deleting message: " + e.getMessage() + "');</script>");
    }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Admin - Contact Messages</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

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
    table td {
      word-break: break-word;
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
  <div class="container">
    <h2 class="mb-4" style="color:#000;">Contact Messages</h2>

    <div class="table-responsive">
      <table class="table table-bordered table-hover">
        <thead class="table-light">
          <tr>
            <th>#</th><th>Name</th><th>Email</th><th>Phone</th><th>Subject</th><th>Message</th><th>Date</th><th>Action</th>
          </tr>
        </thead>
        <tbody>
        <%
          try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM contact_messages ORDER BY submitted_at DESC");

            while (rs.next()) {
        %>
          <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("subject") %></td>
            <td><%= rs.getString("message") %></td>
            <td><%= rs.getTimestamp("submitted_at") %></td>
            <td>
              <form method="post" onsubmit="return confirm('Are you sure you want to delete this message?');">
                <input type="hidden" name="delete_id" value="<%= rs.getInt("id") %>">
                <button class="btn btn-sm btn-danger" title="Delete"><i class="fas fa-trash-alt"></i></button>
              </form>
            </td>
          </tr>
        <%
            }
            con.close();
          } catch (Exception e) {
            out.println("<tr><td colspan='8' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
          }
        %>
        </tbody>
      </table>
    </div>
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
</body>
</html>

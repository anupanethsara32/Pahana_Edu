<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Customers - Pahana Edu</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
      background-color: #dc3545;
      border-radius: 30px;
      padding: 12px 0;
      font-weight: bold;
      text-align: center;
      color: white;
      text-decoration: none;
    }
    .content {
      margin-left: 250px;
      padding: 40px 30px;
    }
    .popup {
      position: fixed;
      top: 20%;
      left: 50%;
      transform: translateX(-50%);
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.3);
      z-index: 9999;
      display: none;
    }
    .popup h4 {
      margin-bottom: 20px;
    }
    .popup .close-btn {
      float: right;
      cursor: pointer;
      font-size: 20px;
    }
    .table td, .table th {
      vertical-align: middle;
    }
    @media (max-width: 768px) {
      .sidebar {
        width: 100%;
        height: auto;
        position: relative;
      }
      .content {
        margin-left: 0;
        padding: 20px;
      }
    }
        .logout-btn {
        margin: 20px;
        background-color: #dc3545 !important;  /* Force red */
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
      background-color: #b02a37 !important;  /* Darker red on hover */
      color: white !important;
      text-decoration: none;
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
  <h2 class="mb-4">Manage Customers</h2>

  <!-- Search -->
  <form method="get" class="d-flex mb-3">
    <input type="text" name="search" class="form-control me-2" placeholder="Search by Name, NIC or Account No" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
    <button type="submit" class="btn btn-primary">Search</button>
  </form>

  <!-- Add Customer Button -->
  <a href="Register.jsp" class="btn btn-success mb-3">+ Add New Customer</a>

  <!-- Customers Table -->
  <table class="table table-bordered">
    <thead class="table-dark">
      <tr>
        <th>Account No</th>
        <th>Full Name</th>
        <th>Username (NIC)</th>
        <th>Address</th>
        <th>Telephone</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
    <%
      String search = request.getParameter("search");
      String query;
      Connection con = null;
      PreparedStatement pst = null;
      ResultSet rs = null;
      boolean hasResults = false;

      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");

        if (search != null && !search.trim().isEmpty()) {
          query = "SELECT * FROM users WHERE username LIKE ? OR first_name LIKE ? OR last_name LIKE ? OR account_no LIKE ?";
          pst = con.prepareStatement(query);
          for (int i = 1; i <= 4; i++) {
            pst.setString(i, "%" + search + "%");
          }
        } else {
          query = "SELECT * FROM users";
          pst = con.prepareStatement(query);
        }

        rs = pst.executeQuery();

        while (rs.next()) {
          hasResults = true;
    %>
      <tr>
        <td><%= rs.getString("account_no") %></td>
        <td><%= rs.getString("first_name") %> <%= rs.getString("last_name") %></td>
        <td><%= rs.getString("username") %></td>
        <td><%= rs.getString("address") %></td>
        <td><%= rs.getString("telephone") %></td>
        <td>
          <button type="button" class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal<%= rs.getString("username") %>">Edit</button>
          <form action="CustomerActionServlet" method="post" style="display:inline;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="username" value="<%= rs.getString("username") %>">
            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure to delete this customer?');">Delete</button>
          </form>
          <a href="ViewCustomerDetails.jsp?username=<%= rs.getString("username") %>" class="btn btn-info btn-sm"> Customer Account Information</a>

          <!-- Edit Modal -->
          <div class="modal fade" id="editModal<%= rs.getString("username") %>" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
              <div class="modal-content">
                <form action="CustomerActionServlet" method="post">
                  <input type="hidden" name="action" value="update">
                  <input type="hidden" name="username" value="<%= rs.getString("username") %>">
                  <div class="modal-header">
                    <h5 class="modal-title">Edit Customer - <%= rs.getString("username") %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <div class="mb-3">
                      <label>First Name</label>
                      <input type="text" name="firstName" class="form-control" value="<%= rs.getString("first_name") %>" required>
                    </div>
                    <div class="mb-3">
                      <label>Last Name</label>
                      <input type="text" name="lastName" class="form-control" value="<%= rs.getString("last_name") %>" required>
                    </div>
                    <div class="mb-3">
                      <label>Telephone</label>
                      <input type="text" name="telephone" class="form-control" value="<%= rs.getString("telephone") %>" required>
                    </div>
                    <div class="mb-3">
                      <label>Address</label>
                      <input type="text" name="address" class="form-control" value="<%= rs.getString("address") %>" required>
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="submit" class="btn btn-success">Update</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </td>
      </tr>
    <%
        }

        if (!hasResults) {
    %>
      <tr><td colspan="6" class="text-center text-muted">No customers found.</td></tr>
    <%
        }

      } catch(Exception e) {
        out.println("<tr><td colspan='6' class='text-danger'>Database error: " + e.getMessage() + "</td></tr>");
      } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (con != null) con.close();
      }
    %>
    </tbody>
  </table>

  <% if (search != null && !search.isEmpty()) { %>
    <div id="popup" class="popup">
      <span class="close-btn" onclick="document.getElementById('popup').style.display='none'">&times;</span>
      <h4>Search Result for "<%= search %>"</h4>
      <p>Matching customers have been listed.</p>
    </div>
    <script>document.getElementById("popup").style.display = "block";</script>
  <% } %>
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



</body>
</html>

<%@ page import="java.sql.*, java.util.Base64" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Items - Pahana Edu</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f8f9fa;
    }
    .sidebar {
      height: 100vh;
      width: 250px;
      position: fixed;
      top: 0;
      left: 0;
      background-color: #0097c2;
      color: white;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding-top: 20px;
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
    .item-image {
      width: 60px;
      height: 60px;
      object-fit: cover;
      border-radius: 5px;
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
  <h2 class="mb-4">Manage Items</h2>

  <% if (session.getAttribute("message") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <%= session.getAttribute("message") %>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("message"); %>
  <% } %>

  <!-- Add Item Form -->
  <form action="ItemServlet" method="post" enctype="multipart/form-data" class="row g-3 mb-5">
    <input type="hidden" name="action" value="add">
    <div class="col-md-3">
      <label>Item Name</label>
      <input type="text" name="item_name" class="form-control" id="itemName" required>
    </div>
    <div class="col-md-3">
      <label>Item Code</label>
      <div class="input-group">
        <input type="text" name="item_code" class="form-control" id="itemCode" readonly required>
        <button type="button" class="btn btn-outline-secondary" onclick="generateCode()">↻</button>
      </div>
    </div>
    <div class="col-md-2">
      <label>Category</label>
      <input type="text" name="category" class="form-control">
    </div>
    <div class="col-md-2">
      <label>Price</label>
      <input type="number" name="price" step="0.01" class="form-control" required>
    </div>
    <div class="col-md-2">
      <label>Quantity</label>
      <input type="number" name="quantity" class="form-control" required>
    </div>
    <div class="col-md-12">
      <label>Description</label>
      <textarea name="description" class="form-control"></textarea>
    </div>
    <div class="col-md-6">
      <label>Upload Image</label>
      <input type="file" name="image" accept="image/*" class="form-control">
    </div>
    <div class="col-12">
      <button type="submit" class="btn btn-success">Add Item</button>
    </div>
  </form>

  <!-- Items Table -->
  <table class="table table-bordered align-middle">
    <thead class="table-dark">
      <tr>
        <th>Image</th>
        <th>Item Code</th>
        <th>Name</th>
        <th>Category</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Description</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
    <%
      try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM items");

        while (rs.next()) {
          byte[] imgBytes = rs.getBytes("image");
          String base64Image = (imgBytes != null) ? Base64.getEncoder().encodeToString(imgBytes) : null;
    %>
      <tr>
        <td>
          <% if (base64Image != null) { %>
            <img src="data:image/jpeg;base64,<%= base64Image %>" class="item-image"/>
          <% } else { %>
            <span class="text-muted">No Image</span>
          <% } %>
        </td>
        <td><%= rs.getString("item_code") %></td>
        <td><%= rs.getString("item_name") %></td>
        <td><%= rs.getString("category") %></td>
        <td><%= rs.getDouble("price") %></td>
        <td><%= rs.getInt("quantity") %></td>
        <td><%= rs.getString("description") %></td>
        <td>
          <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal<%= rs.getString("item_code") %>">Edit</button>
          <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteModal<%= rs.getString("item_code") %>">Delete</button>
        </td>
      </tr>

      <!-- Edit Modal -->
      <div class="modal fade" id="editModal<%= rs.getString("item_code") %>" tabindex="-1">
        <div class="modal-dialog">
          <div class="modal-content">
            <form action="ItemServlet" method="post">
              <input type="hidden" name="action" value="update">
              <input type="hidden" name="item_code" value="<%= rs.getString("item_code") %>">
              <div class="modal-header">
                <h5 class="modal-title">Edit Item</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
              </div>
              <div class="modal-body">
                <div class="mb-3">
                  <label>Item Name</label>
                  <input type="text" name="item_name" class="form-control" value="<%= rs.getString("item_name") %>">
                </div>
                <div class="mb-3">
                  <label>Category</label>
                  <input type="text" name="category" class="form-control" value="<%= rs.getString("category") %>">
                </div>
                <div class="mb-3">
                  <label>Price</label>
                  <input type="number" name="price" step="0.01" class="form-control" value="<%= rs.getDouble("price") %>">
                </div>
                <div class="mb-3">
                  <label>Quantity</label>
                  <input type="number" name="quantity" class="form-control" value="<%= rs.getInt("quantity") %>">
                </div>
                <div class="mb-3">
                  <label>Description</label>
                  <textarea name="description" class="form-control"><%= rs.getString("description") %></textarea>
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

      <!-- Delete Modal -->
      <div class="modal fade" id="deleteModal<%= rs.getString("item_code") %>" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <form action="ItemServlet" method="post">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="item_code" value="<%= rs.getString("item_code") %>">
              <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
              </div>
              <div class="modal-body">
                Are you sure you want to delete the item <strong><%= rs.getString("item_name") %></strong>?
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
        rs.close(); stmt.close(); conn.close();
      } catch (Exception e) {
        out.print("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
      }
    %>
    </tbody>
  </table>
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
    
    
<script>
  function generateCode() {
    const name = document.getElementById("itemName").value.trim();
    const prefix = name.replace(/[^a-zA-Z0-9]/g, "").substring(0, 3).toUpperCase();
    const rand = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
    document.getElementById("itemCode").value = prefix + rand;
  }

  document.getElementById("itemName").addEventListener("input", generateCode);
</script>

</body>
</html>

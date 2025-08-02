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
</head>
<body>

<!-- Sidebar -->
<div class="bg-primary text-white p-3" style="width: 250px; height: 100vh; position: fixed;">
  <h4 class="text-center">Pahana Edu</h4>
  <a href="AdminDashboard.jsp" class="d-block text-white text-decoration-none mb-2"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a>
  <a href="Register.jsp" class="d-block text-white text-decoration-none mb-2"><i class="fas fa-user-plus me-2"></i>Add New Customer</a>
  <a href="ManageCustomers.jsp" class="d-block text-white text-decoration-none mb-2"><i class="fas fa-users me-2"></i>Manage Customers</a>
  <a href="ManageItems.jsp" class="d-block text-white text-decoration-none mb-2"><i class="fas fa-book me-2"></i>Manage Items</a>
  <a href="Billing.jsp" class="d-block text-white text-decoration-none mb-2"><i class="fas fa-file-invoice me-2"></i>Billing</a>
  <a href="Billinghistory.jsp" class="d-block text-white text-decoration-none mb-2"><i class="fas fa-history me-2"></i>Bill History</a>
  <a href="AdminMessages.jsp" class="d-block text-white text-decoration-none mb-2"><i class="fas fa-envelope me-2"></i>Contact Messages</a>
  <a href="AdminHelp.jsp" class="d-block text-white text-decoration-none mb-4"><i class="fas fa-info-circle me-2"></i>Help</a>
  <a href="logout.jsp" class="btn btn-danger w-100" data-bs-toggle="modal" data-bs-target="#logoutModal"><i class="fas fa-power-off me-2"></i>Exit System</a>
</div>

<!-- Main Content -->
<div class="container-fluid" style="margin-left: 260px;">
  <div class="pt-4">
    <h2>Manage Items</h2>

    <% if (session.getAttribute("message") != null) { %>
      <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
        <%= session.getAttribute("message") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
      <% session.removeAttribute("message"); %>
    <% } %>

    <!-- Add Item Form -->
    <form action="ItemServlet" method="post" enctype="multipart/form-data" class="row g-3 my-4">
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
    <table class="table table-bordered">
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
              <img src="data:image/jpeg;base64,<%= base64Image %>" width="60" height="60">
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

        <!-- Edit and Delete Modals are the same as in your original -->
        <!-- (omit here for brevity unless needed again) -->

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
</div>

<!-- Logout Modal -->
<div class="modal fade" id="logoutModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
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

<%@ page import="java.sql.*, java.util.*, java.util.Base64" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Items - Pahana Edu</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
  <style>
    :root { --brand:#0097c2; --brand2:#0abcf9; --soft:#eef4fb; --soft-border:#e6eef8; }
    body { margin:0; font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background:#f6f9fc; }

    /* Sidebar */
    .sidebar {
      height:100vh; width:250px; position:fixed; top:0; left:0;
      background:#0097c2; color:#fff; display:flex; flex-direction:column;
      justify-content:space-between; padding-top:20px;
    }
    .sidebar h4 { text-align:center; font-weight:700; margin-bottom:20px; }
    .sidebar a { display:block; padding:12px 20px; color:#fff; text-decoration:none; transition:background .3s; }
    .sidebar a:hover { background:#0abcf9; }
    .logout-btn {
      margin:20px; background:#dc3545!important; border-radius:30px; padding:12px 0;
      font-weight:700; text-align:center; color:#fff!important; display:block; transition:background .3s;
    }
    .logout-btn:hover { background:#b02a37!important; color:#fff!important; text-decoration:none; }

    /* Content */
    .content { margin-left:250px; padding:32px; }

    /* Header */
    .header-bar {
      background:linear-gradient(135deg, var(--brand2), var(--brand));
      color:#fff; border-radius:16px; padding:22px 24px; margin-bottom:20px;
      box-shadow:0 10px 30px rgba(9,30,66,.08);
    }
    .toolbar { gap:.5rem; }

    /* Card styles */
    .card-soft { background:#fff; border:1px solid var(--soft-border); border-radius:16px; box-shadow:0 10px 30px rgba(9,30,66,.05); }
    .card-soft .card-header { background:#fff; border-bottom:1px solid var(--soft-border); border-radius:16px 16px 0 0; }

    /* Form */
    .form-control, .form-select, textarea {
      padding:12px 14px; border-radius:12px; border:1px solid #dde6ee; font-size:15px;
    }
    .form-control:focus, .form-select:focus, textarea:focus {
      border-color:var(--brand); box-shadow:0 0 0 .2rem rgba(0,151,194,.15);
    }
    .btn-brand { background:var(--brand); border-color:var(--brand); color:#fff; }
    .btn-brand:hover { background:#077ba1; border-color:#077ba1; }

    /* Table */
    .table thead th { background:#eef6ff; border-bottom:0; }
    .table tbody td { vertical-align:middle; }
    .item-image { width:60px; height:60px; object-fit:cover; border-radius:8px; cursor:pointer; }
    .badge-code { background:#fff; color:#111; border:1px solid var(--soft-border); }

    @media (max-width:768px) {
      .sidebar { width:100%; height:auto; position:relative; }
      .content { margin-left:0; padding:20px; }
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

  <!-- Header + Toolbar -->
  <div class="header-bar d-flex flex-wrap align-items-center justify-content-between">
    <div class="d-flex align-items-center">
      <i class="fa-solid fa-book-open-reader me-2"></i>
      <h4 class="mb-0">Manage Items</h4>
    </div>
    <div class="toolbar d-flex">
      <input id="searchInput" class="form-control form-control-sm" placeholder="Search items…">
      <button id="btnCsv" class="btn btn-light btn-sm">
        <i class="fa-solid fa-download me-1"></i> CSV
      </button>
    </div>
  </div>

  <% if (session.getAttribute("message") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
      <%= session.getAttribute("message") %>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("message"); %>
  <% } %>

  <!-- Add Item Form -->
  <div class="card card-soft mb-4">
    <div class="card-header d-flex align-items-center justify-content-between">
      <span class="fw-semibold"><i class="fa-solid fa-plus me-2"></i>Add New Item</span>
      <small class="text-muted">Auto code from name (you can regenerate)</small>
    </div>
    <div class="card-body">
      <form action="ItemServlet" method="post" enctype="multipart/form-data" class="row g-3">
        <input type="hidden" name="action" value="add">
        <div class="col-md-4">
          <label class="form-label">Item Name</label>
          <input type="text" name="item_name" class="form-control" id="itemName" placeholder="e.g., Grade 10 Maths" required>
        </div>
        <div class="col-md-3">
          <label class="form-label">Item Code</label>
          <div class="input-group">
            <input type="text" name="item_code" class="form-control" id="itemCode" readonly required>
            <button type="button" class="btn btn-outline-secondary" onclick="generateCode()" title="Regenerate">
              <i class="fa-solid fa-rotate"></i>
            </button>
          </div>
        </div>
        <div class="col-md-2">
          <label class="form-label">Category</label>
          <input type="text" name="category" class="form-control" placeholder="e.g., Book">
        </div>
        <div class="col-md-2">
          <label class="form-label">Price (Rs.)</label>
          <input type="number" name="price" step="0.01" class="form-control" required>
        </div>
        <div class="col-md-1">
          <label class="form-label">Qty</label>
          <input type="number" name="quantity" class="form-control" required>
        </div>
        <div class="col-12">
          <label class="form-label">Description</label>
          <textarea name="description" class="form-control" rows="2" placeholder="Short description…"></textarea>
        </div>
        <div class="col-md-6">
          <label class="form-label">Upload Image</label>
          <input type="file" name="image" accept="image/*" class="form-control">
        </div>
        <div class="col-12 d-flex justify-content-end">
          <button type="submit" class="btn btn-brand">
            <i class="fa-solid fa-floppy-disk me-1"></i>Add Item
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- Items Table -->
  <div class="card card-soft">
    <div class="card-header fw-semibold">
      <i class="fa-solid fa-table me-2"></i> Items List
    </div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <table id="itemTable" class="table table-striped table-hover m-0 align-middle">
          <thead>
            <tr>
              <th style="width:90px;">Image</th>
              <th>Item Code</th>
              <th>Name</th>
              <th>Category</th>
              <th class="text-end">Price (Rs.)</th>
              <th class="text-end">Qty</th>
              <th>Description</th>
              <th style="width:160px;">Actions</th>
            </tr>
          </thead>
          <tbody>
          <%
            // Load items into memory to allow reuse for modals
            List<Map<String,Object>> items = new ArrayList<>();
            try {
              Class.forName("com.mysql.cj.jdbc.Driver");
              Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
              Statement stmt = conn.createStatement();
              ResultSet rs = stmt.executeQuery("SELECT * FROM items ORDER BY item_name");

              while (rs.next()) {
                Map<String,Object> it = new HashMap<>();
                it.put("item_code", rs.getString("item_code"));
                it.put("item_name", rs.getString("item_name"));
                it.put("category", rs.getString("category"));
                it.put("price", rs.getDouble("price"));
                it.put("quantity", rs.getInt("quantity"));
                it.put("description", rs.getString("description"));
                byte[] img = rs.getBytes("image");
                it.put("imageB64", (img != null ? Base64.getEncoder().encodeToString(img) : null));
                items.add(it);
              }
              rs.close(); stmt.close(); conn.close();
            } catch (Exception e) {
              out.print("<tr><td colspan='8' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
            }

            for (Map<String,Object> it : items) {
              String code = (String) it.get("item_code");
              String name = (String) it.get("item_name");
              String cat  = (String) it.get("category");
              String desc = (String) it.get("description");
              Double price = (Double) it.get("price");
              Integer qty  = (Integer) it.get("quantity");
              String b64 = (String) it.get("imageB64");
          %>
            <tr>
              <td>
                <% if (b64 != null) { %>
                  <img src="data:image/jpeg;base64,<%= b64 %>" class="item-image" data-bs-toggle="modal" data-bs-target="#imgModal<%= code %>"/>
                <% } else { %>
                  <span class="text-muted">No Image</span>
                <% } %>
              </td>
              <td><span class="badge badge-code rounded-pill px-3 py-2"><%= code %></span></td>
              <td><%= name %></td>
              <td><%= cat %></td>
              <td class="text-end"><%= String.format("%,.2f", price) %></td>
              <td class="text-end"><%= qty %></td>
              <td><%= desc %></td>
              <td>
                <div class="btn-group">
                  <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editModal<%= code %>">
                    <i class="fa-solid fa-pen-to-square"></i>
                  </button>
                  <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#deleteModal<%= code %>">
                    <i class="fa-solid fa-trash"></i>
                  </button>
                </div>
              </td>
            </tr>

            <!-- Image Preview Modal -->
            <div class="modal fade" id="imgModal<%= code %>" tabindex="-1" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                  <div class="modal-body p-0">
                    <% if (b64 != null) { %>
                      <img src="data:image/jpeg;base64,<%= b64 %>" class="w-100" style="border-radius: .3rem;">
                    <% } %>
                  </div>
                </div>
              </div>
            </div>

            <!-- Edit Modal -->
            <div class="modal fade" id="editModal<%= code %>" tabindex="-1" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
                  <form action="ItemServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="item_code" value="<%= code %>">
                    <div class="modal-header">
                      <h5 class="modal-title"><i class="fa-solid fa-pen-to-square me-2"></i>Edit Item</h5>
                      <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                      <div class="mb-3">
                        <label class="form-label">Item Name</label>
                        <input type="text" name="item_name" class="form-control" value="<%= name %>">
                      </div>
                      <div class="mb-3">
                        <label class="form-label">Category</label>
                        <input type="text" name="category" class="form-control" value="<%= cat %>">
                      </div>
                      <div class="mb-3">
                        <label class="form-label">Price (Rs.)</label>
                        <input type="number" name="price" step="0.01" class="form-control" value="<%= price %>">
                      </div>
                      <div class="mb-3">
                        <label class="form-label">Quantity</label>
                        <input type="number" name="quantity" class="form-control" value="<%= qty %>">
                      </div>
                      <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-control" rows="2"><%= desc %></textarea>
                      </div>
                      <div class="mb-3">
                        <label class="form-label">Replace Image (optional)</label>
                        <input type="file" name="image" accept="image/*" class="form-control">
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
            <div class="modal fade" id="deleteModal<%= code %>" tabindex="-1" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                  <form action="ItemServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="item_code" value="<%= code %>">
                    <div class="modal-header bg-danger text-white">
                      <h5 class="modal-title"><i class="fa-solid fa-triangle-exclamation me-2"></i>Confirm Delete</h5>
                      <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                      Are you sure you want to delete the item <strong><%= name %></strong>?
                    </div>
                    <div class="modal-footer">
                      <button type="submit" class="btn btn-danger">Yes, Delete</button>
                      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                  </form>
                </div>
              </div>
            </div>

          <% } %>
          </tbody>
        </table>
      </div>
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
      <div class="modal-body">Are you sure you want to exit the system?</div>
      <div class="modal-footer">
        <a href="logout.jsp" class="btn btn-danger">Yes, Exit</a>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>

<script>
  // Auto-generate item code from name
  function generateCode() {
    const name = document.getElementById("itemName").value.trim();
    const prefix = name.replace(/[^a-zA-Z0-9]/g,"").substring(0,3).toUpperCase() || "ITM";
    const rand = Math.floor(Math.random()*1000).toString().padStart(3,'0');
    document.getElementById("itemCode").value = prefix + rand;
  }
  document.getElementById("itemName").addEventListener("input", generateCode);

  // Filter table (client-side)
  (function(){
    const input = document.getElementById('searchInput');
    const table = document.getElementById('itemTable');
    if(!input || !table) return;
    input.addEventListener('keyup', function(){
      const q = this.value.toLowerCase().trim();
      table.querySelectorAll('tbody tr').forEach(tr=>{
        tr.style.display = tr.innerText.toLowerCase().includes(q) ? '' : 'none';
      });
    });
  })();

 
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

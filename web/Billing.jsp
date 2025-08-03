<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Billing - Pahana Edu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
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
      color: white !important;
      text-decoration: none;
    }
    .content {
      margin-left: 250px;
      padding: 30px;
    }
    .card {
      border-radius: 20px;
      box-shadow: 0 8px 20px rgba(0,0,0,0.1);
      padding: 30px;
      background-color: #fff;
    }
    .autocomplete-items {
      position: absolute;
      z-index: 999;
      width: 100%;
      max-height: 200px;
      overflow-y: auto;
    }
    .autocomplete-items div {
      background-color: #fff;
      padding: 10px;
      cursor: pointer;
      border-bottom: 1px solid #eee;
    }
    .autocomplete-items div:hover {
      background-color: #f1f1f1;
    }
    @media print {
      .no-print { display: none !important; }
    }
    .table th, .table td {
      vertical-align: middle;
    }
    .form-label {
      font-weight: 500;
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
  <div class="container-fluid">
    <div class="card">
      <h2 class="mb-4 no-print text-center text-primary">Create New Bill</h2>
      <form method="post" action="BillingServlet" id="billForm">
        <!-- Customer Autocomplete -->
        <div class="mb-3 position-relative no-print">
          <label class="form-label">Customer (Type name or NIC)</label>
          <input type="text" id="searchCustomerInput" class="form-control" placeholder="Type name or NIC..." autocomplete="off">
          <input type="hidden" id="selectedCustomer" name="nic">
          <input type="hidden" id="selectedAccount" name="account_no">
          <div id="customerDropdown" class="autocomplete-items border rounded shadow-sm bg-white" style="display:none;">
            <%
              try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT nic, account_no, first_name, last_name, telephone FROM users");
                while (rs.next()) {
                  String nic = rs.getString("nic");
                  String name = rs.getString("first_name") + " " + rs.getString("last_name");
                  String tel = rs.getString("telephone");
                  String acc = rs.getString("account_no");
            %>
            <div onclick="selectCustomer('<%=nic%>', '<%=name%>', '<%=tel%>', '<%=acc%>')">
              <%=name%> (<%=nic%>)
            </div>
            <% } con.close(); } catch (Exception e) { out.print("<div>Error loading users</div>"); } %>
          </div>
        </div>

        <!-- Bill Content Area -->
        <div id="billContent">
          <div class="mb-4">
            <strong>Name:</strong> <span id="custName"></span><br>
            <strong>Telephone:</strong> <span id="custTel"></span><br>
            <strong>NIC:</strong> <span id="custNIC"></span><br>
            <strong>Account No:</strong> <span id="custAcc"></span>
          </div>

          <!-- Item Inputs -->
          <div id="itemInputSection" class="row g-3 mb-4 no-print">
            <div class="col-md-4">
              <label class="form-label">Select Item</label>
              <select id="item_code" class="form-select" onchange="fetchPrice()">
                <option value="">-- Select Item --</option>
                <%
                  try {
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery("SELECT item_code, item_name, price FROM items");
                    while (rs.next()) {
                %>
                <option value="<%=rs.getString("item_code")%>" data-price="<%=rs.getDouble("price")%>">
                  <%=rs.getString("item_name")%> (<%=rs.getString("item_code")%>)
                </option>
                <% }} catch (Exception e) { out.print("<option>Error loading items</option>"); } %>
              </select>
            </div>
            <div class="col-md-2">
              <label class="form-label">Price</label>
              <input type="text" id="price" class="form-control" readonly>
            </div>
            <div class="col-md-2">
              <label class="form-label">Quantity</label>
              <input type="number" id="quantity" class="form-control" onchange="calculateTotal()">
            </div>
            <div class="col-md-2">
              <label class="form-label">Total</label>
              <input type="text" id="total" class="form-control" readonly>
            </div>
            <div class="col-md-2 d-flex align-items-end">
              <button type="button" class="btn btn-primary w-100" onclick="addToTable()">Add</button>
            </div>
          </div>

          <!-- Bill Table -->
          <h5 class="text-secondary">Bill Summary</h5>
          <table class="table table-bordered" id="billTable">
            <thead class="table-dark">
              <tr>
                <th>Item Code</th>
                <th>Item Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
              </tr>
            </thead>
            <tbody id="billTableBody"></tbody>
            <tfoot>
              <tr>
                <th colspan="4" class="text-end">Grand Total</th>
                <th id="grandTotal">0.00</th>
              </tr>
            </tfoot>
          </table>
        </div>

        <input type="hidden" name="billImage" id="billImageInput">

        <!-- Action Buttons -->
        <div class="no-print mt-3 d-flex justify-content-end gap-2">
          <button type="button" class="btn btn-success" onclick="submitWithImage()">Save Bill</button>
          <button type="button" class="btn btn-secondary" onclick="printBill()">Print Bill</button>
        </div>
      </form>
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

<script>
  let selectedCustomerInfo = {};

  function fetchPrice() {
    const select = document.getElementById("item_code");
    const price = select.selectedOptions[0].getAttribute("data-price");
    document.getElementById("price").value = price;
    calculateTotal();
  }

  function calculateTotal() {
    const price = parseFloat(document.getElementById("price").value);
    const qty = parseInt(document.getElementById("quantity").value);
    if (!isNaN(price) && !isNaN(qty)) {
      document.getElementById("total").value = (price * qty).toFixed(2);
    }
  }

  function addToTable() {
    const code = document.getElementById("item_code").value;
    const name = document.getElementById("item_code").selectedOptions[0].innerText;
    const price = document.getElementById("price").value;
    const qty = document.getElementById("quantity").value;
    const total = document.getElementById("total").value;

    if (!code || !price || !qty || !total) {
      alert("Please select an item and quantity.");
      return;
    }

    const row = document.getElementById("billTableBody").insertRow();
    row.insertCell(0).innerText = code;
    row.insertCell(1).innerText = name;
    row.insertCell(2).innerText = price;
    row.insertCell(3).innerText = qty;
    row.insertCell(4).innerText = total;

    ["item_code", "price", "quantity", "total"].forEach((field, i) => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = field;
      input.value = [code, price, qty, total][i];
      document.getElementById("billForm").appendChild(input);
    });

    updateGrandTotal();
    document.getElementById("item_code").selectedIndex = 0;
    document.getElementById("price").value = "";
    document.getElementById("quantity").value = "";
    document.getElementById("total").value = "";
  }

  function updateGrandTotal() {
    let sum = 0;
    const rows = document.querySelectorAll("#billTableBody tr");
    rows.forEach(row => sum += parseFloat(row.cells[4].innerText));
    document.getElementById("grandTotal").innerText = sum.toFixed(2);
  }

  function selectCustomer(nic, name, tel, acc) {
    selectedCustomerInfo = { nic, name, tel, acc };
    document.getElementById("selectedCustomer").value = nic;
    document.getElementById("selectedAccount").value = acc;
    document.getElementById("searchCustomerInput").value = name + " (" + nic + ")";
    document.getElementById("custName").innerText = name;
    document.getElementById("custTel").innerText = tel;
    document.getElementById("custNIC").innerText = nic;
    document.getElementById("custAcc").innerText = acc;
    document.getElementById("customerDropdown").style.display = "none";
  }

  document.getElementById("searchCustomerInput").addEventListener("input", function () {
    const input = this.value.toLowerCase();
    const dropdown = document.getElementById("customerDropdown");
    const items = dropdown.getElementsByTagName("div");
    let visible = false;
    for (let i = 0; i < items.length; i++) {
      const text = items[i].innerText.toLowerCase();
      items[i].style.display = text.includes(input) ? "" : "none";
      if (text.includes(input)) visible = true;
    }
    dropdown.style.display = visible ? "block" : "none";
  });

  document.addEventListener("click", function (e) {
    if (!document.getElementById("searchCustomerInput").contains(e.target)) {
      document.getElementById("customerDropdown").style.display = "none";
    }
  });

  function submitWithImage() {
    if (!selectedCustomerInfo.nic || document.getElementById("billTableBody").rows.length === 0) {
      alert("Please select a customer and add at least one item.");
      return;
    }

    const inputSection = document.getElementById("itemInputSection");
    inputSection.style.display = "none";

    setTimeout(() => {
      html2canvas(document.getElementById("billContent")).then(canvas => {
        document.getElementById("billImageInput").value = canvas.toDataURL("image/png");
        inputSection.style.display = "";
        document.getElementById("billForm").submit();
      });
    }, 200);
  }

  function printBill() {
    if (!selectedCustomerInfo.nic || document.getElementById("billTableBody").rows.length === 0) {
      alert("Please select a customer and add items.");
      return;
    }
    window.print();
  }
</script>

</body>
</html>

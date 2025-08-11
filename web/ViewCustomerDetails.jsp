<%@ page import="java.sql.*, java.text.DecimalFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Customer Dashboard - Pahana Edu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Bootstrap + FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
  <style>
    :root {
      --brand: #0097c2;
      --brand2: #0abcf9;
      --soft: #eef4fb;
    }
    body { background: #f6f9fc; font-family: 'Segoe UI', sans-serif; }

    /* Header */
    .header-bar {
      background: linear-gradient(135deg, var(--brand2), var(--brand));
      color: #fff;
      border-radius: 18px;
      padding: 28px;
      box-shadow: 0 10px 30px rgba(9,30,66,.06);
    }
    .avatar {
      width: 64px; height: 64px; border-radius: 50%;
      background: rgba(255,255,255,.2);
      display: flex; align-items: center; justify-content: center;
      font-weight: 700; font-size: 24px;
    }

    /* Cards */
    .card-soft {
      border: 1px solid #e6eef8;
      border-radius: 16px;
      box-shadow: 0 10px 30px rgba(9,30,66,.04);
    }
    .stat {
      background: #fff; border: 1px solid #e9f0f7; border-radius: 14px; padding: 18px;
    }
    .stat .icon {
      width: 42px; height: 42px; border-radius: 10px;
      display: inline-flex; align-items: center; justify-content: center;
      background: var(--soft); color: var(--brand);
    }

    /* Table */
    .table thead th { background: #eef6ff; border-bottom: 0; }
    .table tbody td { vertical-align: middle; }
    .table-responsive { border-radius: 12px; }
    .toolbar {
      gap: .5rem;
    }
    .search-input {
      border-radius: 999px;
      padding-left: 40px;
      background: #fff url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width=\"16\" height=\"16\" fill=\"%239097a1\" class=\"bi bi-search\" viewBox=\"0 0 16 16\"><path d=\"M11 6a5 5 0 1 1-1-3.999A5 5 0 0 1 11 6m-1.5 8a6.5 6.5 0 1 0-1.415-12.9 6.5 6.5 0 0 0 1.415 12.9\"></path><path d=\"M12.9 11.485a1 1 0 0 1 1.415 1.415l-2.829 2.829a1 1 0 0 1-1.415-1.415z\"/></svg>') no-repeat 14px center;
      background-size: 16px;
    }
    .btn-brand {
      background: var(--brand); border-color: var(--brand);
    }
    .btn-brand:hover { background: #077ba1; border-color: #077ba1; }

    @media (max-width: 992px) {
      .header-bar { border-radius: 12px; }
    }
  </style>
</head>
<body class="container py-4 py-md-5">

<%
    String nic = request.getParameter("username"); // username parameter contains NIC
    DecimalFormat LKR = new DecimalFormat("#,##0.00");

    if (nic == null || nic.trim().isEmpty()) {
%>
    <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i>Invalid request. No NIC provided.</div>
<%
    } else {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");

            // Fetch customer details
            PreparedStatement pst = con.prepareStatement("SELECT * FROM users WHERE username = ?");
            pst.setString(1, nic);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
              String accountNo = rs.getString("account_no");
              String first = rs.getString("first_name");
              String last  = rs.getString("last_name");
              String address = rs.getString("address");
              String tel = rs.getString("telephone");
              String createdAt = rs.getString("created_at");
              String initials = (first != null && !first.isEmpty() ? (""+first.charAt(0)).toUpperCase() : "U")
                                + (last != null && !last.isEmpty() ? (""+last.charAt(0)).toUpperCase() : "");
%>

  <!-- Header -->
  <div class="header-bar mb-4">
    <div class="d-flex align-items-center">
      <div class="avatar me-3"><%= initials %></div>
      <div class="flex-grow-1">
        <h3 class="mb-1">Customer Dashboard</h3>
        <div class="small opacity-75">Welcome, <strong><%= first %> <%= last %></strong> • Account <strong><%= accountNo %></strong></div>
      </div>
      <a href="UserBills.jsp" class="btn btn-light btn-sm ms-auto">
        <i class="fa-solid fa-receipt me-1"></i> View Bill Images
      </a>
    </div>
  </div>

  <!-- Customer Info + Stats -->
  <div class="row g-3 g-md-4 mb-4">
    <div class="col-lg-7">
      <div class="card card-soft">
        <div class="card-header bg-white fw-semibold"><i class="fa-regular fa-id-card me-2"></i>Customer Information</div>
        <div class="card-body row">
          <div class="col-md-6">
            <p class="mb-2"><span class="text-muted">Account No:</span> <br><strong><%= accountNo %></strong></p>
            <p class="mb-2"><span class="text-muted">Name:</span> <br><strong><%= first %> <%= last %></strong></p>
            <p class="mb-0"><span class="text-muted">Address:</span> <br><%= address %></p>
          </div>
          <div class="col-md-6">
            <p class="mb-2"><span class="text-muted">NIC (Username):</span> <br><strong><%= rs.getString("username") %></strong></p>
            <p class="mb-2"><span class="text-muted">Telephone:</span> <br><%= tel %></p>
            <p class="mb-0"><span class="text-muted">Created At:</span> <br><%= createdAt %></p>
          </div>
        </div>
      </div>
    </div>
<%
            rs.close();
            pst.close();

            // Fetch billing history
            PreparedStatement billStmt = con.prepareStatement("SELECT * FROM bills WHERE nic = ? ORDER BY created_at DESC");
            billStmt.setString(1, nic);
            ResultSet bills = billStmt.executeQuery();

            // Compute basic stats while we iterate later
            double totalSpend = 0.0;
            int billCount = 0;
            String lastPurchase = "-";

            // We'll cache rows in memory to render later while computing stats.
            java.util.List<java.util.Map<String, String>> rows = new java.util.ArrayList<>();
            while (bills.next()) {
              billCount++;
              double t = bills.getDouble("total");
              totalSpend += t;
              if (billCount == 1) {
                lastPurchase = bills.getString("created_at");
              }
              java.util.Map<String, String> row = new java.util.HashMap<>();
              row.put("bill_id", String.valueOf(bills.getInt("bill_id")));
              row.put("item_code", bills.getString("item_code"));
              row.put("price", LKR.format(bills.getDouble("price")));
              row.put("qty", String.valueOf(bills.getInt("quantity")));
              row.put("total", LKR.format(t));
              row.put("created", bills.getString("created_at"));
              rows.add(row);
            }
            bills.close();
            billStmt.close();
%>
    <div class="col-lg-5">
      <div class="row g-3 g-md-4">
        <div class="col-12">
          <div class="stat d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted small">Total Spend</div>
              <div class="fs-4 fw-bold">Rs. <%= LKR.format(totalSpend) %></div>
            </div>
            <div class="icon"><i class="fa-solid fa-sack-dollar"></i></div>
          </div>
        </div>
        <div class="col-6">
          <div class="stat d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted small">Bills</div>
              <div class="fs-5 fw-bold"><%= billCount %></div>
            </div>
            <div class="icon"><i class="fa-regular fa-file-lines"></i></div>
          </div>
        </div>
        <div class="col-6">
          <div class="stat d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted small">Last Purchase</div>
              <div class="fw-semibold"><%= lastPurchase %></div>
            </div>
            <div class="icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Billing History -->
  <div class="card card-soft">
    <div class="card-header bg-white d-flex flex-wrap align-items-center justify-content-between">
      <div class="fw-semibold"><i class="fa-solid fa-file-invoice me-2"></i>Billing History</div>
      <div class="toolbar d-flex">
        <input id="searchInput" class="form-control form-control-sm search-input" placeholder="Search bills…">
        <button id="btnCsv" class="btn btn-sm btn-outline-secondary">
          <i class="fa-solid fa-download me-1"></i> CSV
        </button>
      </div>
    </div>
    <div class="card-body p-0">
      <div class="table-responsive">
        <table id="billTable" class="table table-striped table-hover m-0">
          <thead class="sticky-top">
            <tr>
              <th>Bill ID</th>
              <th>Item Code</th>
              <th class="text-end">Price (Rs.)</th>
              <th class="text-end">Qty</th>
              <th class="text-end">Total (Rs.)</th>
              <th>Date</th>
            </tr>
          </thead>
          <tbody>
          <%
            if (rows.isEmpty()) {
          %>
            <tr>
              <td colspan="6" class="text-center text-muted py-4">No billing history available.</td>
            </tr>
          <%
            } else {
              for (java.util.Map<String,String> r : rows) {
          %>
            <tr>
              <td><%= r.get("bill_id") %></td>
              <td><span class="badge bg-light text-dark border"><%= r.get("item_code") %></span></td>
              <td class="text-end"><%= r.get("price") %></td>
              <td class="text-end"><%= r.get("qty") %></td>
              <td class="text-end fw-semibold"><%= r.get("total") %></td>
              <td><%= r.get("created") %></td>
            </tr>
          <%
              }
            }
            // close connection:
            con.close();
          %>
          </tbody>
        </table>
      </div>
    </div>
  </div>

<%
            } else {
%>
    <div class="alert alert-warning mt-4"><i class="fa-regular fa-circle-xmark me-2"></i>No customer found with NIC: <strong><%= nic %></strong></div>
<%
            }
        } catch (Exception e) {
%>
    <div class="alert alert-danger mt-4"><i class="fa-solid fa-bug me-2"></i>Error: <%= e.getMessage() %></div>
<%
        }
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Simple client-side filter for the billing table
  (function() {
    const input = document.getElementById('searchInput');
    const table = document.getElementById('billTable');
    if (!input || !table) return;

    input.addEventListener('keyup', function() {
      const q = this.value.toLowerCase().trim();
      const rows = table.querySelectorAll('tbody tr');
      rows.forEach(tr => {
        const txt = tr.innerText.toLowerCase();
        tr.style.display = txt.includes(q) ? '' : 'none';
      });
    });
  })();

  // Download table as CSV
  (function() {
    const btn = document.getElementById('btnCsv');
    const table = document.getElementById('billTable');
    if (!btn || !table) return;

    btn.addEventListener('click', function() {
      const rows = [...table.querySelectorAll('tr')].map(tr =>
        [...tr.children].map(td => {
          const text = td.innerText.replace(/\s+/g, ' ').trim().replaceAll('"','""');
          return `"${text}"`;
        }).join(',')
      );
      const csv = rows.join('\n');
      const blob = new Blob([csv], {type: 'text/csv;charset=utf-8;'});
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'billing_history.csv';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    });
  })();
</script>
</body>
</html>

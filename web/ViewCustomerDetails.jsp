<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Customer Dashboard - Pahana Edu</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f2f7fc;
      font-family: 'Segoe UI', sans-serif;
    }
    .card-header {
      background-color: #0d6efd;
      color: white;
      font-weight: bold;
    }
    .section-title {
      text-align: center;
      color: #0d6efd;
      font-weight: bold;
      margin-bottom: 30px;
    }
    .table th {
      background-color: #e8f1ff;
    }
  </style>
</head>
<body class="container py-5">

<%
    String nic = request.getParameter("username"); // username parameter contains NIC
    if (nic == null || nic.trim().isEmpty()) {
%>
    <div class="alert alert-danger">Invalid request. No NIC provided.</div>
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
%>
    <h2 class="section-title">Customer Dashboard</h2>

    <!-- Customer Info -->
    <div class="card mb-4 shadow">
        <div class="card-header">Customer Information</div>
        <div class="card-body row">
            <div class="col-md-6">
                <p><strong>Account No:</strong> <%= rs.getString("account_no") %></p>
                <p><strong>Name:</strong> <%= rs.getString("first_name") %> <%= rs.getString("last_name") %></p>
                <p><strong>Address:</strong> <%= rs.getString("address") %></p>
            </div>
            <div class="col-md-6">
                <p><strong>NIC (Username):</strong> <%= rs.getString("username") %></p>
                <p><strong>Telephone:</strong> <%= rs.getString("telephone") %></p>
                <p><strong>Created At:</strong> <%= rs.getString("created_at") %></p>
            </div>
        </div>
    </div>

<%
            rs.close();
            pst.close();

            // Fetch billing history
            PreparedStatement billStmt = con.prepareStatement("SELECT * FROM bills WHERE nic = ?");
            billStmt.setString(1, nic);
            ResultSet bills = billStmt.executeQuery();
%>

    <!-- Billing History -->
    <div class="card shadow">
        <div class="card-header bg-success text-white">Billing History</div>
        <div class="card-body p-0">
            <table class="table table-striped m-0">
                <thead>
                    <tr>
                        <th>Bill ID</th>
                        <th>Item Code</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasBills = false;
                    while (bills.next()) {
                        hasBills = true;
                %>
                    <tr>
                        <td><%= bills.getInt("bill_id") %></td>
                        <td><%= bills.getString("item_code") %></td>
                        <td>Rs. <%= bills.getDouble("price") %></td>
                        <td><%= bills.getInt("quantity") %></td>
                        <td><strong>Rs. <%= bills.getDouble("total") %></strong></td>
                        <td><%= bills.getString("created_at") %></td>
                    </tr>
                <%
                    }
                    if (!hasBills) {
                %>
                    <tr>
                        <td colspan="6" class="text-center text-muted">No billing history available.</td>
                    </tr>
                <%
                    }
                    bills.close();
                    billStmt.close();
                    con.close();
                %>
                </tbody>
            </table>
        </div>
    </div>
<%
            } else {
%>
    <div class="alert alert-warning mt-4">No customer found with NIC: <%= nic %></div>
<%
            }
        } catch (Exception e) {
%>
    <div class="alert alert-danger mt-4">Error: <%= e.getMessage() %></div>
<%
        }
    }
%>

</body>
</html>

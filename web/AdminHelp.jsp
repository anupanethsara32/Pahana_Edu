<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Help - Pahana Edu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

  <style>
    body {
      background: linear-gradient(to right, #e0eafc, #cfdef3);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
      padding: 50px 30px;
    }

    .help-container {
      max-width: 1000px;
      margin: auto;
      padding: 50px;
      background-color: #fff;
      border-radius: 20px;
      box-shadow: 0 0 30px rgba(0,0,0,0.08);
    }

    h2 {
      color: #0097c2;
      font-weight: bold;
      margin-bottom: 30px;
    }

    .section-title {
      color: #0abcf9;
      font-weight: bold;
      margin-top: 25px;
    }

    p {
      font-size: 16px;
      line-height: 1.7;
    }

    .back-link {
      margin-top: 40px;
      display: inline-block;
      text-decoration: none;
      font-weight: bold;
      color: #0097c2;
    }

    .back-link:hover {
      color: #0abcf9;
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

<!-- Main Help Content -->
<div class="content">
  <div class="help-container">
    <h2><i class="fas fa-user-shield me-2"></i>Admin Help Guide</h2>

    <h5 class="section-title">1. Manage Customers</h5>
    <p>Admins can view, add, edit, or delete customer accounts. NIC acts as the unique identifier.</p>

    <h5 class="section-title">2. Manage Items</h5>
    <p>Add items with code, name, price, and image. All items are stored in the system and displayed in billing and selling pages.</p>

    <h5 class="section-title">3. Generate Bills</h5>
    <p>Navigate to Billing > Select a customer > Add items > Save bill. Bills are stored with screenshots and linked to customers.</p>

    <h5 class="section-title">4. View Messages</h5>
    <p>Messages submitted by users from the contact form are visible in the AdminMessages.jsp page.</p>

    <h5 class="section-title">5. View Bill History</h5>
    <p>All previously saved bills can be viewed and managed via Billing History.</p>

    <a href="AdminDashboard.jsp" class="back-link"><i class="fas fa-arrow-left me-2"></i>Back to Admin Dashboard</a>
  </div>
</div>

<!-- Logout Confirmation Modal -->
<div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-danger">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title" id="logoutModalLabel">Confirm Exit</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
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

<!-- Bootstrap JS for modal functionality -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

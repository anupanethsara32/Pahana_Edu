<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Pahana Edu - Create Account</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

  <style>
    body {
      background: linear-gradient(to right, #e0eafc, #cfdef3);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      padding: 0;
    }
    .main-container {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 30px;
      position: relative;
    }
    .card-container {
      width: 100%;
      max-width: 1250px;
      display: flex;
      border-radius: 20px;
      overflow: hidden;
      box-shadow: 0 0 30px rgba(0, 0, 0, 0.1);
    }
    .left-panel {
      flex: 1;
      background: linear-gradient(135deg, #0abcf9, #0097c2);
      color: white;
      padding: 70px 60px;
      display: flex;
      flex-direction: column;
      justify-content: center;
      text-align: center;
    }
    .left-panel h3 {
      font-size: 32px;
      font-weight: bold;
    }
    .left-panel p {
      font-size: 16px;
      margin: 10px 0 30px;
    }
    .left-panel .btn-outline-light {
      border-radius: 30px;
      font-size: 16px;
      padding: 10px 30px;
    }
    .left-panel .btn-outline-light:hover {
      background-color: #ffffff;
      color: #0097c2;
    }
    .right-panel {
      flex: 1;
      background-color: #fff;
      padding: 60px;
    }
    .form-control {
      padding: 14px;
      font-size: 16px;
      border-radius: 10px;
      margin-bottom: 20px;
    }
    .btn-info-custom {
      background-color: #00b7e2;
      border: none;
      font-size: 18px;
      font-weight: 600;
      border-radius: 30px;
      padding: 12px;
      width: 100%;
      color: #ffffff;
    }
    .btn-info-custom:hover {
      background-color: #009ec5;
    }
    .footer {
      font-size: 14px;
      text-align: center;
      margin-top: 40px;
    }
    @media (max-width: 992px) {
      .card-container { flex-direction: column; }
      .left-panel { padding: 40px; }
    }
  </style>
</head>
<body>

<%
  String nextAccountNo = "PAH-10001";
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT MAX(CAST(SUBSTRING(account_no, 5) AS UNSIGNED)) AS max_acc FROM users");
    if (rs.next()) {
      int max = rs.getInt("max_acc");
      nextAccountNo = "PAH-" + (max + 1);
    }
    rs.close();
    stmt.close();
    con.close();
  } catch (Exception e) {
    nextAccountNo = "ERR";
  }
%>

<%
  String message = request.getParameter("message");
  if ("success".equals(message)) {
%>
  <div class="position-fixed w-100 h-100 d-flex align-items-center justify-content-center bg-dark bg-opacity-50" style="z-index:999;">
    <div class="bg-white p-5 rounded text-center">
      <div class="fs-1 text-success mb-3"><i class="fas fa-check-circle"></i></div>
      <h3>Registration Successful!</h3>
      <p>You will be redirected to login shortly...</p>
    </div>
  </div>
  <script>
    setTimeout(() => { window.location.href = "Index.jsp"; }, 3000);
  </script>
<% } %>

<div class="main-container">
  <div class="card-container">

    <!-- Left Side -->
    <div class="left-panel">
      <h3>Join Us Today!</h3>
      <p>Start your journey with Pahana Edu by creating an account.</p>
      <p>Already have an account?</p>
      <a href="Index.jsp" class="btn btn-outline-light">SIGN IN</a>
    </div>

    <!-- Right Side -->
    <div class="right-panel">
      <h3 class="mb-4">Create Account <strong>Pahana Edu</strong></h3>

      <% String regMessage = (String) request.getAttribute("message");
         if (regMessage != null && !"success".equals(message)) { %>
        <div class="alert alert-warning"><%= regMessage %></div>
      <% } %>

      <form action="RegisterServlet" method="post">
        <input type="text" class="form-control" name="accountNo" placeholder="Account Number" value="<%= nextAccountNo %>" readonly>

        <div class="row">
          <div class="col-md-6">
            <input type="text" class="form-control" name="firstName" placeholder="First Name" required>
          </div>
          <div class="col-md-6">
            <input type="text" class="form-control" name="lastName" placeholder="Last Name" required>
          </div>
        </div>

        <div class="row">
          <div class="col-md-6">
            <input type="text" class="form-control" name="nic" placeholder="NIC Number (used as username)" required>
            <small class="form-text text-muted ms-2">Your NIC will be your username.</small>
          </div>
          <div class="col-md-6">
            <input type="text" class="form-control" name="telephone" placeholder="Telephone" required>
          </div>
        </div>

        <input type="text" class="form-control" name="address" placeholder="Home Address" required>

        <div class="row">
          <div class="col-md-6">
            <input type="password" class="form-control" name="password" placeholder="Password" required>
          </div>
          <div class="col-md-6">
            <input type="password" class="form-control" name="confirmPassword" placeholder="Confirm Password" required>
          </div>
        </div>

        <button type="submit" class="btn btn-info-custom mt-3">SIGN UP</button>
      </form>

      <div class="footer mt-4">
        &copy; 2025 Pahana Edu | support@pahanaedu.com
      </div>
    </div>
  </div>
</div>
</body>
</html>

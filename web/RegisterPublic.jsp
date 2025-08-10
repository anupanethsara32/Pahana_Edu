<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // compute next account no (for display only; servlet will still generate)
  String nextAccountNo = "PAH-10001";
  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db","root","")) {
      try (Statement st = con.createStatement();
           ResultSet rs = st.executeQuery("SELECT COALESCE(MAX(CAST(SUBSTRING(account_no,5) AS UNSIGNED)),10000) AS max_acc FROM users")) {
        if (rs.next()) nextAccountNo = "PAH-" + (rs.getInt("max_acc")+1);
      }
    }
  } catch (Exception e) { /* keep default */ }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Pahana Edu - Create Account</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
  <style>
    body{background:linear-gradient(to right,#e0eafc,#cfdef3);font-family:'Segoe UI',Tahoma,Verdana,sans-serif}
    .main{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:30px}
    .wrap{width:100%;max-width:1250px;display:flex;border-radius:20px;overflow:hidden;box-shadow:0 0 30px rgba(0,0,0,.1)}
    .left{flex:1;background:linear-gradient(135deg,#0abcf9,#0097c2);color:#fff;padding:70px 60px;display:flex;flex-direction:column;justify-content:center;text-align:center}
    .right{flex:1;background:#fff;padding:60px}
    .form-control{padding:14px;font-size:16px;border-radius:10px;margin-bottom:20px}
    .btn-primary{background:#00b7e2;border:none;border-radius:30px;padding:12px;font-weight:600}
    .btn-primary:hover{background:#009ec5}
    @media (max-width:992px){.wrap{flex-direction:column}.left{padding:40px}}
  </style>
</head>
<body>

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
  <script>setTimeout(()=>{location.href='Index.jsp'},1800);</script>
<% } %>

<div class="main">
  <div class="wrap">
    <div class="left">
      <h3>Join Us Today!</h3>
      <p>Start your journey with Pahana Edu by creating an account.</p>
      <p>Already have an account?</p>
      <a href="Index.jsp" class="btn btn-outline-light rounded-pill px-4">SIGN IN</a>
    </div>

    <div class="right">
      <h3 class="mb-4">Create Account <strong>Pahana Edu</strong></h3>

      <% String regMsg = (String) request.getAttribute("message");
         if (regMsg != null && !"success".equals(message)) { %>
        <div class="alert alert-warning"><%= regMsg %></div>
      <% } %>

      <form action="RegisterServlet" method="post" autocomplete="off">
        <input type="hidden" name="adminMode" value="0"/>

        <label class="form-label">Account Number</label>
        <input type="text" class="form-control" name="accountNo_display" value="<%= nextAccountNo %>" readonly>

        <div class="row">
          <div class="col-md-6"><input type="text" class="form-control" name="firstName" placeholder="First Name" required></div>
          <div class="col-md-6"><input type="text" class="form-control" name="lastName" placeholder="Last Name" required></div>
        </div>

        <div class="row">
          <div class="col-md-6">
            <input type="text" class="form-control" name="nic" placeholder="NIC Number (username)" required>
            <small class="text-muted ms-2">Your NIC will be your username.</small>
          </div>
          <div class="col-md-6"><input type="text" class="form-control" name="telephone" placeholder="Telephone" required></div>
        </div>

        <input type="text" class="form-control" name="address" placeholder="Home Address" required>

        <div class="row">
          <div class="col-md-6"><input type="password" class="form-control" name="password" placeholder="Password" required></div>
          <div class="col-md-6"><input type="password" class="form-control" name="confirmPassword" placeholder="Confirm Password" required></div>
        </div>

        <button class="btn btn-primary w-100 mt-2">SIGN UP</button>
      </form>

      <div class="text-center mt-4">&copy; 2025 Pahana Edu | support@pahanaedu.com</div>
    </div>
  </div>
</div>
</body>
</html>

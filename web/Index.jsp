<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loginSuccess = (String) session.getAttribute("loginSuccess");
    if ("true".equals(loginSuccess)) {
        session.removeAttribute("loginSuccess");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Pahana Edu - Login</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
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
    }

    .login-card {
      width: 100%;
      max-width: 1250px;
      display: flex;
      border-radius: 20px;
      overflow: hidden;
      box-shadow: 0 0 30px rgba(0, 0, 0, 0.1);
    }

    .left-panel {
      flex: 1;
      background-color: #fff;
      padding: 60px;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .left-panel h2 {
      font-size: 36px;
      font-weight: 700;
      margin-bottom: 30px;
    }

    .form-control {
      padding: 16px;
      font-size: 16px;
      border-radius: 10px;
    }

    .form-icon {
      position: absolute;
      right: 15px;
      top: 14px;
      color: #aaa;
    }

    .input-group {
      position: relative;
    }

    .right-panel {
      flex: 1;
      background: linear-gradient(135deg, #0abcf9, #0097c2);
      color: white;
      padding: 70px 60px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      border-top-right-radius: 50% 50%;
    }

    .top-nav {
      display: flex;
      justify-content: center;
      gap: 30px;
      flex-wrap: wrap;
      margin-bottom: 40px;
    }

    .top-nav a {
      color: #ffffff;
      font-size: 16px;
      text-decoration: none;
      font-weight: 500;
    }

    .top-nav a:hover {
      text-decoration: underline;
    }

    .right-panel h3 {
      font-size: 32px;
      font-weight: bold;
    }

    .right-panel p {
      font-size: 16px;
    }

    .right-panel .btn-outline-light {
      border-radius: 30px;
      font-size: 16px;
      padding: 10px 30px;
      transition: all 0.3s ease;
    }

    .right-panel .btn-outline-light:hover {
      background-color: #ffffff;
      color: #0097c2;
    }

    .footer {
      font-size: 14px;
      text-align: center;
      margin-top: 50px;
    }

    .btn-info-custom {
      background-color: #00b7e2;
      border: none;
      font-size: 18px;
      font-weight: 600;
      border-radius: 30px;
      padding: 12px;
    }

    .btn-info-custom:hover {
      background-color: #009ec5;
    }

    @media (max-width: 992px) {
      .login-card {
        flex-direction: column;
      }

      .right-panel {
        border-top-left-radius: 0;
        padding: 40px;
        text-align: center;
      }

      .top-nav {
        justify-content: center;
        margin-bottom: 30px;
      }
    }

    /* Overlay and Modal Box */
    .overlay {
      position: fixed;
      top: 0; left: 0;
      width: 100vw;
      height: 100vh;
      background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent */
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 9999;
    }

    .success-box {
      background-color: #fff;
      padding: 40px 30px;
      text-align: center;
      border-radius: 16px;
      box-shadow: 0 0 20px rgba(0,0,0,0.2);
    }

    .success-box i {
      font-size: 40px;
      color: green;
    }

    .success-box h4 {
      margin-top: 20px;
      font-weight: 600;
      font-size: 24px;
      color: #333;
    }

    .success-box p {
      font-size: 14px;
      color: #666;
    }
  </style>
</head>
<body>

<% if ("true".equals(loginSuccess)) { %>
  <div class="overlay" id="loginSuccessOverlay">
    <div class="success-box">
      <i class="fas fa-check-circle"></i>
      <h4>Login Success!</h4>
      <p>You will be redirected shortly...</p>
    </div>
  </div>
  <script>
    setTimeout(() => {
      window.location.href = "UserDashboard.jsp";
    }, 2000);
  </script>
<% } %>

<div class="main-container">
  <div class="login-card">

    <!-- Left Panel -->
    <div class="left-panel">
      <h2>Welcome to <strong>Pahana Edu</strong></h2>

      <!-- Optional Error Message -->
      <%
        String error = (String) request.getAttribute("errorMessage");
        if (error != null) {
      %>
          <div class="alert alert-danger"><%= error %></div>
      <%
        }
      %>

      <form action="LoginServlet" method="post">
        <div class="mb-4 input-group">
          <input type="text" class="form-control" name="username" placeholder="Username" required />
          <i class="fa fa-envelope form-icon"></i>
        </div>
        <div class="mb-4 input-group">
          <input type="password" class="form-control" name="password" placeholder="Password" required />
          <i class="fa fa-lock form-icon"></i>
        </div>
        <div class="form-check mb-4">
          <input type="checkbox" class="form-check-input" id="remember" />
          <label class="form-check-label" for="remember">Remember me</label>
        </div>
        <div class="d-grid">
          <button type="submit" class="btn btn-info-custom text-white">LOGIN</button>
        </div>
      </form>
    </div>

    <!-- Right Panel -->
    <div class="right-panel">
      <div class="top-nav">
        <a href="Index.jsp">Home</a>
        <a href="AboutUs.jsp">About</a>
        <a href="SellItems.jsp">Items</a>
        <a href="ContactUs.jsp">Contact Us</a>
        <a href="UserHelp.jsp">Help</a>
      </div>
      <div class="text-center my-auto">
        <h3>Welcome Back!</h3>
        <p>To keep connected with us, please login<br>using your email and password.</p>
        <p class="mt-4 mb-1">Don't have an account?</p>
        <a href="Register.jsp" class="btn btn-outline-light">SIGN UP</a>
      </div>
      <div class="footer">
        &copy; 2025 Pahana Edu | support@pahanaedu.com
      </div>
    </div>

  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

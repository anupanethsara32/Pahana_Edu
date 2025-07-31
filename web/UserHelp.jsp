<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>User Help - Pahana Edu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

  <style>
    body {
      background: linear-gradient(to right, #e0eafc, #cfdef3);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      padding: 0;
    }

    .main-container {
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      padding: 40px 20px;
    }

    .help-card {
      background-color: #ffffff;
      border-radius: 25px;
      box-shadow: 0 0 30px rgba(0, 0, 0, 0.08);
      padding: 50px 40px;
      max-width: 850px;
      width: 100%;
    }

    h2 {
      font-size: 32px;
      font-weight: bold;
      color: #00BFFF;
      margin-bottom: 30px;
      display: flex;
      align-items: center;
    }

    h2 i {
      margin-right: 12px;
    }

    .section-title {
      color: #00BFFF;
      font-size: 18px;
      font-weight: 600;
      margin-top: 25px;
    }

    p {
      font-size: 16px;
      line-height: 1.7;
      color: #333;
    }

    .btn-back {
      margin-top: 40px;
      background-color: #00BFFF;
      color: white;
      font-weight: bold;
      border-radius: 25px;
      padding: 10px 25px;
      text-decoration: none;
      display: inline-block;
      transition: background 0.3s ease;
    }

    .btn-back:hover {
      background-color: #009adf;
      color: white;
    }

    @media (max-width: 768px) {
      .help-card {
        padding: 35px 25px;
      }
    }
  </style>
</head>

<body>
  <div class="main-container">
    <div class="help-card">
      <h2><i class="fas fa-question-circle"></i>User Help Guide</h2>

      <h5 class="section-title">1. Logging In</h5>
      <p>Use your NIC and password to log in and access your account dashboard securely.</p>

      <h5 class="section-title">2. Viewing Your Profile</h5>
      <p>Your dashboard displays Account No, Full Name, NIC, Phone, and Address after login.</p>

      <h5 class="section-title">3. Updating Your Password</h5>
      <p>Click “Update Password”, enter your new password, and click submit to update your credentials.</p>

      <h5 class="section-title">4. Bill History Access</h5>
      <p>See your billing records in the “Bill History” section. Use the “View Bills” button for full details.</p>

      <h5 class="section-title">5. Contact for Support</h5>
      <p>If you need assistance, visit the “Contact Us” page and send a message. We'll respond soon.</p>

      <a href="Index.jsp" class="btn-back"><i class="fas fa-arrow-left me-2"></i>Back to Home</a>
    </div>
  </div>
</body>
</html>

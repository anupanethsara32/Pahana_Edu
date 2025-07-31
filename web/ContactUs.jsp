<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Contact Us - Pahana Edu</title>
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

    .contact-card {
      width: 100%;
      max-width: 1250px;
      display: flex;
      border-radius: 20px;
      overflow: hidden;
      box-shadow: 0 0 30px rgba(0, 0, 0, 0.1);
      background-color: #fff;
    }

    .left-panel {
      flex: 1;
      padding: 60px;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .left-panel h2 {
      font-size: 36px;
      font-weight: 700;
      margin-bottom: 30px;
      color: #0097c2;
    }

    .form-label {
      font-weight: 600;
    }

    .form-control, textarea {
      border-radius: 12px;
      font-size: 16px;
    }

    .btn-submit {
      background-color: #0097c2;
      color: white;
      font-weight: 600;
      padding: 10px 25px;
      border-radius: 30px;
      transition: background 0.3s ease;
    }

    .btn-submit:hover {
      background-color: #0abcf9;
    }

    .right-panel {
      flex: 1;
      background: linear-gradient(135deg, #0abcf9, #0097c2);
      color: white;
      padding: 60px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      border-top-left-radius: 20% 20%;
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

    .top-nav a:hover,
    .top-nav a.active {
      text-decoration: underline;
    }

    .footer {
      font-size: 14px;
      text-align: center;
      margin-top: 50px;
      color: #f0f0f0;
    }

    @media (max-width: 992px) {
      .contact-card {
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
  </style>
</head>
<body>

<div class="main-container">
  <div class="contact-card">

    <!-- Left Panel -->
    <div class="left-panel">
      <h2><i class="fas fa-envelope me-2"></i>Contact Us</h2>
      <p class="text-muted mb-4">We’d love to hear from you. Please fill out the form below:</p>

      <form action="ContactServlet" method="post">
        <div class="row g-4">
          <div class="col-md-6">
            <label class="form-label">Full Name</label>
            <input type="text" name="name" class="form-control" required>
          </div>

          <div class="col-md-6">
            <label class="form-label">Email Address</label>
            <input type="email" name="email" class="form-control" required>
          </div>

          <div class="col-md-6">
            <label class="form-label">Phone Number</label>
            <input type="text" name="phone" class="form-control">
          </div>

          <div class="col-md-6">
            <label class="form-label">Subject</label>
            <input type="text" name="subject" class="form-control" required>
          </div>

          <div class="col-12">
            <label class="form-label">Message</label>
            <textarea name="message" rows="5" class="form-control" required></textarea>
          </div>

          <div class="col-12 text-center mt-3">
            <button type="submit" class="btn btn-submit">
              <i class="fas fa-paper-plane me-2"></i>Send Message
            </button>
          </div>
        </div>
      </form>
    </div>

    <!-- Right Panel -->
    <div class="right-panel">
      <div class="top-nav">
        <a href="Index.jsp">Home</a>
        <a href="AboutUs.jsp">About</a>
        <a href="SellItems.jsp">Items</a>
        <a href="ContactUs.jsp" class="active">Contact Us</a>
        <a href="UserHelp.jsp">Help</a>
      </div>

      <div class="footer">
        &copy; 2025 Pahana Edu | contact@pahanaedu.com
      </div>
    </div>

  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

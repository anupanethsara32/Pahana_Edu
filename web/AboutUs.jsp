<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>About Us - Pahana Edu</title>
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

    .about-card {
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

    .about-text {
      font-size: 18px;
      line-height: 1.8;
      color: #333;
    }

    .highlight {
      color: #0abcf9;
      font-weight: bold;
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

    .top-nav a:hover {
      text-decoration: underline;
    }

    .footer {
      font-size: 14px;
      text-align: center;
      margin-top: 50px;
      color: #f0f0f0;
    }

    @media (max-width: 992px) {
      .about-card {
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
  <div class="about-card">

    <!-- Left Panel -->
    <div class="left-panel">
      <h2><i class="fas fa-book-open me-2"></i>About Pahana Edu</h2>
      <div class="about-text">
        <p><span class="highlight">Pahana Edu</span> is a leading bookshop located in the heart of Colombo City, serving <strong>hundreds of loyal customers every month</strong>. As a trusted educational resource hub, we offer a wide variety of textbooks, stationery, and academic supplies tailored for students, teachers, and institutions.</p>

        <p>To improve customer satisfaction and operational efficiency, we are transitioning from manual record keeping to a <span class="highlight">web-based billing and customer management system</span>. This digital platform allows streamlined tracking of all customer interactions and purchases.</p>

        <p>Each customer is assigned a <strong>unique Account Number</strong>, and new customers can easily register through the system by providing details such as name, address, telephone number, and number of units consumed. This helps our staff to manage and process billing efficiently.</p>
      </div>
    </div>

    <!-- Right Panel (Navigation) -->
    <div class="right-panel">
      <div class="top-nav">
        <a href="Index.jsp">Home</a>
        <a href="AboutUs.jsp">About</a>
        <a href="SellItems.jsp">Items</a>
        <a href="ContactUs.jsp">Contact Us</a>
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

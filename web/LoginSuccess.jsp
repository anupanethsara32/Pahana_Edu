<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Registration Success</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Font Awesome -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

  <style>
    body {
      margin: 0;
      padding: 0;
      height: 100vh;
      background: linear-gradient(to right, #e0eafc, #cfdef3);
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .success-box {
      background: rgba(255, 255, 255, 0.95);
      padding: 50px 60px;
      border-radius: 20px;
      text-align: center;
      box-shadow: 0 0 30px rgba(0, 0, 0, 0.15);
      animation: fadeIn 0.4s ease;
    }

    .icon {
      font-size: 60px;
      color: #28a745;
      margin-bottom: 20px;
    }

    h3 {
      font-weight: bold;
      margin-bottom: 10px;
    }

    p {
      color: #444;
      font-size: 16px;
    }

    @keyframes fadeIn {
      from { transform: scale(0.9); opacity: 0; }
      to { transform: scale(1); opacity: 1; }
    }
  </style>
</head>
<body>

<div class="success-box">
  <div class="icon"><i class="fas fa-check-circle"></i></div>
  <h3>Registration Successful!</h3>
  <p>You will be redirected to login shortly...</p>
</div>

<script>
  setTimeout(() => {
    window.location.href = "Index.jsp";
  }, 3000);
</script>

</body>
</html>

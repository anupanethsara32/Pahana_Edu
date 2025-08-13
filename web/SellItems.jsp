<%@ page import="java.sql.*, java.util.Base64" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Sell Items - Pahana Edu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
  <style>
    body { background: linear-gradient(to right, #e0eafc, #cfdef3); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin:0; padding:0; }
    .nav-curve { background: linear-gradient(135deg, #0abcf9, #0097c2); height:150px; border-bottom-left-radius:50% 100px; border-bottom-right-radius:50% 100px; }
    .navbar-links { position:absolute; top:30px; left:50%; transform:translateX(-50%); display:flex; gap:30px; }
    .navbar-links a { color:#fff; font-weight:600; font-size:16px; text-decoration:none; }
    .navbar-links a:hover { text-decoration:underline; }
    .page-wrapper { max-width:1200px; margin:-50px auto 60px; padding:50px 30px; background:#fff; border-radius:30px; box-shadow:0 10px 30px rgba(0,0,0,.1); }
    .section-title { font-size:22px; font-weight:600; text-align:center; color:#0097c2; margin-bottom:30px; }
    .item-card { background:#f9f9f9; border-radius:20px; padding:20px; box-shadow:0 4px 10px rgba(0,0,0,.05); text-align:center; transition:.3s ease; height:100%; }
    .item-card:hover { transform: translateY(-5px); }
    .item-card img { height:150px; object-fit:contain; margin-bottom:15px; border-radius:10px; }
    .item-name { font-weight:600; color:#0097c2; margin-bottom:5px; }
    .item-price { font-weight:bold; color:#333; margin-bottom:5px; }
    .item-desc { font-size:13px; color:#666; }
    @media (max-width:768px){ .navbar-links{flex-direction:column; align-items:center; top:20px;} }
  </style>
</head>
<body>

<div class="nav-curve"></div>
<div class="navbar-links">
  <a href="Index.jsp">Home</a>
  <a href="AboutUs.jsp">About</a>
  <a href="SellItems.jsp">Items</a>
  <a href="ContactUs.jsp">Contact Us</a>
  <a href="UserHelp.jsp">Help</a>
</div>

<div class="page-wrapper">
  <div class="section-title">
    <i class="fas fa-box-open me-2"></i>Available Items
  </div>

  <%
    // ---------- Pagination setup ----------
    final int pageSize = 12;
    int currentPage = 1;
    try {
      String p = request.getParameter("page");
      if (p != null) currentPage = Math.max(1, Integer.parseInt(p));
    } catch (Exception ignored) {}

    int totalCount = 0;
    int totalPages = 1;

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      conn = DriverManager.getConnection(
          "jdbc:mysql://localhost:3306/pahana_edu_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
          "root", ""
      );

      // Count total items
      try (PreparedStatement cps = conn.prepareStatement("SELECT COUNT(*) FROM items");
           ResultSet crs = cps.executeQuery()) {
        if (crs.next()) totalCount = crs.getInt(1);
      }

      totalPages = Math.max(1, (int)Math.ceil(totalCount / (double)pageSize));
      if (currentPage > totalPages) currentPage = totalPages; // clamp
      int offset = (currentPage - 1) * pageSize;

      // Fetch current page
      String sql = "SELECT item_name, price, description, image FROM items LIMIT ? OFFSET ?";
      pst = conn.prepareStatement(sql);
      pst.setInt(1, pageSize);
      pst.setInt(2, offset);
      rs = pst.executeQuery();
  %>

  <div class="row g-4">
    <%
      while (rs.next()) {
        String itemName = rs.getString("item_name");
        double price = rs.getDouble("price");
        String desc = rs.getString("description");
        Blob imageBlob = rs.getBlob("image");
        String base64Image = "";
        if (imageBlob != null) {
          byte[] bytes = imageBlob.getBytes(1, (int) imageBlob.length());
          base64Image = Base64.getEncoder().encodeToString(bytes);
        }
    %>
      <div class="col-sm-6 col-md-4 col-lg-3">
        <div class="item-card h-100">
          <% if (!base64Image.isEmpty()) { %>
            <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Item Image" class="img-fluid" />
          <% } else { %>
            <img src="https://via.placeholder.com/150x150?text=No+Image" alt="No Image" class="img-fluid" />
          <% } %>
          <div class="item-name"><%= itemName %></div>
          <div class="item-price">Rs. <%= String.format("%,.2f", price) %></div>
          <div class="item-desc"><%= (desc == null ? "" : desc) %></div>
        </div>
      </div>
    <% } %>
  </div>

  <!-- Pagination controls -->
  <nav aria-label="Items pagination" class="mt-4">
    <ul class="pagination justify-content-center">
      <%
        String baseUrl = request.getContextPath() + "/SellItems.jsp";
        int start = Math.max(1, currentPage - 3);
        int end   = Math.min(totalPages, currentPage + 3);
      %>

      <!-- Prev -->
      <li class="page-item <%= (currentPage <= 1 ? "disabled" : "") %>">
        <a class="page-link" href="<%= (currentPage <= 1 ? "#" : baseUrl + "?page=" + (currentPage - 1)) %>">Prev</a>
      </li>

      <!-- Numbers -->
      <% for (int i = start; i <= end; i++) { %>
        <li class="page-item <%= (i == currentPage ? "active" : "") %>">
          <a class="page-link" href="<%= baseUrl + "?page=" + i %>"><%= i %></a>
        </li>
      <% } %>

      <!-- Next -->
      <li class="page-item <%= (currentPage >= totalPages ? "disabled" : "") %>">
        <a class="page-link" href="<%= (currentPage >= totalPages ? "#" : baseUrl + "?page=" + (currentPage + 1)) %>">Next</a>
      </li>
    </ul>

    <p class="text-center text-muted small mb-0">
      Page <%= currentPage %> of <%= totalPages %> &middot; <%= totalCount %> item(s)
    </p>
  </nav>

  <%
    } catch (Exception e) {
      out.println("<div class='alert alert-danger'>Error loading items: " + e.getMessage() + "</div>");
    } finally {
      try { if (rs != null) rs.close(); } catch (Exception ignored) {}
      try { if (pst != null) pst.close(); } catch (Exception ignored) {}
      try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
  %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

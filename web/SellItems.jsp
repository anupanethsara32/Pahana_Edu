<%@ page import="java.sql.*, java.util.Base64" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Sell Items - Pahana Edu</title>
</head>
<body>

<!-- Navigation Links -->
<div>
  <a href="Index.jsp">Home</a> |
  <a href="AboutUs.jsp">About</a> |
  <a href="SellItems.jsp">Items</a> |
  <a href="ContactUs.jsp">Contact Us</a> |
  <a href="UserHelp.jsp">Help</a>
</div>

<h2>Available Items</h2>

<table border="1" cellpadding="10" cellspacing="0">
  <tr>
    <th>Image</th>
    <th>Item Name</th>
    <th>Price</th>
    <th>Description</th>
  </tr>
  <%
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");

        String sql = "SELECT item_name, price, description, image FROM items";
        pst = conn.prepareStatement(sql);
        rs = pst.executeQuery();

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
  <tr>
    <td>
      <% if (!base64Image.isEmpty()) { %>
        <img src="data:image/jpeg;base64,<%= base64Image %>" width="100" height="100" alt="Item Image"/>
      <% } else { %>
        <img src="https://via.placeholder.com/100x100?text=No+Image" alt="No Image"/>
      <% } %>
    </td>
    <td><%= itemName %></td>
    <td>Rs. <%= price %></td>
    <td><%= desc %></td>
  </tr>
  <%
        }
        rs.close();
        pst.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p>Error loading items: " + e.getMessage() + "</p>");
    }
  %>
</table>

</body>
</html>

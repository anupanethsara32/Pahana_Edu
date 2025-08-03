<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String username = request.getParameter("username");
  String firstName = "", lastName = "", telephone = "", address = "";

  try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
    PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE username = ?");
    ps.setString(1, username);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
      firstName = rs.getString("first_name");
      lastName = rs.getString("last_name");
      telephone = rs.getString("telephone");
      address = rs.getString("address");
    }
    rs.close(); ps.close(); con.close();
  } catch(Exception e) {
    out.print("Error loading customer: " + e.getMessage());
  }
%>
<html>
<head>
  <title>Edit Customer</title>
</head>
<body>
  <h3>Edit Customer - <%= username %></h3>
  <form action="UpdateCustomerServlet" method="post">
    <input type="hidden" name="username" value="<%= username %>">
    First Name: <input type="text" name="firstName" value="<%= firstName %>" required><br>
    Last Name: <input type="text" name="lastName" value="<%= lastName %>" required><br>
    Telephone: <input type="text" name="telephone" value="<%= telephone %>" required><br>
    Address: <input type="text" name="address" value="<%= address %>" required><br>
    <button type="submit">Update</button>
  </form>
</body>
</html>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pahana Edu - Admin Dashboard</title>
</head>
<body>

<!-- Sidebar -->
<div>
    <h4>Pahana Edu</h4>
    <ul>
        <li><a href="#">Dashboard</a></li>
        <li><a href="Register.jsp">Add New Customer</a></li>
        <li><a href="ManageCustomers.jsp">Manage Customers</a></li>
        <li><a href="ManageItems.jsp">Manage Items</a></li>
        <li><a href="Billing.jsp">Billing</a></li>
        <li><a href="Billinghistory.jsp">Bill History</a></li>
        <li><a href="AdminMessages.jsp">Contact Messages</a></li>
        <li><a href="AdminHelp.jsp">Help</a></li>
    </ul>
    <a href="#" onclick="document.getElementById('logoutModal').style.display='block'">Exit System</a>
</div>

<!-- Dashboard Content -->
<div>
    <h2>Admin Dashboard</h2>

    <%
        int customerCount = 0, itemCount = 0, billCount = 0;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
            Statement stmt = con.createStatement();

            ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) AS total FROM users");
            if (rs1.next()) customerCount = rs1.getInt("total");

            ResultSet rs2 = stmt.executeQuery("SELECT COUNT(*) AS total FROM items");
            if (rs2.next()) itemCount = rs2.getInt("total");

            ResultSet rs3 = stmt.executeQuery("SELECT COUNT(*) AS total FROM bill_images");
            if (rs3.next()) billCount = rs3.getInt("total");

            rs1.close(); rs2.close(); rs3.close(); stmt.close(); con.close();
        } catch (Exception e) {
            out.println("DB Error: " + e.getMessage());
        }
    %>

    <h3>Total Customers: <%= customerCount %></h3>
    <h3>Total Items: <%= itemCount %></h3>
    <h3>Bills Generated: <%= billCount %></h3>

    <p><a href="Register.jsp">Create New Customer</a></p>
    <p><a href="AdminMessages.jsp">View Contact Messages</a></p>
    <p><a href="Billinghistory.jsp">View Bill History</a></p>
    <p><a href="AdminHelp.jsp">Help & Support</a></p>
</div>

<!-- Logout Modal -->
<div id="logoutModal" style="display:none;">
    <p>Are you sure you want to exit the system?</p>
    <a href="logout.jsp">Yes, Exit</a>
    <button onclick="document.getElementById('logoutModal').style.display='none'">Cancel</button>
</div>

</body>
</html>

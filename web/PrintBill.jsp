<!-- Item Inputs -->
<div class="row g-3 mb-4 no-print">
  <div class="col-md-4">
    <label>Select Item</label>
    <select id="item_code" class="form-select" onchange="fetchPrice()">
      <option value="">-- Select Item --</option>
      <% 
        try {
          Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
          Statement st = con.createStatement();
          ResultSet rs = st.executeQuery("SELECT item_code, item_name, price FROM items");
          while (rs.next()) {
      %>
      <option value="<%=rs.getString("item_code")%>" data-price="<%=rs.getDouble("price")%>">
        <%=rs.getString("item_name")%> (<%=rs.getString("item_code")%>)
      </option>
      <% } con.close(); } catch (Exception e) { out.print("<option>Error loading items</option>"); } %>
    </select>
  </div>

  <div class="col-md-2">
    <label>Price</label>
    <input type="text" id="price" class="form-control" readonly>
  </div>

  <div class="col-md-2">
    <label>Quantity</label>
    <input type="number" id="quantity" class="form-control" onchange="calculateTotal()">
  </div>

  <div class="col-md-2">
    <label>Total</label>
    <input type="text" id="total" class="form-control" readonly>
  </div>

  <div class="col-md-2 d-flex align-items-end">
    <button type="button" class="btn btn-primary w-100" onclick="addToTable()">Add</button>
  </div>
</div>

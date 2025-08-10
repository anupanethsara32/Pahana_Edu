<%@ page import="java.util.*, java.sql.*, java.util.Base64" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String accountNo = (String) session.getAttribute("accountNo");
    if (accountNo == null) {
        response.sendRedirect("Index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Bills - Pahana Edu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- Bootstrap + FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

  <style>
    body { background-color: #f0f4f8; font-family: 'Segoe UI', sans-serif; margin:0; }

    /* Sidebar */
    .sidebar {
      display: flex; flex-direction: column; justify-content: space-between;
      height: 100vh; width: 250px; position: fixed; left: 0; top: 0;
      background-color: #0097c2; color: #fff; padding: 30px 0;
    }
    .sidebar h4 { text-align: center; font-weight: bold; margin-bottom: 30px; }
    .sidebar a { display: block; padding: 12px 20px; color: #fff; text-decoration: none; transition: background 0.3s; }
    .sidebar a:hover { background-color: #007ba3; }
    .logout-btn {
      margin: 20px; background-color: #dc3545 !important; border-radius: 30px; padding: 12px 0;
      font-weight: bold; text-align: center; color: #fff !important; text-decoration: none; display: block;
    }
    .logout-btn:hover { background-color: #b02a37 !important; }

    /* Page content */
    .content { margin-left: 250px; padding: 30px; }
    .header-bar {
      background: linear-gradient(to right, #0abcf9, #0097c2);
      color: #fff; padding: 30px; border-radius: 0 0 20px 20px; text-align: center;
    }

    .bill-card {
      background-color: #fff; border-radius: 15px; padding: 20px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.07); transition: 0.3s; height: 100%;
    }
    .bill-image { max-width: 100%; border-radius: 10px; cursor: pointer; transition: transform 0.3s; }
    .bill-image:hover { transform: scale(1.03); }

    .footer { text-align: center; margin-top: 60px; padding: 20px; font-size: 14px; color: #888; }

    /* Modal image area */
    .zoom-container {
      overflow: auto;
      border-radius: 10px;
      max-height: 75vh;
      background: #f8f9fa;
      padding: 8px;
      cursor: default;
    }
    .zoom-container.pannable { cursor: grab; }
    .zoom-container.panning { cursor: grabbing; }
    .modal-img {
      display: block;
      max-width: 100%;
      transform-origin: center center;
      transition: transform 0.15s ease-in-out;
      user-select: none;
      -webkit-user-drag: none;
      pointer-events: none; /* ensures drag scroll happens on container */
    }

    /* Modal toolbar */
    .toolbar .btn { margin-right: .5rem; }
    .toolbar .btn:last-child { margin-right: 0; }

    @media (max-width: 768px) {
      .sidebar { width: 100%; height: auto; position: relative; }
      .content { margin-left: 0; padding: 20px; }
    }
  </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
  <div>
    <h4><i class="fas fa-user-circle me-2"></i>My Dashboard</h4>
    <a href="UserDashboard.jsp"><i class="fas fa-home me-2"></i>Home</a>
    <a href="UserBills.jsp"><i class="fas fa-file-invoice me-2"></i>View Bills</a>
  </div>
  <a href="#" class="logout-btn" data-bs-toggle="modal" data-bs-target="#logoutModal">
    <i class="fas fa-power-off me-2"></i>Exit System
  </a>
</div>

<!-- Page Content -->
<div class="content">
  <!-- Header -->
  <div class="header-bar">
    <h2>My Bill History</h2>
    <p>All your saved bills in one place</p>
  </div>

  <!-- Bill List -->
  <div class="container mt-5">
    <div class="row g-4">
      <%
        try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pahana_edu_db", "root", "");
          PreparedStatement pst = con.prepareStatement(
            "SELECT id, image, created_at FROM bill_images WHERE account_no = ? ORDER BY created_at DESC");
          pst.setString(1, accountNo);
          ResultSet rs = pst.executeQuery();
          boolean hasBills = false;
          while (rs.next()) {
            hasBills = true;
            int id = rs.getInt("id");
            Blob imgBlob = rs.getBlob("image");
            String created = rs.getString("created_at");
            byte[] imgBytes = imgBlob.getBytes(1, (int) imgBlob.length());
            String base64Image = Base64.getEncoder().encodeToString(imgBytes);
      %>
      <div class="col-md-4">
        <div class="bill-card text-center">
          <!-- Thumbnail / opener -->
          <img src="data:image/png;base64,<%=base64Image%>" class="bill-image"
               alt="Bill Image" data-bs-toggle="modal" data-bs-target="#viewModal<%=id%>">
          <p class="mt-3 text-muted">Created At: <%=created%></p>

          <!-- Direct download button -->
          <a class="btn btn-outline-primary btn-sm"
             download="bill_<%=id%>.png"
             href="data:image/png;base64,<%=base64Image%>">
            <i class="fa-solid fa-download me-1"></i> Download
          </a>
        </div>
      </div>

      <!-- Preview Modal for this bill -->
      <div class="modal fade" id="viewModal<%=id%>" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered" id="dlg<%=id%>">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Bill Preview (#<%=id%>)</h5>
              <div class="toolbar ms-auto d-flex align-items-center">
                <!-- Hand / pan tool -->
                <button type="button" class="btn btn-outline-secondary btn-sm"
                        data-action="pan-toggle" data-target="#cont<%=id%>">
                  <i class="fa-solid fa-hand"></i>
                </button>
                <!-- Zoom controls -->
                <button type="button" class="btn btn-outline-secondary btn-sm"
                        data-action="zoom-out" data-target="#img<%=id%>">
                  <i class="fa-solid fa-magnifying-glass-minus"></i>
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm"
                        data-action="zoom-in" data-target="#img<%=id%>">
                  <i class="fa-solid fa-magnifying-glass-plus"></i>
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm"
                        data-action="reset" data-target="#img<%=id%>">
                  100%
                </button>
                <!-- Full screen toggle -->
                <button type="button" class="btn btn-outline-secondary btn-sm"
                        data-action="fullscreen" data-dialog="#dlg<%=id%>">
                  <i class="fa-solid fa-up-right-and-down-left-from-center"></i>
                </button>
                <!-- Download -->
                <a class="btn btn-primary btn-sm ms-2"
                   download="bill_<%=id%>.png"
                   href="data:image/png;base64,<%=base64Image%>">
                  <i class="fa-solid fa-download me-1"></i> Download
                </a>
                <button type="button" class="btn btn-outline-dark btn-sm ms-2" data-bs-dismiss="modal">
                  Close
                </button>
              </div>
            </div>
            <div class="modal-body">
              <div class="zoom-container" id="cont<%=id%>">
                <img id="img<%=id%>" src="data:image/png;base64,<%=base64Image%>" class="modal-img" alt="Bill Full Image"
                     data-zoom="1">
              </div>
              <small class="text-muted">Tip: enable the hand tool to drag (pan) the zoomed image.</small>
            </div>
          </div>
        </div>
      </div>
      <%
          } // while
          if (!hasBills) {
            out.println("<div class='col-12'><div class='alert alert-info text-center'>No bills found yet.</div></div>");
          }
          rs.close(); pst.close(); con.close();
        } catch (Exception e) {
          out.println("<div class='alert alert-danger'>Error loading bills: " + e.getMessage() + "</div>");
        }
      %>
    </div>

    <!-- Back Button -->
    <div class="text-center mt-4">
      <a href="UserDashboard.jsp" class="btn btn-outline-primary">
        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
      </a>
    </div>
  </div>

  <!-- Footer -->
  <div class="footer">
    &copy; 2025 Pahana Edu. All rights reserved.
  </div>
</div>

<!-- Logout Confirmation Modal -->
<div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-danger">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title" id="logoutModalLabel">Confirm Exit</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">Are you sure you want to exit the system?</div>
      <div class="modal-footer">
        <a href="logout.jsp" class="btn btn-danger">Yes, Exit</a>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Zoom / Fullscreen / Hand tool — event delegation
  document.addEventListener('click', function (e) {
    const btn = e.target.closest('[data-action]');
    if (!btn) return;

    const action = btn.getAttribute('data-action');

    // Zoom actions target an <img>
    if (action === 'zoom-in' || action === 'zoom-out' || action === 'reset') {
      const img = document.querySelector(btn.getAttribute('data-target'));
      if (!img) return;

      const step = 0.2, minZoom = 0.5, maxZoom = 6;
      let z = parseFloat(img.getAttribute('data-zoom')) || 1;

      if (action === 'zoom-in')  z = Math.min(maxZoom, z + step);
      if (action === 'zoom-out') z = Math.max(minZoom, z - step);
      if (action === 'reset')    z = 1;

      img.style.transform = 'scale(' + z + ')';
      img.setAttribute('data-zoom', z.toString());
      return;
    }

    // Pan toggle targets the .zoom-container
    if (action === 'pan-toggle') {
      const cont = document.querySelector(btn.getAttribute('data-target'));
      if (!cont) return;
      cont.classList.toggle('pannable');
      return;
    }

    // Fullscreen toggles Bootstrap modal dialog fullscreen class
    if (action === 'fullscreen') {
      const dialog = document.querySelector(btn.getAttribute('data-dialog'));
      if (!dialog) return;
      dialog.classList.toggle('modal-fullscreen');
      return;
    }
  });

  // Drag-to-pan when hand tool is enabled
  (function enablePanning() {
    let isDown = false, startX = 0, startY = 0, sL = 0, sT = 0, currentCont = null;

    function onMouseDown(ev) {
      const cont = ev.currentTarget;
      if (!cont.classList.contains('pannable')) return;
      isDown = true;
      currentCont = cont;
      cont.classList.add('panning');
      startX = ev.clientX;
      startY = ev.clientY;
      sL = cont.scrollLeft;
      sT = cont.scrollTop;
      ev.preventDefault();
    }
    function onMouseMove(ev) {
      if (!isDown || !currentCont) return;
      const dx = ev.clientX - startX;
      const dy = ev.clientY - startY;
      currentCont.scrollLeft = sL - dx;
      currentCont.scrollTop  = sT - dy;
    }
    function endPan() {
      isDown = false;
      if (currentCont) currentCont.classList.remove('panning');
      currentCont = null;
    }

    // Touch support
    function onTouchStart(ev) {
      const cont = ev.currentTarget;
      if (!cont.classList.contains('pannable')) return;
      isDown = true;
      currentCont = cont;
      cont.classList.add('panning');
      const t = ev.touches[0];
      startX = t.clientX; startY = t.clientY;
      sL = cont.scrollLeft; sT = cont.scrollTop;
    }
    function onTouchMove(ev) {
      if (!isDown || !currentCont) return;
      const t = ev.touches[0];
      const dx = t.clientX - startX;
      const dy = t.clientY - startY;
      currentCont.scrollLeft = sL - dx;
      currentCont.scrollTop  = sT - dy;
    }

    // Attach listeners to any current/future zoom containers
    function bindTo(el) {
      el.addEventListener('mousedown', onMouseDown);
      el.addEventListener('mousemove', onMouseMove);
      el.addEventListener('mouseleave', endPan);
      el.addEventListener('mouseup', endPan);
      el.addEventListener('touchstart', onTouchStart, {passive:true});
      el.addEventListener('touchmove', onTouchMove, {passive:true});
      el.addEventListener('touchend', endPan);
    }

    document.querySelectorAll('.zoom-container').forEach(bindTo);
    // For modals that load later, observe additions:
    const obs = new MutationObserver(muts => {
      muts.forEach(m => m.addedNodes.forEach(n => {
        if (n.nodeType === 1) n.querySelectorAll?.('.zoom-container').forEach(bindTo);
      }));
    });
    obs.observe(document.body, {childList: true, subtree: true});
    document.addEventListener('mouseup', endPan);
  })();
</script>

</body>
</html>

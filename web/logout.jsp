<%
    HttpSession s = request.getSession(false);
    if (s != null) s.invalidate();
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    response.sendRedirect("Index.jsp");
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate();  // Ends the session
    response.sendRedirect("Index.jsp");  // Redirect to login or landing page
%>

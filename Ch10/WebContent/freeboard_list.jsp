<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 리스트 보기</title>
<link href="freeboard.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function check() {
	with (document.msgsearch) {
		if (sval.value.length == 0) {
			alert("검색어를 입력해 주세요!!");
			sval.focus();
			return false;
		}
		document.msgsearch.submit();
	}
}
function rimgchg(p1, p2) {
	if (p2 == 1)
		document.images[p1].src = "image/open.gif";
	else
		document.images[p1].src = "image/arrow.gif";
}

function imgchg(p1, p2) {
	if (p2 == 1)
		document.images[p1].src = "image/open.gif";
	else
		document.images[p1].src = "image/close.gif";
}
</script>
</head>
<body>
<% request.setCharacterEncoding("utf-8"); %>
<p>
<p align=center><font color=#0000ff face=굴림 size=3><strong>자유 게시판</strong></font></p> 
<p>
<div align="center">
 <table border="0" width="600" cellpadding="4" cellspacing="0">
  <tr align="center"> 
   <td colspan="5" height="1" bgcolor="#1F4F8F"></td>
  </tr>
  <tr align="center" bgcolor="#87E8FF"> 
   <td width="42" bgcolor="#DFEDFF"><font size="2">번호</font></td>
   <td width="340" bgcolor="#DFEDFF"><font size="2">제목</font></td>
   <td width="84" bgcolor="#DFEDFF"><font size="2">등록자</font></td>
   <td width="78" bgcolor="#DFEDFF"><font size="2">날짜</font></td>
   <td width="49" bgcolor="#DFEDFF"><font size="2">조회</font></td>
  </tr>
  <tr align="center"> 
   <td colspan="5" bgcolor="#1F4F8F" height="1"></td>
  </tr>
 <%
 	Vector name = new Vector();
 	Vector inputdate = new Vector();
 	Vector email = new Vector();
 	Vector subject = new Vector();
 	Vector rcount = new Vector();

 	Vector step = new Vector();
 	Vector keyid = new Vector();
 	int where = 1;

 	int totalgroup = 0;
 	int maxpages = 5;
 	int startpage = 1;
 	int endpage = startpage + maxpages - 1;
 	int wheregroup = 1;

 	if (request.getParameter("go") != null) {
 		where = Integer.parseInt(request.getParameter("go"));
 		wheregroup = (where - 1) / maxpages + 1;
 		startpage = (wheregroup - 1) * maxpages + 1;
 		endpage = startpage + maxpages - 1;
 	} else if (request.getParameter("gogroup") != null) {
 		wheregroup = Integer.parseInt(request.getParameter("gogroup"));
 		startpage = (wheregroup - 1) * maxpages + 1;
 		where = startpage;
 		endpage = startpage + maxpages - 1;
 	}
 	int nextgroup = wheregroup + 1;
 	int priorgroup = wheregroup - 1;

 	int nextpage = where + 1;
 	int priorpage = where - 1;
 	int startrow = 0;
 	int endrow = 0;
 	int maxrows = 10;
 	int totalrows = 0;
 	int totalpages = 0;

 	int id = 0;

 	String em = null;
 	Connection con = null;
 	Statement st = null;
 	ResultSet rs = null;

 	try {
 		Class.forName("com.mysql.jdbc.Driver");
 	} catch (ClassNotFoundException e) {
 		out.println(e);
 	}

 	try {
 		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fboard?useSSL=false", "multi", "1234");
 	} catch (SQLException e) {
 		out.println(e);
 	}

 	try {
 		st = con.createStatement();
 		String sql = "select * from freeboard order by masterid desc, replynum, step, id";
 		rs = st.executeQuery(sql);

 		if (!rs.next()) {
 			out.println("게시판에 올린 글이 없습니다");
 		} else {
 			do {
 				keyid.add(new Integer(rs.getInt("id")));
 				name.add(rs.getString("name"));
 				email.add(rs.getString("email"));
 				String idate = rs.getString("inputdate");
 				idate = idate.substring(0, 8);
 				inputdate.add(idate);
 				subject.add(rs.getString("subject"));
 				rcount.add(new Integer(rs.getInt("readcount")));
 				step.add(new Integer(rs.getInt("step")));
 			} while (rs.next());
 			totalrows = name.size();
 			totalpages = (totalrows - 1) / maxrows + 1;
 			startrow = (where - 1) * maxrows;
 			endrow = startrow + maxrows - 1;
 			if (endrow >= totalrows)
 				endrow = totalrows - 1;

 			totalgroup = (totalpages - 1) / maxpages + 1;
 			if (endpage > totalpages)
 				endpage = totalpages;

 			for (int j = startrow; j <= endrow; j++) {
 				String temp = (String) email.get(j);
 				if ((temp == null) || (temp.equals("")))
 					em = (String) name.get(j);
 				else
 					em = "<a href=mailto:" + temp + ">" + name.get(j) + "</a>";

 				id = totalrows - j;
 				if (j % 2 == 0) {
 					out.println(
 							"<tr bgcolor='#FFFFFF' onMouseOver=\" bgColor= '#DFEDFF'\" onMouseOut=\"bgColor=''\">");
 				} else {
 					out.println(
 							"<tr bgcolor='#F4F4F4' onMouseOver=\" bgColor= '#DFEDFF'\" onMouseOut=\"bgColor='#F4F4F4'\">");
 				}
 				out.println("<td align='center'>");
 				out.println(id + "</td>");
 				out.println("<td>");
 				int stepi = ((Integer) step.get(j)).intValue();
 				int imgcount = j - startrow;
 				if (stepi > 0) {
 					for (int count = 0; count < stepi; count++)
 						out.print("&nbsp;&nbsp;");
 					out.println("<img name='icon'" + imgcount + " src='image/arrow.gif'>");
 					out.print("<a href=freeboard_read.jsp?id=");
 					out.print(keyid.get(j) + "&page=" + where);
 					out.print(" onmouseover=\"rimgchg(" + imgcount + ", 1)\"");
 					out.print(" onmouseout=\"rimgchg(" + imgcount + ", 2)\">");
 				} else {
 					out.println("<img name=icon" + imgcount + " src=image/close.gif>");
 					out.print("<a href=freeboard_read.jsp?id=");
 					out.print(keyid.get(j) + "&page=" + where);
 					out.print(" onmouseover=\"imgchg(" + imgcount + ", 1)\"");
 					out.print(" onmouseout=\"imgchg(" + imgcount + ", 2)\">");
 				}
 				out.println(subject.get(j) + "</td>");
 				out.println("<td align='center'>");
 				out.println(em + "</td>");
 				out.println("<td align='center'>");
 				out.println(inputdate.get(j) + "</td>");
 				out.println("<td align='center'>");
 				out.println(rcount.get(j) + "</td>");
 				out.println("</tr>");
 			}
 			rs.close();
 		}
 		out.println("</table>");
 		st.close();
 		con.close();
 	} catch (java.sql.SQLException e) {
 		out.println(e);
 	}

 	if (wheregroup > 1) {
 		out.println("[<a href=freeboard_list.jsp?gogroup=1>처음</a>]");
 		out.println("[<a href=freeboard_list.jsp?gogroup=" + priorgroup + ">이전</a>]");
 	} else {
 		out.println("[처음]");
 		out.println("[이전]");
 	}
 	if (name.size() != 0) {
 		for (int jj = startpage; jj <= endpage; jj++) {
 			if (jj == where)
 				out.println("[" + jj + "]");
 			else
 				out.println("[<a href=freeboard_list.jsp?go=" + jj + ">" + jj + "</a>]");
 		}
 	}
 	if (wheregroup < totalgroup) {
 		out.println("[<a href=freeboard_list.jsp?gogroup=" + nextgroup + ">다음</a>]");
 		out.println("[<a href=freeboard_list.jsp?gogroup=" + totalgroup + ">마지막</a>]");
 	} else {
 		out.println("[다음]");
 		out.println("[마지막]");
 	}
 	out.println("전체 글수 :" + totalrows);
 %>
<!--<TABLE border=0 width=600 cellpadding=0 cellspacing=0>
 <TR>
  <TD align=right valign=bottom>
   <A href="freeboard_write.htm"><img src="image/write.gif" width="66" height="21" border="0"></A>
   </TD>
  </TR>
 </TABLE>-->

<form method="post" name="msgsearch" action="freeboard_search.jsp">
<table border="0" width="600" cellpadding="0" cellspacing="0">
 <tr>
  <td align="right" width="241"> 
   <select name="stype" >
    <option value=1 >이름
    <option value=2 >제목
    <option value=3 >내용
    <option value=4 >이름+제목
    <option value=5 >이름+내용
    <option value=6 >제목+내용
    <option value=7 >이름+제목+내용
   </select>
  </td>
  <td width="127" align="center">
   <input type=text size="17" name="sval" >
  </td>
  <td width="115">&nbsp;<a href="#" onClick="check();"><img src="image/serach.gif" border="0" align="absmiddle"></a></td>
  <td align="right" valign="bottom" width="117"><a href="freeboard_write.html"><img src="image/write.gif" border="0"></a></td>
 </tr>
</table>
</form>
</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 검색모드</title>
</head>
<body>
	<p>
	<p align="center">
		<font color="#0000ff" face="굴림" size="3"> <strong>자유게시판(검색모드)</strong>
		</font>
	</p>
	<form action="freeboard_search.jsp" method="post" name="search">
		<table border="0" width="600" align="center">
			<tr>
				<td align="left" width="30%" valign="bottom">[<a
					href="freeboard_list.jsp">자유게시판(일반모드)</a>]
				</td>
				<td align="right" width="70%" valign="bottom"><font size="2"
					face="굴림"> <select name="stype">
							<%
								String cond = null;
								int what = 1;
								String val = null;
								if (request.getParameter("stype") != null) {
									what = Integer.parseInt(request.getParameter("stype"));
									val = request.getParameter("sval");
									if (what == 1) {
										out.println("<option value=1 selected>이름");
										cond = " where name like '%" + val + "%'";
									} else {
										out.println("<option value=1>이름");
									}

									if (what == 2) {
										out.println("<option value=2 selected>제목");
										cond = " where subject like '%" + val + "%'";
									} else {
										out.println("<option value=2>이름");
									}

									if (what == 3) {
										out.println("<option value=3 selected>내용");
										cond = " where content like '%" + val + "%'";
									} else {
										out.println("<option value=3>내용");
									}

									if (what == 4) {
										out.println("<option value=4 selected>이름/제목");
										cond = " where name like '%" + val + "%'";
										cond += " or subject like '%" + val + "%'";
									} else {
										out.println("<option value=4>이름/제목");
									}

									if (what == 5) {
										out.println("<option value=5 selected>이름/내용");
										cond = " where name like '%" + val + "%'";
										cond += " or content like '%" + val + "%'";
									} else {
										out.println("<option value=5>이름/내용");
									}

									if (what == 6) {
										out.println("<option value=6 selected>제목/내용");
										cond = " where subject like '%" + val + "%'";
										cond += " or content like '%" + val + "%'";
									} else {
										out.println("<option value=6>제목/내용");
									}

									if (what == 7) {
										out.println("<option value=7 selected>이름/제목/내용");
										cond = " where name like '%" + val + "%'";
										cond += " or subject like '%" + val + "%'";
										cond += " or content like '%" + val + "%'";
									} else {
										out.println("<option value=7>이름/제목/내용");
									}

									if (val.trim().equals(""))
										cond = "";
								}
							%>
					</select>
				</font> 
				<input type="text" name="sval" value="<%=request.getParameter("sval")%>">
				<input type="submit" value="검색">
				</td>
			</tr>
		</table>
	</form>
	
	<div align="center">
		<table border="0" width="600" cellpadding="4" cellspacing="0">
			<tr align="center">
				<td colspan="5" height="1" bgcolor="#1f4f8f"></td>
			</tr>
			<tr align="center" bgcolor="#87e8ff">
				<td width="42" bgcolor="#dfedff"><font size="2">번호</font></td>
				<td width="340" bgcolor="#dfedff"><font size="2">제목</font></td>
				<td width="84" bgcolor="#dfedff"><font size="2">등록자</font></td>
				<td width="78" bgcolor="#dfedff"><font size="2">날짜</font></td>
				<td width="49" bgcolor="#dfedff"><font size="2">조회</font></td>
			</tr>
			<tr align="center">
			<td colspan="5" bgcolor="#1f4f8f" height="1"></td>
			</tr>
			<%
				Vector name = new Vector();
				Vector inputdate = new Vector();
				Vector email = new Vector();
				Vector subject = new Vector();
				Vector rcount = new Vector();
				Vector step = new Vector();
				Vector key_id = new Vector();
				
				int where = 1;
				
				int totalgroup = 0;
				int maxpages = 5;
				int startpage = 1;
				int endpage = startpage + maxpages -1;
				int wheregroup = 1;
				
				if(request.getParameter("go") != null) {
					where = Integer.parseInt(request.getParameter("go"));
					wheregroup = (where-1)/maxpages + 1;
					startpage = (wheregroup-1) * maxpages + 1;
					endpage = startpage + maxpages-1;
				} else if (request.getParameter("gogroup") != null) {
					wheregroup = Integer.parseInt(request.getParameter("gogroup"));
					startpage = (wheregroup-1) * maxpages +1;
					where = startpage;
					endpage = startpage + maxpages-1;
				}
				
				int nextgroup = wheregroup+1;
				int priorgroup = wheregroup-1;
				int startrow = 0;
				int endrow = 0;
				int maxrows = 5;
				int totalrows = 0;
				int totalpages = 0;
				
				int id = 0;
				
				String email2 = null;
				Connection con = null;
				Statement st = null;
				ResultSet rs = null;
				
				try{
					Class.forName("com.mysql.jdbc.Driver");
				} catch(ClassNotFoundException e) {
					out.println(e);
				}
				
				try { 
					con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fboard?useSSL=false", "multi", "1234");
				} catch (SQLException e) {
					out.println(e);
				}
				
				try {
					st = con.createStatement();
					rs = st.executeQuery("select * from freeboard" + cond + " order by id desc");// order by masterid desc, replynum, step, id
					
					if(!(rs.next())){
						out.println("해당하는 글이 없습니다.");
					} else {
						do{
							key_id.add(new Integer(rs.getInt("id")));
							name.add(rs.getString("name"));
							email.add(rs.getString("email"));
							String idate = rs.getString("inputdate");
							idate = idate.substring(0, 8);
							inputdate.add(idate);
							subject.add(rs.getString("subject"));
							rcount.add(new Integer(rs.getInt("readcount")));
							step.add(new Integer(rs.getInt("step")));
						} while(rs.next());
						totalrows = name.size();
						totalpages = (totalrows-1)/maxrows+1;
						startrow = (where-1)*maxrows;
						endrow = startrow + maxrows - 1;
						if(endrow >= totalrows)
							endrow = totalrows-1;
						
						totalgroup = (totalpages-1)/maxpages + 1;
						if(endpage > totalpages)
							endpage = totalpages;
						
						for(int j = startrow; j <= endrow; j++) {
							String temp = (String)email.get(j);
							if((temp == null) || (temp.equals(""))) {
								email2 = (String)name.get(j);
							} else {
								email2 = "<a href=mailto:" + temp + ">" + name.get(j) + "</a>";
							}
							
							id = totalrows-j;
							
							if(j%2 == 0) {
								out.println("<tr bgcolor='#ffffff' onMouseOver=\" bgColor='#dfedff'\" onMouseOut=\"bgColor='#f4f4f4'\">");
							} else{
								out.println("<tr bgcolor='#f4f4f4' onMouseOver=\" bgColor='#dfedff'\" onMouseOut=\"bgColor='#f4f4f4'\">");
							}
							
							out.println("<td align='center'>");
							out.println(id + "</td>");
							out.println("<td>");
							int stepi = ((Integer)step.get(j)).intValue();
							if(stepi>0) {
								for(int count = 0; count < stepi; count++)
									out.print("&nbsp;&nbsp;");
							}
							String click = "<a href=freeboard_read.jsp?id=" + key_id.get(j);
							click = click + "&page=" + where + ">" +subject.get(j) + "</a>";
							out.println(click + "</td>");
							out.println("<td align='center'>");
							out.println(email2 + "</td>");
							out.println("<td>");
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
				} catch (SQLException e) {
					out.println(e);
				}
				if(wheregroup > 1) {
					out.println("[<a href='freeboard_search.jsp?gogroup=1");
					out.println("&stype=" + what + "&sval=" + val + ">처음</a>]");
					out.println("[<a href='freeboard_search.jsp?gogroup="+priorgroup);
					out.println("&stype=" + what + "&sval=" + val + ">이전</a>]");
				} else {
					out.println("[처음]");
					out.println("[이전]");
				}
				
				if(name.size() != 0) {
					for(int j = startpage; j<=endpage; j++) {
						if(j == where)
							out.println("[" + j + "]");
						else{
							out.println("[<a href=freeboard_search.jsp?go=" + j);
							out.println("&stype=" + what + "&sval=" + val + ">" + j +"</a>]");
						}
					}
				}
				if(wheregroup < totalgroup) {
					out.println("[<a href=freeboard_search.jsp?gogroup="+ nextgroup);
					out.println("&stype=" + what + "&sval=" + val + ">다음</a>]");
					out.println("[<a href=freeboard_list.jsp?gogroup="+ totalgroup);
					out.println("&stype=" + what + "&sval=" + val + ">마지막</a>]");
				}else {
					out.println("[다음]");
					out.println("[마지막]");
				}
				out.println("검색된 글수 :" + totalrows);
			%>
	</div>
</body>
</html>
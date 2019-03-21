<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>답글 페이지</title>
<script type="text/javascript">
	function check() {
		with(document.msgrewrite) {
			if(subject.value.length == 0) {
				alert("제목을 입력해 주세요.");
				subject.focus();
				return false;
			}
			if(name.value.length == 0) {
				alert("이름 입력해 주세요.");
				name.focus();
				return false;
			}
			if(password.value.length == 0) {
				alert("비밀번호를 입력해 주세요.");
				password.focus();
				return false;
			}
			if(content.value.length == 0) {
				alert("내용을 입력해 주세요.");
				content.focus();
				return false;
			}
			document.msgrewrite.submit();
		}
	}
</script>
<link href="filegb.css" rel="stylesheet" type="text/css">
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
		String sql = null;
		Connection con = null;
		PreparedStatement st = null;
		ResultSet rs = null;
		String sub = null;
		int step = 0;
		int rnum = 0;
		int mid = 0;
		
		int cnt = 0;
		int id = Integer.parseInt(request.getParameter("id"));
		/* String p = request.getParameter("page"); */
		
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
			sql = "select * from freeboard where id = ?";
			st = con.prepareStatement(sql);
			st.setInt(1, id);
			rs = st.executeQuery();
			if(!rs.next()){
				out.println("해당 내용이 없습니다.");
			} else {
				
			step = rs.getInt("step");
			mid = rs.getInt("masterid");
			rnum = rs.getInt("replynum");
	%>
	<div align="center">
	<form action="freeboard_rsave.jsp?id=<%=id%>&page=<%=request.getParameter("page") %>" name="msgrewrite" method="post">
		<table width="600" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="2" bgcolor="#1f4f8f" height="1"></td>
			</tr>
			<tr>
				<td colspan="2" bgcolor="#dfedff" height="20" class="notice">&nbsp;&nbsp;
				<font size="2">글 답변하기</font></td>
			</tr>
			<tr>
				<td colspan="2" bgcolor="#1f4f8f" height="1"></td>
			</tr>
			<tr>
				<td width="124" height="30" align="center" bgcolor="#f4f4f4">이름 </td>
				<td width="494" style="padding:0 0 0 10">
					<input type="text" name="name" class="input_style1">
				</td>
			</tr>
			<tr>
				<td width="124" align="center"  bgcolor="#f4f4f4">E-mail</td>
				<td width="494" style="padding:0 0 0 10" height="25">
					<input type="email" name="email" class="input_style1">
				</td>
			</tr>
			<tr>
				<td width="124" align="center" bgcolor="#f4f4f4">제목</td>
				<td width="494" style="padding:0 0 0 10" height="25">
					<input type="text" name="subject" size="60" value="Re :<%=rs.getString("subject")%>" class="input_style2">
				</td>
			</tr>
			<tr>
				<td width="124" height="162" align="center" valign="top" bgcolor="#f4f4f4" style="padding-top:7;">내용</td>
				<td width="494" valign="top" style="padding:5 0 5 10">
					<textarea name="content" rows="10" cols="65" class="textarea_style1">
				
-----Original Message-----
<%=rs.getString("content") %></textarea>
				</td>
			</tr>
			<tr>
				<td width="124" align="center" bgcolor="#f4f4f4">암호</td>
				<td width="494" style="padding:0 0 0 10" height="25">
					<input type="password" name="password" class="input_style1"><br>(정확한 비밀번호를 입력해야만 수정이 됩니다.)
				</td>
			</tr>
			<tr>
				<td colspan="2" height="1" class="button"></td>
			</tr>
			<tr>
				<td colspan="2" height="1" bgcolor="#1f4f8f"></td>
			</tr>
			<tr>
				<td colspan="2" height="10"></td>
			</tr>
			<tr>
				<td colspan="2" align="right">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="64%">&nbsp;</td>
							<td width="12%"><a href="#" onclick="check();"><img alt="" src="image/ok.gif" border="0"></a></td>
							<td width="12%"><a href="#" onclick="history.go(-1);"><img alt="" src="image/cancle.gif" border="0"></a></td>
							<td width="12%"><a href="freeboard_list.jsp?go=<%=request.getParameter("page") %>"><img alt="" src="image/list.jpg" border="0"></a></td>
						</tr>
					</table> 
				</td>
			</tr>
		</table>
		<input type="hidden" name="step" value="<%=step%>">
		<input type="hidden" name="mid" value="<%=mid%>">
		<input type="hidden" name="rnum" value="<%=rnum%>">
	</form>
	<%
			}
			rs.close();
			st.close();
			con.close();
		}catch (SQLException e) {
			out.println(e);
		}
	%>
	</div>
</body>
</html>
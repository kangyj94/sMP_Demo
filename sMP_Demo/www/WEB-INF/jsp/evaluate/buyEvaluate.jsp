<%@page import="kr.co.bitcube.evaluate.dto.EvaluateDto"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	@SuppressWarnings("unchecked")
	List<EvaluateDto> evalRow = (List<EvaluateDto>) request.getAttribute("evalRow");
	
	@SuppressWarnings("unchecked")
	List<EvaluateDto> evalCol = (List<EvaluateDto>) request.getAttribute("evalCol");

	@SuppressWarnings("unchecked")
	List<EvaluateDto> evalUsers = (List<EvaluateDto>) request.getAttribute("evalUsers");
%>

<head>
<title>OK Plaza에 오신것을 환영합니다.</title>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<link href="<%=Constances.SYSTEM_JSCSS_URL%>/css/homepage_style.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
</script>
<script type="text/javascript">
// function MM_swapImgRestore() { //v3.0
//   var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
// }
// function MM_findObj(n, d) { //v4.01
//   var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
//     d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
//   if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
//   for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
//   if(!x && d.getElementById) x=d.getElementById(n); return x;
// }

// function MM_swapImage() { //v3.0
//   var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
//    if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
// }
</script>


<script type="text/javascript">
$(document).ready(function(){
	$("#evalRegButton").click( function() { evalReg(); });
});

function evalReg(){
	
	var evalUser = $.trim($("#evalUser").val()); 
	
	if(evalUser == ""){
		alert("평가하실 운영담당자를 선택해 주세요.");
		return;
	}
	
	var evalSelCdArr = new Array();
	var evalDescArr = new Array();
	var arrCnt = 0;
	
<%
	for(int i = 0 ; i < evalRow.size() ; i++){
%>

		var chkVal = $(':radio[name="<%=evalRow.get(i).getEvalTypeCd()%>"]:checked').val(); 

		if(chkVal == undefined || chkVal == null || chkVal == ''){
			alert("[<%=evalRow.get(i).getEvalTypeNm()%>] 항목을 평가해 주세요.");
			return;
		}
<%	
	}
%>

<%
	for(int i = 0 ; i < evalRow.size() ; i++){
%>
		evalSelCdArr[arrCnt] = $(':radio[name="<%=evalRow.get(i).getEvalTypeCd()%>"]:checked').val();
		evalDescArr[arrCnt] = $("#desc_<%=evalRow.get(i).getEvalTypeCd()%>").val();
		arrCnt++;
<%	
	}
%>
	
	if(!confirm($("#evalUser option:selected").text() + " 님의 평가를 하시겠습니까?")) return;
	
	$.post(
   		"<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluate/saveEvaluate.sys", 
   		{	
   			evalSelCdArr:evalSelCdArr, 
   			evalDescArr:evalDescArr,
   			evalUser:evalUser
   		},       
   		function(arg){ 
      		if(fnAjaxTransResult(arg)) {  //성공시
      			alert("평가가 완료되었습니다.");
                $('#frm').attr('action','/evaluate/buyEvaluate.sys');
                $('#frm').attr('Target','_self');
                $('#frm').attr('method','post');
                $('#frm').submit();
      		}
   		}
	);
}
</script>

</head>
<body>
	<form id="frm">
	
	<table width="1000px" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td align="center">
				<!-- 메인 컨텐츠 시작-->
				<table width="980px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="34" valign="top">&nbsp;</td>
						<td valign="top">
							<!-- 메인 컨텐츠 내용 시작-->
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td height="50px" ></td>
								</tr>
								
								<tr>
									<td align="left" width="5px">
										<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" /> <font size="3"><b>평 가</b></font>
									</td>
								</tr>
								<tr>
									<td height="8px" ></td>
								</tr>
								<tr>
									<td>
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td colspan="4" class="table_top_line"></td>
											</tr>
											<tr>
												<td width="20%" class="table_td_subject">운영담당자</td>
												<td colspan="3" class="table_td_contents">
													<select id="evalUser" name="evalUser" class="select" >
														<option value="">선택</option>
													
												<%
													if(evalUsers != null && evalUsers.size() > 0){
														for(int i = 0 ; i < evalUsers.size() ; i++){
												%>
														<option value="<%=evalUsers.get(i).getUserId()%>"><%=evalUsers.get(i).getUserNm()%></option>
												<%
														}
													}
												%>	
													
													
													</select>
												</td>
											</tr>
											<tr>
												<td colspan="4" class="table_top_line"></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td colspan="<%=(evalCol.size() * 2) + 6  %>" class="table_top_line"></td>
											</tr>
											<tr>
												<td width="120" class="bbs_td_subject2" style="line-height: 16px;">평가항목</td>
												<td class="table_td_split2"></td>
												<td width="200" class="bbs_td_subject2">평가내용</td>
												<td class="table_td_split2"></td>
												
										<%
											for(int i = 0 ; i < evalCol.size() ; i++){
										%>
												<td width="80" class="bbs_td_subject2"><%=evalCol.get(i).getEvalselNm()%></td>
												<td class="table_td_split2"></td>										
										<%		
											}
										%>												
												<td class="bbs_td_subject2">평가사유</td>
												<td class="table_td_split2"></td>
											</tr>
											<tr>
												<td colspan="<%=(evalCol.size() * 2) + 6  %>" class="table_middle_line"></td>
											</tr>
										<%
											for(int i = 0 ; i < evalRow.size() ; i++){
										%>
											<tr >
												<td class="bbs_td_subject2" style="line-height: 38px;"><%=evalRow.get(i).getEvalTypeNm() %></td>
												<td class="table_td_split2"></td>
												<td ><%=evalRow.get(i).getEvalTypeDesc() %></td>
												<td class="table_td_split2"></td>
												
											<%
												for(int j = 0 ; j < evalCol.size() ; j++){
											%>
												<td >
													<input style="border: 0px;" type="radio" name="<%=evalRow.get(i).getEvalTypeCd()%>" id="<%=evalRow.get(i).getEvalTypeCd() + "_" + evalCol.get(j).getEvalselCd()%>" value="<%=evalRow.get(i).getEvalTypeCd() + "_" + evalCol.get(j).getEvalselCd()%>" />
												</td>
												<td class="table_td_split2"></td>
											<%		
												}
											%>
												<td >
													<textarea id="desc_<%=evalRow.get(i).getEvalTypeCd()%>" rows="20" cols="20" style="height: 35px" ></textarea>
												</td>
												<td class="table_td_split2"></td>
											</tr>
											<tr>
												<td colspan="<%=(evalCol.size() * 2) + 6  %>" class="table_middle_line"></td>
											</tr>
										<%	
											}
										%>
											<tr>
												<td colspan="<%=(evalCol.size() * 2) + 6  %>" class="table_bottom_line"></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td height="8px" ></td>
								</tr>
								<tr>
									<td>
										<input type="button" id="evalRegButton" name="evalRegButton" value="평가하기"/>
									</td>
								</tr>
							</table> <!-- 메인 컨텐츠 내용 끝-->
						</td>
					</tr>
				</table> <!-- 메인 컨텐츠 끝-->
			</td>
		</tr>
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
	</table>
	</form>
</body>
</html>
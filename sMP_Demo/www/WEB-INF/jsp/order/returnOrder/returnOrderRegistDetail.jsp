<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.order.dto.OrderReturnDto" %>
<%@ page import="java.util.List"%>

<%
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");

	OrderReturnDto orderReturnDto = (OrderReturnDto)request.getAttribute("detailInfo");	//게시물정보
	boolean isVen = request.getAttribute("ven") != null ? true : false;	
    
	String retu_iden_num = (String)request.getParameter("retu_iden_num");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
   $("#closeButton").click(function(){ close(); });
});
</script>

</head>
<body>
<form id="frm" name="frm" method="post">
<input type="hidden" name="retu_iden_num" id="retu_iden_num" value="<%=retu_iden_num%>" />
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td height="29" class='ptitle'>반품이력상세</td>
					</tr>
				</table> 
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
					<tr>
						<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
						<td class="stitle">반품상세</td>
					</tr>
				</table> 
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="4" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">반품번호</td>
						<td class="table_td_contents">
							<%=orderReturnDto.getRetu_iden_num() %>
						</td>
						<td class="table_td_subject" width="100">고객사</td>
						<td class="table_td_contents">
							<%=orderReturnDto.getOrde_client_name() %>
						</td>
					</tr>
					<tr>
						<td colspan="4" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">공급사</td>
						<td class="table_td_contents">
							<%=orderReturnDto.getVendornm() %>
						</td>
						<td class="table_td_subject" width="100">주문번호</td>
						<td class="table_td_contents">
							<%=orderReturnDto.getOrde_iden_numb() %>
						</td>
					</tr>
					<tr>
						<td colspan="4" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">상품명</td>
						<td class="table_td_contents">
							<%=orderReturnDto.getGood_name()%>
						</td>
						<td class="table_td_subject" width="100">규격</td>
						<td class="table_td_contents">
	        <% 
            String result = "";
            try{
                int cnt = 0;
                String[] tempGoodStSpecDesc = new String[Constances.PROD_GOOD_ST_SPEC.length]; 
                for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {
    	        	tempGoodStSpecDesc[idx] = Constances.PROD_GOOD_ST_SPEC[idx];
                }
                if(null != orderReturnDto.getGood_spec_desc()){
                    String[] tempGoodStSpecDescArray = orderReturnDto.getGood_st_spec_desc().split("‡");
                    for(int idx = 0 ; idx < tempGoodStSpecDescArray.length ; idx++) {
                        if(tempGoodStSpecDescArray[idx].toString().trim().length()  > 0) {
                             result += tempGoodStSpecDesc[idx]+":"+ tempGoodStSpecDescArray[idx] + " ";
                             cnt++;
                        }
                    }
                }
                if(cnt>0){
                    result = "<font color='red'><b>["+result+"]</font></b>";
                }
                
                String[] tempGoodSpecDesc = new String[Constances.PROD_GOOD_SPEC.length]; 
                for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {
    	        	tempGoodSpecDesc[idx] = Constances.PROD_GOOD_SPEC[idx];
                }
                if(null != orderReturnDto.getGood_spec_desc()){
                    String[] tempGoodSpecDescArray = orderReturnDto.getGood_spec_desc().split("‡");
                    for(int idx = 0 ; idx < tempGoodSpecDescArray.length ; idx++) {
                        if(tempGoodSpecDescArray[idx].toString().trim().length()  > 0) {
                             if(idx == 0 ) {
                            	 result += "  "+ tempGoodSpecDescArray[idx] + "  ";
                             } else {
                            	 result += tempGoodSpecDesc[idx]+":"+ tempGoodSpecDescArray[idx] + " ";
                             }
                        }
                    }
                }
            }catch(Exception e){result="";}
            %>
                            <%=result%>
						</td>
					</tr>
					<tr>
						<td colspan="4" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">단가</td>
						<td class="table_td_contents">
							<%=isVen ? orderReturnDto.getSale_unit_pric() : orderReturnDto.getOrde_requ_pric()%>
						</td>
						<td class="table_td_subject" width="100">주문/인수수량</td>
						<td class="table_td_contents">
							<%=orderReturnDto.getOrde_rece_quan()%>
						</td>
					</tr>
					<tr>
						<td colspan="4" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">반품수량</td>
						<td class="table_td_contents">
							<%=(int)orderReturnDto.getRetu_prod_quan()%>
						</td>
						<td class="table_td_subject" width="100">반품처리상태</td>
						<td class="table_td_contents">
                           <%=orderReturnDto.getRetu_stat_flag()%>
						</td>
					</tr>
					<tr>
						<td colspan="4" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject">반품요청사유</td>
						<td colspan="3" class="table_td_contents4">
							<%=orderReturnDto.getRetu_rese_text() == null ? "" : orderReturnDto.getRetu_rese_text()%>
						</td>
					</tr>
					<tr>
						<td colspan="4" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject">공급사거부사유</td>
						<td colspan="3" class="table_td_contents4">
							<%=orderReturnDto.getRetu_cnac_text() == null ? "" : orderReturnDto.getRetu_cnac_text()%>
						</td>
					</tr>
					<tr>
						<td colspan="4" class="table_top_line"></td>
					</tr>
				</table> <!-- 컨텐츠 끝 -->
			</td>
		</tr>
		<tr style="height: 40px">
			<td align="center"> <a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style='border:0;' /></a></td>
		</tr>
	</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</form>
</body>
</html>
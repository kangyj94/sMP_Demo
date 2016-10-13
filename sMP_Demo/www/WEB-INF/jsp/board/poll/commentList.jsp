<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<table width="600" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
				<tr>
					<td width="21" style="background-color: #ea002c; height: 47px;"></td>
					<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
						<h2>댓글 리스트</h2>
					</td>
					<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
						<a href="#;" class="jqmClose">
						<img src="/img/contents/btn_close.png" class="jqmClose">
						</a>
					</td>
					<td width="10" style="background-color: #ea002c; height: 47px;"></td>
				</tr>
			</table>
		<table width="100%"  border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" /></td>
                <td width="100%"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif" width="100%" height="20" /></td>
                <td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
            </tr>
			<tr>
                <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                <td valign="top" bgcolor="#FFFFFF">
                    <div id="jqgrid">
                        <table id="cList"></table>
                        <div id="cPager"></div>
                    </div>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="center">
                            <button id="btnClose" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
                            </td>
                        </tr>
                    </table>
                </td>   
                <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
            </tr>
			<tr>
				<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
				<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
				<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
$(function() {
	fnCGridInit();
    $("#pollPop").jqDrag('#userDialogHandle');
	$('.jqmClose').click(function (e) {
        $('#pollPop').html('');
		$('#pollPop').jqmHide();
	});
});
//그리드 초기화
function fnCGridInit() {
    $("#cList").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectPollCommentList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        //colNames:['댓글 내용','${param.type eq "BUY"?"고객사":"공급사"}','작성자'],
        colNames:['댓글 내용','작성자'],
        colModel:[
            {name:'COMMENT',width:430},//댓글 내용
            //{name:'TYPENM',width:200},//고객사
            {name:'REGIUSERNM',width:60,align:'center'}//작성자
        ],
        postData: {pollId:'${param.pollId}',type:'${param.type}'},
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#cPager',
        height:250,autowidth:true,
        sortname: 'POLLID', sortorder: 'desc',
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#cList").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    })
    .jqGrid("setLabel", "rn", "순번");
}
</script>
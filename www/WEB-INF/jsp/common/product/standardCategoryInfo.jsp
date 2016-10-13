<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="StyleSheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/dtree/dtree.css" type="text/css"/>
<script type="text/javascript" src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/dtree/dtree.js"></script>
<style type="text/css">
.jqmCategoryWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 500px;
    background-color: #EEE;
    color: #333;
}
.jqmOverlay { background-color: #000; }
* html .jqmCategoryWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- ------------------------ 초기세팅 및 선택값 리턴 스크립트---------------------------  -->
<script type="text/javascript">
$(function(){
	// Dialog 초기화 
	$('#categoryDialogPop').jqm(); 
	$('#categoryDialogPop').jqm().jqDrag('#categoryDialogHandle');
	
	fnInitStandardCategoryComponent(); 
	
});
</script>
<!-- ------------------------ 초기세팅 및 선택값 리턴 끝---------------------------  -->

<!-- ------------------------ 컨퍼넌트 생성 관련 스크립트 -------------------------------  -->
<script type="text/javascript">
function fnInitStandardCategoryComponent(){
	//alert('Start Method fnInitStandardCategoryComponent()!!!!'); 
	$.post(	//조회조건의 권역세팅
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/category/getStandardCategoryTreeJQ.sys',
			{},
			function(arg){
				standardCategory = new dTree('standardCategory','');
               	standardCategory.config.folderLinks = true;
               	
               	var cateInfo = eval('(' + arg + ')').standCategoryListInfo;
               	
				for(var idx=0;idx<cateInfo.length;idx++) {
					standardCategory.add(cateInfo[idx].cate_Id,cateInfo[idx].ref_Cate_Seq,cateInfo[idx].majo_Code_Name,"javascript:void(0);fnChoiceStandardCategory('"+cateInfo[idx].cate_Id+"','"+cateInfo[idx].lev+"','"+cateInfo[idx].full_Cate_Name+"','"+cateInfo[idx].majo_Code_Name+"')",'');	//Home
                }
				$('#categoryTab_0').append(""+standardCategory+"");
				//alert(document.write(standardCategory));
				//$('#categoryTab_0').append(document.write(standardCategory));
			}
		);	
}

var callbackCateDivMethodName = "";
var choiceLevel = ""; 
function fnSearchStandardCategoryInfo(choiceCategoryLevel , callbackString){
	choiceLevel = choiceCategoryLevel;
	callbackCateDivMethodName = callbackString;
	$("#categoryDialogPop").jqmShow();
}
</script>
<!-- ------------------------ 컨퍼넌트 생성 관련 끝 -------------------------------  -->

<!-- ------------------------ 버튼 이벤트 관련 스크립트---------------------------  -->
<script type="text/javascript">
function fnChoiceStandardCategory(cateId,cateLev,cateFullName,cateName) {
	var msg = ""; 
	msg += "\n cateId       value ["+cateId      +"]"; 
	msg += "\n cateLev      value ["+cateLev     +"]";
	msg += "\n cateFullName value ["+cateFullName+"]";
	msg += "\n cateName value ["+cateName+"]";
	msg += "\n choiceLevel  value ["+choiceLevel+"]";
	msg += "\n cateLev      value ["+cateLev+"]";
	//alert(msg);
	if(Number(choiceLevel) <= Number(cateLev)) {
		eval(callbackCateDivMethodName+"('"+cateId+"','"+cateName+"','"+cateFullName+"');");
		$("#categoryDialogPop").jqmHide();
	}
}
</script>
<!-- ------------------------ 버튼 이벤트 관련 끝-------------------------------  -->
</head>
<body>
   <div class="jqmCategoryWindow" id="categoryDialogPop" >
	<div id="divPopup" style="width:500px;">
	<h1 id="categoryDialogHandle">표준카테고리<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
	  <div class="popcont">
        <div id="categoryLeftDiv" style="TEXT-ALIGN: left; leftMargin:0; position:relative; width:100%; height:400px; overflow-x:scroll; overflow-y:scroll; border:1px solid; border:#CCCCCC; ">
           <div id="categoryTab_0" class="dtree" style="display:block; padding:0 0 0 0;overflow: auto;"></div>
        </div>
	    <div class="Ac mgt_10">
	       <button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
	    </div>
	  </div>
	</div>
   </div>
   <div id="messageDialog" title="Warning" style="display: none; font-size: 12px; color: red;"></div>
</body>
</html>

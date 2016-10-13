<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Daum에디터 - 이미지 첨부</title> 
<script src="/daumeditor/js/popup.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="/daumeditor/css/popup.css" type="text/css"  charset="utf-8"/>
<script type="text/javascript">
// <![CDATA[
	
	function done() {
		
		 if (typeof(execAttach) == 'undefined') { //Virtual Function
	        return;
	    } 
 		 
		 /*
		 var _mockdata = {
			'imageurl': 'http://cfile284.uf.daum.net/image/116E89154AA4F4E2838948',
			'filename': 'editor_bi.gif',
			'filesize': 640,
			'imagealign': 'C',
			'originalurl': 'http://cfile284.uf.daum.net/original/116E89154AA4F4E2838948',
			'thumburl': 'http://cfile284.uf.daum.net/P150x100/116E89154AA4F4E2838948'
		};  
		*/
		
 		/*  
		 var _mockdata = {
				'imageurl': '${upload.attachFilePath}/${upload.attachFile.originalFilename}',
				'filename': '${upload.attachFile.originalFilename}',
				'filesize': '${upload.attachFile.size}',
				'imagealign': 'C',
				'originalurl': '${upload.attachFilePath}/${upload.attachFile.originalFilename}',
				'thumburl': '${upload.attachFilePath}/P150x100/${upload.attachFile.originalFilename}'
			};
 		
		 */

		 var _mockdata = {
				'imageurl': '${upload.attachFilePath}/${upload.attachFileName}',
				'filename': '${upload.attachFile.originalFilename}',
				'filesize': '${upload.attachFile.size}',
				'imagealign': 'C',
				'originalurl': '${upload.attachFilePath}/${upload.attachFile.originalFilename}',
				'thumburl': '${upload.attachFilePath}/P150x100/${upload.attachFile.originalFilename}'
			};
		
		
		execAttach(_mockdata);

		closeWindow();

	}

	function initUploader(){
	    var _opener = PopupUtil.getOpener();
	    if (!_opener) {
	        alert('잘못된 경로로 접근하셨습니다.');
	        return;
	    }
	    
	    var _attacher = getAttacher('image', _opener);
	    registerAction(_attacher);
	}
// ]]>
</script>
</head>
<body onload="initUploader();done();">
<!-- body -->

<div class="wrapper">
	<div class="header">
		<h1>사진 첨부</h1>
	</div>	
	<div class="body">
		
			<dl class="alert">
			    <dt>사진 미리보기</dt>
			    <dd>
			    <form name="frm" method="post" action="" enctype="">
			    	<img src="${upload.attachFilePath}/${upload.attachFile.originalFilename}" width="150"></img>
			    </form>
				</dd>
			</dl>
	</div>
		
	<div class="footer">
		<p><a href="#" onclick="closeWindow();" title="닫기" class="close">닫기</a></p>
		<ul>
			<li class="submit"><a href="#" onclick="done();" title="적용" class="btnlink">적용</a> </li>
			<li class="cancel"><a href="#" onclick="closeWindow();" title="취소" class="btnlink">취소</a></li>
		</ul>
	</div>
</div>
</body>
</html>


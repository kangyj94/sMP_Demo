package kr.co.bitcube.common.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

public class FileDownloadView extends AbstractView {

	public FileDownloadView() {
		this.setContentType("application/download; charset=utf-8");
	}
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		File file = (File)model.get("file");
		String attachOriginName = CommonUtils.getString(model.get("attachOriginName"));
		String userAgent = request.getHeader("User-Agent");
		OutputStream out = response.getOutputStream();
		String fileName = null;
		boolean ie = false;
		FileInputStream fis = null;
		
		response.setContentType(this.getContentType());
		response.setContentLength((int)file.length());
		
        if("".equals(attachOriginName) && attachOriginName == null){
			fileName = URLEncoder.encode(file.getName(), "utf-8");
        }else{
			fileName = URLEncoder.encode(attachOriginName, "utf-8");
        }
//		if(userAgent.indexOf("MSIE") > -1){ ie = true; }
//		if(ie){
//			if("".equals(attachOriginName) && attachOriginName == null){
//				fileName = URLEncoder.encode(file.getName(), "utf-8");
//			}else{
//				fileName = URLEncoder.encode(attachOriginName, "utf-8");
//			}
//		}else{
//			if("".equals(attachOriginName) && attachOriginName == null){
//				fileName = new String(file.getName().getBytes("utf-8"), "iso-8859-1");
//			}else{
//				fileName = new String(attachOriginName.getBytes("utf-8"), "iso-8859-1");
//			}
//		}
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");
		try{
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
		} finally {
			if(fis != null) {
				try{ fis.close(); }
				catch(Exception e){}
			}
		}
		out.flush();
	}
}

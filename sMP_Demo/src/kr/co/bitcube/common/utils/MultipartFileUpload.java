package kr.co.bitcube.common.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

/**
 * 파일을 저장하고 파일의 정보을 제공
 * @author jameskang
 *
 */
public class MultipartFileUpload {

	private String fileName = "";	//원본 파일명
	private File destinationFile = null;	//업로드된 파일정보
	
	public MultipartFileUpload(MultipartFile file, File uploadDir) throws IOException {
		this.fileName = file.getOriginalFilename();
		this.destinationFile = File.createTempFile("upload", fileName, uploadDir);
		FileCopyUtils.copy(file.getInputStream(), new FileOutputStream(destinationFile));
	}
	
	public String getFileName() {
		return this.fileName;
	}
	public String getExtension() {
		return fileName.substring(fileName.lastIndexOf(".")+1);
	}
	public String getUploadedFile() {
		return this.destinationFile.getAbsolutePath();
	}
}

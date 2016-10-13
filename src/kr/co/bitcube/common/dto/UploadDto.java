package kr.co.bitcube.common.dto;

import org.springframework.web.multipart.MultipartFile;

public class UploadDto {

	private MultipartFile attachFile;
	private String attachFilePath;
	private String attachFileName;
	private String attachFileMime;

	public String getAttachFileName() {
		return attachFileName;
	}

	public void setAttachFileName(String attachFileName) {
		this.attachFileName = attachFileName;
	}

	public MultipartFile getAttachFile() {
		return attachFile;
	}

	public void setAttachFile(MultipartFile attachFile) {
		this.attachFile = attachFile;
	}

	public String getAttachFilePath() {
		return attachFilePath;
	}

	public void setAttachFilePath(String attachFilePath) {
		this.attachFilePath = attachFilePath;
	}

	public String getAttachFileMime() {
		return attachFileMime;
	}

	public void setAttachFileMime(String attachFileMime) {
		this.attachFileMime = attachFileMime;
	}
}

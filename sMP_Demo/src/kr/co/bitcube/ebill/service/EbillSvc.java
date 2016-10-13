package kr.co.bitcube.ebill.service;

import java.util.List;
import java.util.Map;

import kr.co.bitcube.ebill.dao.EbillDao;
import kr.co.bitcube.ebill.dto.EbillDto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class EbillSvc {
	@Autowired
	private EbillDao eBillDao;
	
	public int selectEbillBranchListCnt(Map<String, Object> paramMap) {
		return eBillDao.selectEbillBranchListCnt(paramMap);
	}

	public List<EbillDto> selectEbillBranchList(Map<String, Object> paramMap, int page, int rows) {
		return eBillDao.selectEbillBranchList(paramMap, page, rows);
	}

	public int selectEbillVendorListCnt(Map<String, Object> paramMap) {
		return eBillDao.selectEbillVendorListCnt(paramMap);
	}
	
	public List<EbillDto> selectEbillVendorList(Map<String, Object> paramMap, int page, int rows) {
		return eBillDao.selectEbillVendorList(paramMap, page, rows);
	}
}

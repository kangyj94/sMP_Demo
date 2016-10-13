package kr.co.bitcube.product.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.bitcube.product.dto.CategoryDto;
import kr.co.bitcube.product.dto.ProductDispDto;
import kr.co.bitcube.product.dto.ProductMasterDto;
import kr.co.bitcube.product.dto.ProductVendorDto;
import kr.co.bitcube.product.dto.ReqProductDto;

@Repository
public class ProductManageDao {

	// Query Xml Path Setting 
	private final String statement = "product.manage.";
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;  // id(Sequence) 생성을 위해 추가
	
	public String selectCateId(String good_iden_numb) throws Exception {
		return (String) this.sqlSessionTemplate.selectOne(statement+"selectCateId", good_iden_numb);
	}
	
	
	public List<ProductMasterDto> selectProductDetailInfo(Map<String, Object> params) throws Exception {
		return  this.sqlSessionTemplate.selectList(statement+"selectProductDetailInfo", params);
	}
	
	
	public List<ProductVendorDto> selectGoodVendorListByGoodIdenNum(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectGoodVendorListByGoodIdenNum", params);
	}
	
	
	public List<ProductVendorDto> selectVendorAutionInfoForInsProduct(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectVendorAutionInfoForInsProduct", params);
	}
	
	
	
	public void deleteProdVendor(Map<String, Object> saveMap){
		sqlSessionTemplate.delete(this.statement+"deleteProdVendor", saveMap);
	}
	
	public void insertProductMstInfomation(Map<String, Object> saveMap){
		sqlSessionTemplate.insert(this.statement+"insertProductMstInfomation", saveMap);
	}
	
	public void updateProductMstInfo(Map<String, Object> saveMap){
		sqlSessionTemplate.update(this.statement+"updateProductMstInfoppp", saveMap);
	}
	
	public void insertProductMstHistInfoByGood_iden_numb(Map<String, Object> saveMap){
		sqlSessionTemplate.insert(this.statement+"insertProductMstHistInfoByGood_iden_numb", saveMap);
	}
	
	public int selectProductVendorCount(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectProductVendorCount", params);
	}
	
	public void insertProductVendorInfo(Map<String, Object> saveMap){
		sqlSessionTemplate.insert(this.statement+"insertProductVendorInfo", saveMap);
	}
	
	public void updateProductVendorInfo(Map<String, Object> saveMap){
		sqlSessionTemplate.update(this.statement+"updateProductVendorInfo", saveMap);
	}

	public void updateProductVendorUnitPric(Map<String, Object> saveMap){
		sqlSessionTemplate.update(this.statement+"updateProductVendorUnitPric", saveMap);
	}
	
	public void insertAppProdVendorUnitPrice(Map<String, Object> saveMap){
		sqlSessionTemplate.insert(this.statement+"insertAppProdVendorUnitPrice", saveMap);
	}
	
	public void insertProductVendorHistInfoBySeq(Map<String, Object> saveMap){
		sqlSessionTemplate.insert(this.statement+"insertProductVendorHistInfoBySeq", saveMap);
	}
	
	
	public List<ProductDispDto> selectDisplayGoodList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectDisplayGoodList", params);
	}
	
	public void deleteProdSalePriceDel(Map<String, Object> saveMap){
		sqlSessionTemplate.update(this.statement+"deleteProdSalePriceDel", saveMap);
	}
	
	
	
	public ProductDispDto selectIsExsistDispproductApp(Map<String, Object> params) {
		return (ProductDispDto)sqlSessionTemplate.selectOne(this.statement+"selectIsExsistDispproductApp", params);
	}
	
	public ProductDispDto selectIsExsistProdVendorApp(Map<String, Object> params) {
		return (ProductDispDto)sqlSessionTemplate.selectOne(this.statement+"selectIsExsistProdVendorApp", params);
	}
	
	@Deprecated
	public ProductDispDto selectDispAppProduct(Map<String, Object> params) {
		return (ProductDispDto)sqlSessionTemplate.selectOne(this.statement+"selectDispAppProduct", params);
	}

	@Deprecated
	public ProductDispDto selectAppProductByVendorId(Map<String, Object> params) {
		return (ProductDispDto)sqlSessionTemplate.selectOne(this.statement+"selectAppProductByVendorId", params);
	}
	
	
	
	public void insertDisplayGood(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertDisplayGood", saveMap);
	}
	
	public void insertAppGoodPrice(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertAppGoodPrice", saveMap);
	}
	
	public int updateMcDispGoodCustGoodIdenNumb(Map<String, Object> saveMap) {
		return sqlSessionTemplate.update(this.statement+"updateMcDispGoodCustGoodIdenNumb", saveMap);
	}
	
	public void updateAppGoodPrice(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateAppGoodPrice", saveMap);
	}
	
	public void updateRefDisplayGood(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateRefDisplayGood", saveMap);
	}
	
	public void updatedisplayGoodUpdateTrans(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updatedisplayGoodUpdateTrans", saveMap);
	}
	
	public void updateDisplayGood(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateDisplayGood", saveMap); 
	}
	
	
	public List<CategoryDto> selectCategoryInfoListByCateId(Map<String, Object> params) {
		return sqlSessionTemplate.selectList(this.statement+"selectCategoryInfoListByCateId",params);
	}
	
	public void delDisplayGoodAppGoodPrice(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"delDisplayGoodAppGoodPrice", saveMap); 
	}
	
	
	public List<ProductDispDto> selectDisplayGoodHistList(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectDisplayGoodHistList", params);
	}
	
	
	public List<ReqProductDto> selectReqProductDetailInfo(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectReqProductDetailInfo", params);
	}
	
	public void insertVendorReqProductInfoMation(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertVendorReqProductInfoMation", saveMap);
	}
	
	public void updateVendorReqProductInfoMation(Map<String, Object> saveMap){
		sqlSessionTemplate.insert(this.statement+"updateVendorReqProductInfoMation", saveMap);
	}
	
	public void deleteVendorReqProductInfoMation(Map<String, Object> saveMap){
		sqlSessionTemplate.insert(this.statement+"deleteVendorReqProductInfoMation", saveMap);
	}
	
	public void updateReqProductAppSts (Map<String, Object> saveMap){
		sqlSessionTemplate.insert(this.statement+"updateReqProductAppSts", saveMap);
	}
	
	public void updateRegistReqProductByAdmin(Map<String, Object> saveMap){
		sqlSessionTemplate.insert(this.statement+"updateRegistReqProductByAdmin", saveMap);
	}
	
	
	public List<ProductVendorDto> selectGoodVendorListForVendor(Map<String, Object> params) {
		return  sqlSessionTemplate.selectList(this.statement+"selectGoodVendorListForVendor", params);
	}
	
	public void insertFixGoodUnitPriceTrans(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert(this.statement+"insertFixGoodUnitPriceTrans", saveMap);
	}
	
	public void updateModifyUseState(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateModifyUseState", saveMap);
	}
	
	public int selectCateCountByCate_id(Map<String, Object> params) {
		return (Integer) sqlSessionTemplate.selectOne(this.statement+"selectCateCountByCate_id", params);
	}
	
	
	public String  selectVendorCountById(Map<String, Object> params) {
		return (String)sqlSessionTemplate.selectOne(this.statement+"selectVendorCountById", params);
	}

	
	public Map<String, Object> selectProdVendorOrdeCntSearch( Map<String, Object> params) {
		return sqlSessionTemplate.selectOne(this.statement+"selectProdVendorOrdeCntSearch", params);
	}

	public ProductVendorDto selectGoodVendorListByGoodIdenNumByExcelUpload( Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectGoodVendorListByGoodIdenNumByExcelUpload", saveMap);
	}
	
	public String selectMcGoodNameForProdDips(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectMcGoodNameForProdDips", saveMap);
	}
	
	public Map<String, String> selectSmpVendorNmForProdDisp(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectSmpVendorNmForProdDisp", saveMap);
	}
	
	public String selectAreaCodeByNameForProdDisp(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectAreaCodeByNameForProdDisp", saveMap);
	}
	
	@Deprecated
	public void updateMcDispalyGoodForProdDisp(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMcDispalyGoodForProdDisp", saveMap);
	}
	
	public String selectDisplayGoodByGoodIdenNumByExcelUpload(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectDisplayGoodByGoodIdenNumByExcelUpload", saveMap);
	}
	
	public String selectMcGoodVendorsByGoodIdenNumByExcelUpload(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectMcGoodVendorsByGoodIdenNumByExcelUpload", saveMap);
	}

	public void updateMcDispalyGoodForNoneProdDisp(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMcDispalyGoodForNoneProdDisp", saveMap);
	}


	public int selectProductSameCheck(Map<String, Object> params) {
		return (Integer)sqlSessionTemplate.selectOne(this.statement+"selectProductSameCheck", params);
	}


	public String selectGoodName(String goodIdenNumb) {
		return sqlSessionTemplate.selectOne(this.statement+"selectGoodName", goodIdenNumb);
	}

	public void updateMcDisplayGoodStatus(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMcDisplayGoodStatus", saveMap);
	}

	public void insertMcDisplay(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"insertMcDisplay", saveMap);
	}


	public String selectUserId(Map<String, Object> saveMap) {
		return sqlSessionTemplate.selectOne(this.statement+"selectUserId", saveMap);
	}


	public String selectAreaCodeByNameForProdDisp2(String areaTypeCdArray) {
		return sqlSessionTemplate.selectOne(this.statement+"selectAreaCodeByNameForProdDisp2", areaTypeCdArray);
	}


	public void updateMcDisplayGoodStatus2(Map<String, Object> saveMap) {
		sqlSessionTemplate.update(this.statement+"updateMcDisplayGoodStatus2", saveMap);
	}


	public void insertGood(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert("product.insertGood", saveMap);
		sqlSessionTemplate.insert("product.insertGoodHist", saveMap);
	}
	public void updateGood(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert("product.updateGood", saveMap);
		sqlSessionTemplate.insert("product.insertGoodHist", saveMap);
	}
	public void insertGoodVendor(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert("product.insertGoodVendor", saveMap);
		sqlSessionTemplate.insert("product.insertGoodVendorHist", saveMap);
	}
	public void updateGoodVendor(Map<String, Object> saveMap) {
		sqlSessionTemplate.insert("product.updateGoodVendor", saveMap);
		sqlSessionTemplate.insert("product.insertGoodVendorHist", saveMap);
	}
}


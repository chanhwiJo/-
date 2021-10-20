package poly.persistance.mapper;

import java.util.List;

import config.Mapper;
import poly.dto.FavoriteDTO;

@Mapper("FavoriteMapper")
public interface IFavoriteMapper {

	// 즐겨찾기 추가
	int insertFavorite(FavoriteDTO fDTO) throws Exception;
	
	// 즐겨찾기 리스트
	List<FavoriteDTO> getFavoriteList(String user_no) throws Exception;
	
	// 즐겨찾기 중복 확인
	int sameFavorite(FavoriteDTO fDTO) throws Exception;
	
	// 즐겨찾기 삭제
	void deleteFavorite(FavoriteDTO fDTO) throws Exception;
}

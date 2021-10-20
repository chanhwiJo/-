package poly.service;

import java.util.List;

import poly.dto.BoardDTO;
import poly.dto.KeyDTO;
import poly.dto.ManageDTO;
import poly.dto.TxtDTO;
import poly.dto.UserDTO;

public interface IUserService {

	// 회원가입
	int insertJoin(UserDTO uDTO) throws Exception;

	// 아이디 중복 확인
	int getUserid(UserDTO uDTO) throws Exception;
	
	// 이메일 중복 확인
	int getEmail(UserDTO uDTO) throws Exception;

	// 인증키 생성
	int insertKey(KeyDTO kDTO) throws Exception;

	// 아이디 찾기
	UserDTO getIdSearch(UserDTO uDTO) throws Exception;

	// 이메일 인증
	KeyDTO getEmailKey(KeyDTO kDTO) throws Exception;
	
	// 로그인
	UserDTO getUserInfo(UserDTO uDTO) throws Exception;

	// 비밀번호 변경
	int updatePassword(UserDTO pDTO) throws Exception;

	// 비밀번호 정보(아이디, 이메일)
	UserDTO getPassword(UserDTO uDTO) throws Exception;

	// 아이디 여부 체크
	int idCheck(UserDTO pDTO) throws Exception;

	// 본인 인증(아이디, 이메일, 전화번호 일치하는지 확인)
	int checkPassword(UserDTO pDTO) throws Exception;

	// 랜덤 비밀번호 변경
	int autoPassword(UserDTO pDTO) throws Exception;

	// 이메일 발송
	int pwmail(UserDTO pDTO) throws Exception;

	// 메인페이지 > 회원
	UserDTO getUserNum() throws Exception;

	// 메인페이지 > 게시판
	BoardDTO getBoardNum() throws Exception;

	// 메인페이지 > 동호회
	ManageDTO getManageNum() throws Exception;

	// 작성글 리스트
	List<BoardDTO> getRegList(String user_no) throws Exception;

	// 총 작성글 개수
	BoardDTO getRegNum(String user_no) throws Exception;

	// 회원 상세
	UserDTO getUserDetail(UserDTO uDTO) throws Exception;

	// 팀명 불러오기
	ManageDTO getTeamName(ManageDTO mDTO) throws Exception;

	// 작성글 검색
	List<BoardDTO> getRegSearch(BoardDTO bDTO) throws Exception;

	// 작성글 검색 결과 수
	BoardDTO getRegSearchNum(BoardDTO sDTO) throws Exception;

	// 작성글 페이징
	List<BoardDTO> getRegSearchPage(BoardDTO uDTO) throws Exception;

	// 계정 탈퇴
	int deleteUser(UserDTO uDTO) throws Exception;

	// 계정 수정
	int updateUser(UserDTO uDTO) throws Exception;

	// 글귀랜덤 출력
	TxtDTO txtPrint(TxtDTO tDTO) throws Exception;

	// 성별 분석
	List<UserDTO> getGenderData() throws Exception;

	// 동호회 가입 여부 분석
	List<UserDTO> getTeamData() throws Exception;

	// 나이 분석
	List<UserDTO> getAgeData() throws Exception;

	// 지역 분석
	List<UserDTO> getAddrData() throws Exception;

	// 월별 회원 가입 비율
	List<UserDTO> getRegData() throws Exception;

	// 회원 리스트
	List<UserDTO> getUserList() throws Exception;

	// 회원 검색
	List<UserDTO> getUserSearch(UserDTO uDTO) throws Exception;

	// 회원 리스트 페이징
	List<UserDTO> getUserPaging(UserDTO uDTO) throws Exception;

	// 회원 검색 결과 수
	UserDTO getUserSearchNum(UserDTO sDTO) throws Exception;

	// 회원 검색 결과 페이징
	List<UserDTO> getUserSearchPage(UserDTO uDTO) throws Exception;

}

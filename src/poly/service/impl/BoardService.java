package poly.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import poly.dto.BoardDTO;
import poly.dto.FileDTO;
import poly.dto.JoinDTO;
import poly.dto.LikeDTO;
import poly.dto.ManageDTO;
import poly.dto.UserDTO;
import poly.persistance.mapper.BoardMapper;
import poly.service.IBoardService;

@Service("BoardService")
public class BoardService implements IBoardService {

	private Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "BoardMapper")
	private BoardMapper boardMapper;

	// 글 리스트
	@Override
	public List<BoardDTO> getBoardList(String team_no) throws Exception {
		return boardMapper.getBoardList(team_no);
	}

	// 게시글 수
	@Override
	public BoardDTO getBoardNum(String team_no) throws Exception {
		return boardMapper.getBoardNum(team_no);
	}

	// 글 상세
	@Override
	public BoardDTO getBoard(BoardDTO bDTO) throws Exception {
		return boardMapper.getBoard(bDTO);
	}

	// 글 등록
	@Override
	public int insertBoard(BoardDTO bDTO) throws Exception {
		return boardMapper.insertBoard(bDTO);
	}

	// 글 번호
	@Override
	public BoardDTO getBoardNo(BoardDTO bDTO) throws Exception {
		return boardMapper.getBoardNo(bDTO);
	}

	// 파일 추가
	@Override
	public int insertFile(FileDTO f) throws Exception {
		return boardMapper.insertFile(f);
	}

	// 조회수 증가
	@Override
	public void updateCnt(BoardDTO cDTO) throws Exception {
		boardMapper.updateCnt(cDTO);
	}

	// 좋아요 추가
	@Override
	public int insertLike(LikeDTO lDTO) throws Exception {
		return boardMapper.insertLike(lDTO);
	}
	
	// 좋아요 수
	@Override
	public int countLike(LikeDTO lDTO) throws Exception {
		return boardMapper.countLike(lDTO);
	}
	
	// 좋아요 유저 중복 확인
	@Override
	public int sameLike(LikeDTO lDTO) throws Exception {

		int res =  boardMapper.sameLike(lDTO);
		
		log.info("좋아요 유저 수 : " + res);
		
		return res;
	}
	
	// 좋아요 삭제
	@Override
	public void deleteLike(LikeDTO lDTO) throws Exception {
		boardMapper.deleteLike(lDTO);
	}
	
	// 파일 상세
	@Override
	public FileDTO getFile(FileDTO fDTO) throws Exception {
		return boardMapper.getFile(fDTO);
	}

	// 파일 삭제
	@Override
	public void deleteFile(FileDTO fDTO) throws Exception {
		boardMapper.deleteFile(fDTO);
	}

	// 글 수정
	@Override
	public int updateBoard(BoardDTO bDTO) throws Exception {
		return boardMapper.updateBoard(bDTO);
	}

	// 글 삭제
	@Override
	public int deleteBoard(BoardDTO bDTO) throws Exception {
		return boardMapper.deleteBoard(bDTO);
	}

	// 게시글 페이징
	@Override
	public List<BoardDTO> getboardPaging(BoardDTO bDTO) throws Exception {
		return boardMapper.getboardPaging(bDTO);
	}

	// 게시글 검색 수
	@Override
	public BoardDTO getboardSearchNum(BoardDTO bDTO) throws Exception {
		return boardMapper.getboardSearchNum(bDTO);
	}

	// 게시글 검색 페이징
	@Override
	public List<BoardDTO> getboardSearchPage(BoardDTO bDTO) throws Exception {
		return boardMapper.getboardSearchPage(bDTO);
	}

	// 게시글 검색
	@Override
	public List<BoardDTO> getboardSearch(BoardDTO bDTO) throws Exception {
		return boardMapper.getboardSearch(bDTO);
	}

	// 동호회 리스트
	@Override
	public List<ManageDTO> getTeamList() throws Exception {
		return boardMapper.getTeamList();
	}

	// 동호회 수
	@Override
	public ManageDTO getTeamNum() throws Exception {
		return boardMapper.getTeamNum();
	}

	// 동호회 중복 체크
	@Override
	public int getTeamName(ManageDTO mDTO) throws Exception {
		return boardMapper.getTeamName(mDTO);
	}

	// 동호회 개설
	@Override
	public int insertTeam(ManageDTO mDTO) throws Exception {
		return boardMapper.insertTeam(mDTO);
	}

	// 동호회 번호 가져오기
	@Override
	public ManageDTO getTeamNo(ManageDTO mDTO) throws Exception {
		return boardMapper.getTeamNo(mDTO);
	}

	// 팀원수 + 1
	@Override
	public void updateTeamUp(String team_no) throws Exception {
	}

	// 팀원수 - 1
	@Override
	public void updateTeamDwon(String team_no) throws Exception {
	}

	// 동호회 가입
	@Override
	public int insertJoin(JoinDTO jDTO) throws Exception {
		return boardMapper.insertJoin(jDTO);
	}

	// 동호회 가입 취소
	@Override
	public void deleteJoin(JoinDTO jDTO) throws Exception {
		boardMapper.deleteJoin(jDTO);
	}

	// 회원 권한, 동호회 번호 수정
	@Override
	public void updateUserTeam(UserDTO uDTO) throws Exception {
		boardMapper.updateUserTeam(uDTO);
	}

	// 권한 수정 (UU로 수정)
	@Override
	public void updateAuth(String user_no) throws Exception {
		boardMapper.updateAuth(user_no);
	}

	// 가입 확인 수정 (O으로 수정)
	@Override
	public void updateJoinCheck(String user_no) throws Exception {
		boardMapper.updateJoinCheck(user_no);
	}

	// 동호회 정보
	@Override
	public ManageDTO getTeam(ManageDTO mDTO) throws Exception {
		return boardMapper.getTeam(mDTO);
	}

	// 동호회 수정
	@Override
	public int updateTeam(ManageDTO mDTO) throws Exception {
		return boardMapper.updateTeam(mDTO);
	}

	// 동호회 삭제
	@Override
	public void deleteTeamDrop(String team_no) throws Exception {
		boardMapper.deleteTeamDrop(team_no);
	}

	// 동호회 삭제로 인한 회원 수정 (auth, team_no)
	@Override
	public void updateTeamDrop(UserDTO uDTO) throws Exception {
		boardMapper.updateTeamDrop(uDTO);
	}

	// 동호회 삭제로 인한 게시글 삭제
	@Override
	public void deleteTeamBoard(String team_no) throws Exception {
		boardMapper.deleteTeamBoard(team_no);
	}

	// 동호회 삭제로 인한 파일 삭제
	@Override
	public void deleteTeamFile(String team_no) throws Exception {
		boardMapper.deleteTeamFile(team_no);
	}

	// 가입 신청 정보
	@Override
	public UserDTO getJoinUser(String user_no) throws Exception {
		return boardMapper.getJoinUser(user_no);
	}

	// 가입 신청
	@Override
	public JoinDTO getJoin(String user_no) throws Exception {
		return boardMapper.getJoin(user_no);
	}

	// 리더 정보
	@Override
	public UserDTO getUser(String team_no) throws Exception {
		return boardMapper.getUser(team_no);
	}

	// 팀원 수
	@Override
	public UserDTO getUserNum(String team_no) throws Exception {
		return boardMapper.getUserNum(team_no);
	}

	// 팀원 리스트
	@Override
	public List<UserDTO> getUserList(String team_no) throws Exception {
		return boardMapper.getUserList(team_no);
	}

	// 팀원 리스트 페이징
	@Override
	public List<UserDTO> getUserTeamPaging(UserDTO uDTO) throws Exception {
		return boardMapper.getUserTeamPaging(uDTO);
	}

	// 팀원 검색
	@Override
	public List<UserDTO> getTeamUserSearch(UserDTO uDTO) throws Exception {
		return boardMapper.getTeamUserSearch(uDTO);
	}

	// 팀원 검색 결과 수
	@Override
	public UserDTO getUserTeamSearchNum(UserDTO uDTO) throws Exception {
		return boardMapper.getUserTeamSearchNum(uDTO);
	}

	// 팀원 검색 페이징
	@Override
	public List<UserDTO> getUserTeamSearchPage(UserDTO uDTO) throws Exception {
		return boardMapper.getUserTeamSearchPage(uDTO);
	}

	// 동호회 페이징
	@Override
	public List<ManageDTO> getTeamPaging(ManageDTO mDTO) throws Exception {
		return boardMapper.getTeamPaging(mDTO);
	}

	// 동호회 검색
	@Override
	public List<ManageDTO> getTeamSearch(ManageDTO mDTO) throws Exception {
		return boardMapper.getTeamSearch(mDTO);
	}

	// 동호회 검색 결과 수
	@Override
	public ManageDTO getTeamSearchNum(ManageDTO mDTO) throws Exception {
		return boardMapper.getTeamSearchNum(mDTO);
	}

	// 동호회 검색 페이징
	@Override
	public List<ManageDTO> getTeamSearchPage(ManageDTO mDTO) throws Exception {
		return boardMapper.getTeamSearchPage(mDTO);
	}

}

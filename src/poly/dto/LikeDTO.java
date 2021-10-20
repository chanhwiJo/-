package poly.dto;

public class LikeDTO {

	private String like_no;
	private String user_no;
	private String board_no;

	private int like_count;
	
	public int getLike_count() {
		return like_count;
	}

	public void setLike_count(int like_count) {
		this.like_count = like_count;
	}

	public String getLike_no() {
		return like_no;
	}

	public void setLike_no(String like_no) {
		this.like_no = like_no;
	}

	public String getUser_no() {
		return user_no;
	}

	public void setUser_no(String user_no) {
		this.user_no = user_no;
	}

	public String getBoard_no() {
		return board_no;
	}

	public void setBoard_no(String board_no) {
		this.board_no = board_no;
	}

}

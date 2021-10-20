package poly.dto;

public class FavoriteDTO {

	String favorite_no;
	String user_no;
	String course_name;
	String cpi_name;
	String cpi_idx;
	String area_gu;

	public String getCpi_idx() {
		return cpi_idx;
	}

	public void setCpi_idx(String cpi_idx) {
		this.cpi_idx = cpi_idx;
	}

	public String getArea_gu() {
		return area_gu;
	}

	public void setArea_gu(String area_gu) {
		this.area_gu = area_gu;
	}

	public String getFavorite_no() {
		return favorite_no;
	}

	public void setFavorite_no(String favorite_no) {
		this.favorite_no = favorite_no;
	}

	public String getUser_no() {
		return user_no;
	}

	public void setUser_no(String user_no) {
		this.user_no = user_no;
	}

	public String getCourse_name() {
		return course_name;
	}

	public void setCourse_name(String course_name) {
		this.course_name = course_name;
	}

	public String getCpi_name() {
		return cpi_name;
	}

	public void setCpi_name(String cpi_name) {
		this.cpi_name = cpi_name;
	}

}

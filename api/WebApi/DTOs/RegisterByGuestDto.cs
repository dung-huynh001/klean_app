using Domain.Enums;

namespace WebApi.DTOs
{
	public class RegisterByGuestDto
	{
		public int UserId { get; set; }
		public string Username { get; set; }
		public string Password { get; set; }
		public UserLv UserLv { get; set; } = UserLv.Lv3;
		public bool LoginPermit { get; set; } = false;
		public DateTime DateOfBirth { get; set; }
		public DateTime RegisterDate { get; set; } = DateTime.Now;
		public string? AddressState { get; set; }
		public string? AddressSuburb { get; set; }
		public string? AddressDetail { get; set; }
		public int PostCode { get; set; }
	}
}

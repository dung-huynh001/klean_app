namespace WebApi.DTOs
{
	public class UpdateProfileDto
	{
		public int UserId { get; set; }
		public DateTime DateOfBirth { get; set; }
		public string? ContactMobile { get; set; }
		public string? ContactTel { get; set; }
		public string? ContactEmail { get; set; }
		public string? AddressState { get; set; }
		public string? AddressSuburb { get; set; }
		public string? AddressDetail { get; set; }
		public int PostCode { get; set; }
	}
}

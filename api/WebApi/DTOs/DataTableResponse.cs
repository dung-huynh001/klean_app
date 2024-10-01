namespace WebApi.DTOs
{
	public class DataTableResponse<T> where T : class
	{
		public List<T> Data { get; set; }
		public int RecordsTotal { get; set; }
		public int RecordsFiltered { get; set; }
	}
}

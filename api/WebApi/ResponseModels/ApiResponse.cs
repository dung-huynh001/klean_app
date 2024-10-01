namespace WebApi.ResponseModels
{
	public class ApiResponse<T>
	{
		public bool IsSuccess { get; set; }
		public string ErrorMessage { get; set; }
		public T Data { get; set; }
	}
}

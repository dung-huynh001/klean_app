namespace WebApi.DTOs
{
	public class DataTableParameters
	{
		public int Length { get; set; }
		public List<OrderBy>? Order { get; set; }
		public int Start { get; set; }
		public Search? Search { get; set; }
		public List<Column>? Columns { get; set; }
		public int Draw { get; set; }

	}

	public class Column
	{
		public string? Data { get; set; }
		public string? Name { get; set; }
		public bool Searchable { get; set; }
		public bool Orderable { get; set; }
	}

	public class OrderBy
	{
		public int Column { get; set; }
		public string? Dir { get; set; }
		public string? Name { set; get; }
	}

	public class Search
	{
		public string? Value { get; set; }
		public bool Regex { get; set; }
	}
}

using System.Diagnostics;
using System.Security.Claims;
using System.Text.Json;

namespace WebApi.Middlewares
{
	public class GlobalExceptionMiddleware
	{
		private readonly RequestDelegate _next;

		public GlobalExceptionMiddleware(RequestDelegate next)
		{
			_next = next;
		}

		public async Task Invoke(HttpContext context)
		{
			try
			{
				await _next(context);
			}
			catch (Exception ex)
			{
				StackTrace stackTrace = new StackTrace(ex, true);
				StackFrame? frame = stackTrace.GetFrame(0);
				string? fileName = frame?.GetFileName();
				int? lineNumber = frame?.GetFileLineNumber();
				string? methodName = frame?.GetMethod()?.DeclaringType?.Name;

				string? sEventCatg = fileName?.Substring(fileName?.LastIndexOf("\\") ?? 0).Replace("\\", "");
				string sEventMsg = "Line: " + lineNumber + "\t" + ex.Message;
				string? sEventSrc = methodName?.Substring(0, methodName.LastIndexOf(">") + 1);
				string sEventType = context.Request.Method;
				string sInsBy = context.User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "GUEST";

				await TraceLog(sEventCatg!, sEventMsg, sEventSrc!, sEventType, sInsBy);
				await HandleExceptionAsync(context, ex);
			}
		}
		public async Task HandleExceptionAsync(HttpContext context, Exception ex)
		{
			var errorDetail = new ErrorDetails()
			{
				Message = ex.Message + " " + ex.InnerException?.Message,
				StatusCode = StatusCodes.Status400BadRequest
			};

			// Set the status code of response
			context.Response.StatusCode = StatusCodes.Status400BadRequest;
			context.Response.ContentType = "application/json";

			await context.Response.WriteAsync(errorDetail.ToString());
		}

		private async Task TraceLog(string sEventCatg, string sEventMsg, string sEventSrc, string sEventType, string sInsBy)
		{
			string sTraceTime = DateTime.Now.ToString("ddMMMyyyyHH");
			string sLogFormat = DateTime.Now.ToShortDateString().ToString() + "\t" + DateTime.Now.ToLongTimeString().ToString() + "\t-->\t";

			string sTraceMsg = $"{sEventCatg ?? "__unknown__",-10}\t{sEventType ?? "__unknown__",-5}\t{sInsBy,-10}\t{sEventSrc ?? "__unknown__"}\t{sEventMsg}\n";

			string loggingFolder = Path.Combine(Directory.GetCurrentDirectory(), "Logging/Exceptions");
			if (!Directory.Exists(loggingFolder))
			{
				Directory.CreateDirectory(loggingFolder);
			}

			string lstPathSeparator = Path.DirectorySeparatorChar.ToString();
			string lstMonth = DateTime.Now.Month < 10
										 ? "0" + DateTime.Now.Month.ToString()
										 : DateTime.Now.Month.ToString();
			string lstYear = DateTime.Now.Year.ToString();
			string lstDestination = loggingFolder + lstPathSeparator + lstYear + lstMonth + lstPathSeparator + DateTime.Now.ToString("ddMMM") + lstPathSeparator;
			if (!Directory.Exists(lstDestination))
				Directory.CreateDirectory(lstDestination);
			string sPathName = lstDestination + lstPathSeparator + sTraceTime + ".txt";
			StreamWriter sw = new StreamWriter(sPathName, true);
			await sw.WriteLineAsync(sLogFormat + sTraceMsg);
			sw.Flush();
			sw.Close();
		}

	}

	public class ErrorDetails
	{
		public int StatusCode { get; set; }
		public string Message { get; set; } = new string("");
		public override string ToString()
		{
			return JsonSerializer.Serialize(this);
		}
	}
}

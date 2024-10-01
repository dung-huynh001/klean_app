using System.Security.Cryptography;
using System.Text;

namespace WebApi.Utils
{
	public class EncodeHelper
	{
		private const string SecretKey = "95EBEB53-1831-45B0-8AA3-370F2C696D0D";

		public static string ComputeSHA256Hash(string str)
		{
			using (SHA256 sha256 = SHA256.Create())
			{
				byte[] bytes = Encoding.UTF8.GetBytes(str + SecretKey);
				byte[] hashBytes = sha256.ComputeHash(bytes);
				StringBuilder hash = new StringBuilder();

				foreach (byte b in hashBytes)
				{
					hash.Append(b.ToString("x2"));
				}

				return hash.ToString();
			}
		}

		public static bool CompareHash(string str, string hash)
		{
			string strHash = ComputeSHA256Hash(str);
			return strHash.Equals(hash, StringComparison.OrdinalIgnoreCase);
		}
	}
}

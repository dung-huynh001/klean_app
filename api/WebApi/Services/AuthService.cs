using Domain.Entities;
using Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using WebApi.DTOs;
using WebApi.ResponseModels;
using WebApi.Utils;

namespace WebApi.Services
{
	public class AuthService
	{
		private readonly AppDbContext _context;
		private readonly IConfiguration _configuration;

		public AuthService(AppDbContext context, IConfiguration configuration)
		{
			this._context = context;
			this._configuration = configuration;
		}
		public async Task<AuthResponse> LoginAsync(LoginDto dto)
		{
			AppUser? user = await _context.Set<AppUser>()
				.FirstOrDefaultAsync(usr => usr.Username.Trim().ToLower() == dto.Username.Trim().ToLower());

			if (user != null)
			{
				bool matches = EncodeHelper.CompareHash(dto.Password, user.Password);
				if (matches)
				{
					string role = user.UserLv.ToString();
					List<Claim> authClaims = new List<Claim>
					{
						new Claim(ClaimTypes.Role, role),
						new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
						new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
						new Claim(ClaimTypes.Name, user.Username)
					};
					SymmetricSecurityKey authKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JWT:Secret"]!));
					JwtSecurityToken token = new JwtSecurityToken(
						issuer: _configuration["JWT:ValidIssuer"],
						audience: _configuration["JWT:ValidAudience"],
						expires: DateTime.UtcNow.AddHours(2),
						claims: authClaims,
						signingCredentials: new SigningCredentials(authKey,
							SecurityAlgorithms.HmacSha512Signature)
					);


					return new AuthResponse
					{
						Token = new JwtSecurityTokenHandler().WriteToken(token)
					};
				}

			}

			throw new Exception("Username or password is incorrect");
		}

		public async Task<RegisterResponse> RegisterAsync(RegisterDto dto)
		{
			bool isIdUnique = ValidatorHelper<AppUser>.IsExist(_context, "UserId", dto.UserId);
			bool isUsernameUnique = ValidatorHelper<AppUser>.IsExist(_context, "Username", dto.Username);

			if (!isIdUnique)
			{
				throw new InvalidDataException("User Id already taken");
			}

			if (!isUsernameUnique)
			{
				throw new InvalidDataException("Username already taken");
			}

			string passwordHash = EncodeHelper.ComputeSHA256Hash(dto.Password);
			AppUser user = new AppUser
			{
				UserId = dto.UserId,
				Username = dto.Username,
				Password = passwordHash,
				DateOfBirth = dto.DateOfBirth,
				ContactMobile = dto.ContactMobile,
				ContactTel = dto.ContactTel,
				ContactEmail = dto.ContactEmail,
				LoginPermit = dto.LoginPermit,
				UserLv = dto.UserLv,
				RegisterDate = dto.RegisterDate,
				AddressDetail = dto.AddressDetail,
				AddressSuburb = dto.AddressSuburb,
				AddressState = dto.AddressState,
				PostCode = dto.PostCode,
			};
			await _context.Set<AppUser>().AddAsync(user);
			await _context.SaveChangesAsync();
			return new RegisterResponse
			{
				UserId = user.UserId
			};
		}

		public async Task<RegisterResponse> RegisterByGuestAsync(RegisterByGuestDto dto)
		{
			bool isIdUnique = ValidatorHelper<AppUser>.IsExist(_context, "UserId", dto.UserId);
			bool isUsernameUnique = ValidatorHelper<AppUser>.IsExist(_context, "Username", dto.Username);

			if (!isIdUnique)
			{
				throw new InvalidDataException("User Id already taken");
			}

			if (!isUsernameUnique)
			{
				throw new InvalidDataException("Username already taken");
			}

			string passwordHash = EncodeHelper.ComputeSHA256Hash(dto.Password);
			AppUser user = new AppUser
			{
				UserId = dto.UserId,
				Username = dto.Username,
				Password = passwordHash,
				DateOfBirth = dto.DateOfBirth,
				LoginPermit = dto.LoginPermit,
				UserLv = dto.UserLv,
				RegisterDate = dto.RegisterDate,
				AddressDetail = dto.AddressDetail,
				AddressSuburb = dto.AddressSuburb,
				AddressState = dto.AddressState,
				PostCode = dto.PostCode,
			};
			await _context.Set<AppUser>().AddAsync(user);
			await _context.SaveChangesAsync();
			return new RegisterResponse
			{
				UserId = user.UserId
			};
		}
	}
}

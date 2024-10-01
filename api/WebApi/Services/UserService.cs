using Domain.Entities;
using Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using WebApi.DTOs;
using WebApi.ResponseModels;
using WebApi.Utils;

namespace WebApi.Services
{
	public class UserService
	{
		private readonly AppDbContext _context;

		public UserService(AppDbContext context)
		{
			this._context = context;
		}

		public async Task<List<GetUserDto>> GetAllUserAsync()
		{
			List<GetUserDto> users = await _context.Set<AppUser>().Select(u => new GetUserDto
			{
				UserId = u.UserId,
				Username = u.Username,
				AddressDetail = u.AddressDetail,
				AddressState = u.AddressState,
				AddressSuburb = u.AddressSuburb,
				ContactEmail = u.ContactEmail,
				ContactMobile = u.ContactMobile,
				ContactTel = u.ContactTel,
				DateOfBirth = u.DateOfBirth,
				LastModifiedDate = u.LastModifiedDate,
				LoginPermit = u.LoginPermit,
				Note = u.Note,
				PostCode = u.PostCode,
				RegisterDate = u.RegisterDate,
				UserLv = u.UserLv,
			}).ToListAsync();

			return users;
		}

		public async Task<DataTableResponse<GetUserDto>> GetUsersAsync(DataTableParameters filter)
		{
			string searchValue = filter.Search?.Value?.Trim()?.ToLower() ?? "";

			IQueryable<GetUserDto> records = _context.Set<AppUser>()
				.AsNoTracking()
				.Select(u => new GetUserDto
				{
					AddressDetail = u.AddressDetail,
					AddressState = u.AddressState,
					AddressSuburb = u.AddressSuburb,
					ContactEmail = u.ContactEmail,
					ContactMobile = u.ContactMobile,
					ContactTel = u.ContactTel,
					DateOfBirth = u.DateOfBirth,
					LoginPermit = u.LoginPermit,
					Note = u.Note,
					PostCode = u.PostCode,
					RegisterDate = u.RegisterDate,
					UserLv = u.UserLv,
					LastModifiedDate = u.LastModifiedDate,
					UserId = u.UserId,
					Username = u.Username
				});
			int recordsTotal = records.Count();

			if(!searchValue.IsNullOrEmpty())
			{
				records = records.Where(r => r.UserId.ToString().Contains(searchValue)
					|| r.AddressDetail.ToLower().Contains(searchValue)
					|| r.ContactEmail.ToLower().Contains(searchValue)
					|| r.ContactMobile.Contains(searchValue)
					|| r.ContactTel.ToLower().Contains(searchValue)
					|| r.PostCode.ToString().ToLower().Contains(searchValue)
					|| r.Username.ToLower().Contains(searchValue));
			}

			if(filter.Order?.Count > 0)
			{
				switch (filter.Order[0].Column)
				{
					case (2):
						records = filter.Order[0].Dir == "asc" ? records.OrderBy(r => r.Username) : records.OrderByDescending(r => r.Username);
						break;
					default:
						records = filter.Order?[0].Dir == "asc" ? records.OrderBy(r => r.UserId) : records.OrderByDescending(r => r.UserId);
						break;
				}
			}

			int recordsFiltered = records.Count();
			records = records
				.Skip(filter.Start)
				.Take(filter.Length);

			return new DataTableResponse<GetUserDto>
			{
				RecordsTotal = recordsTotal,
				RecordsFiltered = recordsFiltered,
				Data = await records.ToListAsync()
			};
		}

		public async Task<GetUserDto> GetUserByIdAsync(int id)
		{
			AppUser? user = await _context.Set<AppUser>().FindAsync(id);
			if (user is null)
			{
				throw new Exception($"Not found user with id = {id}");
			}

			return new GetUserDto
			{
				UserId = user.UserId,
				Username = user.Username,
				AddressDetail = user.AddressDetail,
				AddressState = user.AddressState,
				AddressSuburb = user.AddressSuburb,
				ContactEmail = user.ContactEmail,
				ContactMobile = user.ContactMobile,
				ContactTel = user.ContactTel,
				DateOfBirth = user.DateOfBirth,
				LastModifiedDate = user.LastModifiedDate,
				LoginPermit = user.LoginPermit,
				Note = user.Note,
				PostCode = user.PostCode,
				RegisterDate = user.RegisterDate,
				UserLv = user.UserLv,
			};
		}

		public async Task<ApiResponse<CreateUserDto>> CreateUserAsync(CreateUserDto dto)
		{
			try
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
					AddressDetail = dto.AddressDetail,
					AddressState = dto.AddressState,
					AddressSuburb = dto.AddressSuburb,
					ContactEmail = dto.ContactEmail,
					ContactMobile = dto.ContactMobile,
					ContactTel = dto.ContactTel,
					DateOfBirth = dto.DateOfBirth,
					LastModifiedDate = dto.LastModifiedDate,
					LoginPermit = dto.LoginPermit,
					Password = passwordHash,
					PostCode = dto.PostCode,
					RegisterDate = dto.RegisterDate,
					UserLv = dto.UserLv,
					UserId = dto.UserId,
					Username = dto.Username
				};

				await _context.Set<AppUser>().AddAsync(user);
				return new ApiResponse<CreateUserDto>
				{
					IsSuccess = true,
					Data = dto,
				};
			}
			catch (Exception ex)
			{
				return new ApiResponse<CreateUserDto>
				{
					IsSuccess = false,
					Data = dto,
					ErrorMessage = ex.Message + ex.InnerException?.Message
				};
			}
		}

		public async Task<ApiResponse<UpdateUserDto>> UpdateUserAsync(UpdateUserDto dto)
		{
			try
			{
				AppUser? user = await _context.Set<AppUser>().FindAsync(dto.UserId);
				if (user is null)
				{
					throw new Exception($"Not found user with Id = {dto.UserId}");
				}

				user.AddressSuburb = dto.AddressSuburb;
				user.UserLv = dto.UserLv;
				user.UserId = dto.UserId;
				user.Username = dto.Username;
				user.Password = dto.Password;
				user.AddressDetail = dto.AddressDetail;
				user.AddressState = dto.AddressState;
				user.ContactEmail = dto.ContactEmail;
				user.ContactMobile = dto.ContactMobile;
				user.ContactTel = dto.ContactTel;
				user.DateOfBirth = dto.DateOfBirth;
				user.LoginPermit = dto.LoginPermit;
				user.PostCode = dto.PostCode;
				user.Note = dto.Note;
				return new ApiResponse<UpdateUserDto>
				{
					IsSuccess = true,
					Data = dto,
				};
			}
			catch (Exception ex)
			{
				return new ApiResponse<UpdateUserDto>
				{
					IsSuccess = false,
					Data = dto,
					ErrorMessage = ex.Message + ex.InnerException?.Message
				};
			}

		}
	}
}

using Domain.Entities;
using Infrastructure.Context;
using WebApi.DTOs;
using WebApi.ResponseModels;

namespace WebApi.Services
{
	public class ProfileService
	{
		private readonly AppDbContext _context;
		public ProfileService(AppDbContext context)
		{
			_context = context;
		}

		public async Task<ProfileDto> GetProfile(int id)
		{
			AppUser? user = await _context.Set<AppUser>().FindAsync(id);
			if (user is null)
			{
				throw new Exception($"Not found user with id = {id}");
			}

			return new ProfileDto
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
				PostCode = user.PostCode,
			};
		}

		public async Task<ApiResponse<UpdateProfileDto>> UpdateProfile(int id, UpdateProfileDto dto)
		{
			try
			{
				AppUser? user = await _context.Set<AppUser>().FindAsync(id);
				if (user is null)
				{
					throw new Exception($"Not found user with id = {id}");
				}

				user.AddressSuburb = dto.AddressSuburb;
				user.AddressDetail = dto.AddressDetail;
				user.AddressState = dto.AddressState;
				user.ContactEmail = dto.ContactEmail;
				user.ContactMobile = dto.ContactMobile;
				user.ContactTel = dto.ContactTel;
				user.DateOfBirth = dto.DateOfBirth;
				user.PostCode = dto.PostCode;

				await _context.SaveChangeAsync();

				return new ApiResponse<UpdateProfileDto>
				{
					IsSuccess = true,
					Data = dto,
				};
			}
			catch (Exception ex)
			{
				return new ApiResponse<UpdateProfileDto>
				{
					IsSuccess = false,
					Data = dto,
					ErrorMessage = ex.Message + ex.InnerException?.Message
				};
			}
		}
	}
}

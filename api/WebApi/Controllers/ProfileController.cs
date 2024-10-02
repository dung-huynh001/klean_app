using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApi.DTOs;
using WebApi.ResponseModels;
using WebApi.Services;

namespace WebApi.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class ProfileController : ControllerBase
	{
		private readonly ProfileService _profileService;
		public ProfileController(ProfileService profileService)
		{
			_profileService = profileService;
		}
		[HttpGet("GetProfile/{id}")]
		public async Task<IActionResult> GetProfile(int id)
		{
			ProfileDto profile = await _profileService.GetProfile(id);
			return Ok(profile);
		}

		[HttpPost("UpdateProfile/{id}")]
		public async Task<IActionResult> UpdateProfile(int id, UpdateProfileDto dto)
		{
			ApiResponse<UpdateProfileDto> response = await _profileService.UpdateProfile(id, dto);
			return Ok(response);
		}
	}
}

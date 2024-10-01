using Microsoft.AspNetCore.Mvc;
using WebApi.DTOs;
using WebApi.ResponseModels;
using WebApi.Services;

namespace WebApi.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class UserController : ControllerBase
	{
		private readonly UserService _userService;

		public UserController(UserService userService)
		{
			this._userService = userService;
		}
		[HttpGet("GetAllUser")]
		public async Task<IActionResult> GetAllUser()
		{
			List<GetUserDto> users = await _userService.GetAllUserAsync();
			return Ok(users);
		}

		[HttpPost("GetUsersAsync")]
		public async Task<IActionResult> GetUsers(DataTableParameters filter)
		{
			DataTableResponse<GetUserDto> result = await _userService.GetUsersAsync(filter);
			return Ok(result);
		}

		[HttpGet("GetUserById/{id}")]
		public async Task<IActionResult> GetUserById(int id)
		{
			GetUserDto user = await _userService.GetUserByIdAsync(id);
			return Ok(user);
		}

		[HttpPost("CreateUser")]
		public async Task<IActionResult> CreateUser(CreateUserDto dto)
		{
			ApiResponse<CreateUserDto> result = await _userService.CreateUserAsync(dto);
			return Ok(result);
		}

		[HttpPatch("UpdateUser/{id}")]
		public async Task<IActionResult> UpdateUser(UpdateUserDto dto)
		{
			ApiResponse<UpdateUserDto> result = await _userService.UpdateUserAsync(dto);
			return Ok(result);
		}
	}
}

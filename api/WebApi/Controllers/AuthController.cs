using FluentValidation;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using WebApi.DTOs;
using WebApi.ResponseModels;
using WebApi.Services;

namespace WebApi.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class AuthController : ControllerBase
	{
		private readonly AuthService _authService;
		private readonly IValidator<RegisterDto> _registerValidator;
		private readonly IValidator<RegisterByGuestDto> _registerByGuestValidator;

		public AuthController(AuthService authService, IValidator<RegisterDto> registerValidator, IValidator<RegisterByGuestDto> registerByGuestValidator)
		{
			this._authService = authService;
			this._registerValidator = registerValidator;
			this._registerByGuestValidator = registerByGuestValidator;
		}
		[HttpPost("Register")]
		public async Task<IActionResult> RegisterAsync(RegisterDto model)
		{
			try
			{
				var result = await _registerValidator.ValidateAsync(model);
				if (!result.IsValid)
				{
					string errors = JsonSerializer.Serialize(result.Errors);
					throw new InvalidDataException(errors);
				}
				RegisterResponse res = await _authService.RegisterAsync(model);
				return Ok(res);
			}
			catch
			{
				throw;
			}
		}

		[HttpPost("RegisterByGuest")]
		public async Task<IActionResult> RegisterByGuestAsync(RegisterByGuestDto model)
		{
			try
			{
				var result = await _registerByGuestValidator.ValidateAsync(model);
				if (!result.IsValid)
				{
					string errors = JsonSerializer.Serialize(result.Errors);
					throw new InvalidDataException(errors);
				}
				RegisterResponse res = await _authService.RegisterByGuestAsync(model);
				return Ok(res);
			}
			catch
			{
				throw;
			}
		}

		[HttpPost("Login")]
		public async Task<IActionResult> LoginAsync(LoginDto dto)
		{
			AuthResponse res = await _authService.LoginAsync(dto);
			return Ok(res);
		}
	}
}

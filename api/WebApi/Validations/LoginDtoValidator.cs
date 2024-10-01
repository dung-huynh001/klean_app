using FluentValidation;
using WebApi.DTOs;

namespace WebApi.Validations
{
	public class LoginDtoValidator : AbstractValidator<LoginDto>
	{
		public LoginDtoValidator()
		{
			RuleFor(e => e.Username)
				.NotEmpty()
				.NotNull()
				.WithMessage("Username is required");

			RuleFor(e => e.Password)
				.NotEmpty()
				.NotNull()
				.WithMessage("Password is required");
		}
	}
}

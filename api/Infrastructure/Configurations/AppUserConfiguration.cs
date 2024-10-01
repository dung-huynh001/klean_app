using Domain.Entities;
using Domain.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Configurations
{
	public class AppUserConfiguration : IEntityTypeConfiguration<AppUser>
	{
		[Obsolete]
		public void Configure(EntityTypeBuilder<AppUser> builder)
		{
			builder.HasKey(e => e.UserId);

			builder.Property(e => e.UserId)
				.ValueGeneratedNever();

			builder.HasCheckConstraint("CK_User_UserId_Range", "[UserId] >= 10000000 AND [UserId] <= 99999999");

			builder
				.HasIndex(e => e.Username)
				.IsUnique();

			builder
				.Property(e => e.Username)
				.HasColumnName("user_name")
				.HasMaxLength(20)
				.IsRequired();

			builder
				.Property(e => e.Password)
				.HasColumnName("password_hash")
				.HasMaxLength(100)
				.IsRequired();

			builder
				.Property(e => e.DateOfBirth)
				.HasColumnName("date_of_birth");

			builder
				.Property(e => e.ContactMobile)
				.HasColumnName("contact_mbile")
				.HasMaxLength(30)
				.IsRequired(false);

			builder
				.Property(e => e.ContactTel)
				.HasColumnName("contact_tel")
				.IsRequired(false);

			builder
				.Property(e => e.ContactEmail)
				.HasColumnName("cntact_email")
				.HasMaxLength(30)
				.IsRequired(false);

			builder
				.Property(e => e.UserLv)
				.HasColumnName("user_lv")
				.HasDefaultValue(UserLv.Lv3)
				.IsRequired();

			builder
				.Property(e => e.LoginPermit)
				.HasColumnName("login_permit")
				.HasDefaultValue(false)
				.IsRequired();

			builder
				.Property(e => e.RegisterDate)
				.HasColumnName("register_date")
				.IsRequired();

			builder
				.Property(e => e.LastModifiedDate)
				.HasColumnName("last_modified_date")
				.IsRequired();

			builder
				.Property(e => e.AddressState)
				.HasColumnName("address_state")
				.IsRequired(false);

			builder
				.Property(e => e.AddressSuburb)
				.HasColumnName("address_suburb")
				.IsRequired(false);

			builder
				.Property(e => e.AddressDetail)
				.HasColumnName("address_detail")
				.IsRequired(false);

			builder
				.Property(e => e.PostCode)
				.HasColumnName("postcode");

			builder
				.Property(e => e.Note)
				.HasColumnName("note")
				.HasMaxLength(500)
				.IsRequired(false);
		}
	}
}

using Domain.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure.Context
{
	public class AppDbContext : DbContext
	{
		public AppDbContext(DbContextOptions opt) : base(opt) { }

		public DbSet<AppUser> AppUsers { get; set; }

		protected override void OnModelCreating(ModelBuilder modelBuilder)
		{
			modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
			base.OnModelCreating(modelBuilder);
		}

		public virtual async Task<int> SaveChangeAsync()
		{
			foreach (var en in base.ChangeTracker.Entries()
					.Where(e => e.State == EntityState.Modified
					|| e.State == EntityState.Added
					&& e.Entity is AppUser))
			{
				AppUser entity = (en.Entity as AppUser)!;
				entity.LastModifiedDate = DateTime.Now;
			}

			return await base.SaveChangesAsync();
		}
	}
}

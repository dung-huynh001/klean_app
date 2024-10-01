using Domain.Entities;
using Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infrastructure
{
	public static class IServiceCollectionExtensions
	{
		public static void AddInfrastructure(this IServiceCollection service, IConfiguration configuration)
		{
			service.AddDbContext<AppDbContext>((opt) =>
			{
				opt.UseSqlServer(configuration.GetConnectionString("DbConnectionString"));
			});
		}
	}
}

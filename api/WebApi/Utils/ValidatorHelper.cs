using Infrastructure.Context;
using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace WebApi.Utils
{
	public class ValidatorHelper<TEntity> where TEntity : class
	{
		public static bool IsExist(AppDbContext context, string field, string value)
		{
			PropertyInfo? prop = typeof(TEntity).GetProperty(field);
			if (prop == null)
			{
				throw new ArgumentException($"Field {field} does not exist in {typeof(TEntity).Name}");
			}
			TEntity? entities = context.Set<TEntity>().AsNoTracking().FirstOrDefault(e => EF.Property<string>(e, field) == value);
			return entities == null;
		}

		public static bool IsExist(AppDbContext context, string field, int value)
		{
			PropertyInfo? prop = typeof(TEntity).GetProperty(field);
			if (prop == null)
			{
				throw new ArgumentException($"Field {field} does not exist in {typeof(TEntity).Name}");
			}
			TEntity? entities = context.Set<TEntity>().AsNoTracking().FirstOrDefault(e => EF.Property<int>(e, field) == value);
			return entities == null;
		}

		public static bool IsExist(AppDbContext context, string field, DateTime value)
		{
			PropertyInfo? prop = typeof(TEntity).GetProperty(field);
			if (prop == null)
			{
				throw new ArgumentException($"Field {field} does not exist in {typeof(TEntity).Name}");
			}
			TEntity? entities = context.Set<TEntity>().AsNoTracking().FirstOrDefault(e => EF.Property<DateTime>(e, field).Equals(value));
			return entities == null;
		}
	}
}

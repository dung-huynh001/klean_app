using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Inital : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "user_table",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "int", nullable: false),
                    user_name = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    password_hash = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    date_of_birth = table.Column<DateTime>(type: "datetime2", nullable: false),
                    contact_mbile = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: true),
                    contact_tel = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    cntact_email = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: true),
                    user_lv = table.Column<int>(type: "int", nullable: false, defaultValue: 2),
                    login_permit = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    register_date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    last_modified_date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    address_state = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    address_suburb = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    address_detail = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    postcode = table.Column<int>(type: "int", nullable: false),
                    note = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_user_table", x => x.UserId);
                    table.CheckConstraint("CK_User_UserId_Range", "[UserId] >= 10000000 AND [UserId] <= 99999999");
                });

            migrationBuilder.CreateIndex(
                name: "IX_user_table_user_name",
                table: "user_table",
                column: "user_name",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "user_table");
        }
    }
}

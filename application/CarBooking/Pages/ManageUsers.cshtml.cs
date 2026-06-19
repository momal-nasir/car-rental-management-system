using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using CarBooking.Data;
using CarBooking.Models;
using System.Collections.Generic;
using System.Linq;

namespace CarBooking.Pages
{
    public class ManageUsersModel : PageModel
    {
        private readonly AppDbContext _context;

        public ManageUsersModel(AppDbContext context)
        {
            _context = context;
        }

        public List<User> UsersList { get; set; }

        public IActionResult OnGet(int? deleteId)
        {
            // 🔐 Admin check
            if (HttpContext.Session.GetString("UserRole") != "Admin")
            {
                return RedirectToPage("/Login");
            }

            // 🗑 Delete user
            if (deleteId != null)
            {
                var user = _context.Users.FirstOrDefault(u => u.UserID == deleteId);

                if (user != null && user.Role != "Admin")
                {
                    // 🔍 Check if user has bookings
                    bool hasBookings = _context.Bookings.Any(b => b.UserID == user.UserID);

                    if (hasBookings)
                    {
                        // ❌ Do not delete
                        TempData["Message"] = "Cannot delete user with existing bookings!";
                    }
                    else
                    {
                        _context.Users.Remove(user);
                        _context.SaveChanges();
                    }
                }
            }

            // 📥 Load users (only customers)
            UsersList = _context.Users
                .Where(u => u.Role == "Customer")
                .ToList();

            return Page();
        }
    }
}
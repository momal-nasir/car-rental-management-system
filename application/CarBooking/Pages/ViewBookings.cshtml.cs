using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using CarBooking.Data;
using CarBooking.Models;
using System.Collections.Generic;
using System.Linq;

namespace CarBooking.Pages
{
    public class ViewBookingsModel : PageModel
    {
        private readonly AppDbContext _context;

        public ViewBookingsModel(AppDbContext context)
        {
            _context = context;
        }

        public List<Booking> BookingsList { get; set; }

        public IActionResult OnGet(int? cancelId)
        {
            // 🔐 Admin check
            if (HttpContext.Session.GetString("UserRole") != "Admin")
            {
                return RedirectToPage("/Login");
            }

            // ❌ Cancel booking
            if (cancelId != null)
            {
                var booking = _context.Bookings.FirstOrDefault(b => b.BookingID == cancelId);

                if (booking != null)
                {
                    booking.Status = "Cancelled";
                    _context.SaveChanges();
                }
            }

            // 📥 Load all bookings
            BookingsList = _context.Bookings.ToList();

            return Page();
        }
    }
}
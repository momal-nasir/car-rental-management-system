using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using CarBooking.Data;
using CarBooking.Models;
using System;
using System.Linq;

namespace CarBooking.Pages
{
    public class BookCarModel : PageModel
    {
        private readonly AppDbContext _context;

        public BookCarModel(AppDbContext context)
        {
            _context = context;
        }

        [BindProperty]
        public int CarID { get; set; }

        [BindProperty]
        public DateTime StartDate { get; set; }

        [BindProperty]
        public DateTime EndDate { get; set; }

        public string Message { get; set; }

        // 🔹 Load page with carId
        public IActionResult OnGet(int carId)
        {
            if (HttpContext.Session.GetString("UserEmail") == null)
            {
                return RedirectToPage("/Login");
            }

            CarID = carId;
            return Page();
        }

        // 🔹 Handle booking
        public IActionResult OnPost()
        {
            var userEmail = HttpContext.Session.GetString("UserEmail");

            if (userEmail == null)
            {
                return RedirectToPage("/Login");
            }

            // ✅ Get user
            var user = _context.Users.FirstOrDefault(u => u.Email == userEmail);
            if (user == null)
            {
                Message = "User not found!";
                return Page();
            }

            // ✅ Validate dates
            if (EndDate < StartDate)
            {
                Message = "End date must be after start date!";
                return Page();
            }

            if (StartDate < DateTime.Today)
            {
                Message = "Start date cannot be in the past!";
                return Page();
            }

            // 🔥 OVERLAP CHECK (CORE LOGIC)
            var isOverlap = _context.Bookings.Any(b =>
    b.CarID == CarID &&
    b.Status == "Booked" &&   // 🔥 IMPORTANT LINE
    (StartDate <= b.EndDate && EndDate >= b.StartDate)
);

            if (isOverlap)
            {
                Message = "This car is already booked for selected dates!";
                return Page();
            }

            // ✅ Get car
            var car = _context.Cars.FirstOrDefault(c => c.CarID == CarID);
            if (car == null)
            {
                Message = "Car not found!";
                return Page();
            }

            // 💰 Calculate total days
            int days = (EndDate - StartDate).Days + 1;

            // 💰 Calculate amount
            decimal totalAmount = days * car.PricePerDay;

            // 💾 Save booking
            var booking = new Booking
            {
                UserID = user.UserID,
                CarID = CarID,
                StartDate = StartDate,
                EndDate = EndDate,
                TotalAmount = totalAmount,
                Status = "Booked"
            };

            _context.Bookings.Add(booking);
            _context.SaveChanges();

            // 🔁 Redirect to Payment page
            return RedirectToPage("/Payment", new { bookingId = booking.BookingID });
        }
    }
}
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using CarBooking.Data;
using CarBooking.Models;
using System.Linq;

namespace CarBooking.Pages
{
    public class ReceiptModel : PageModel
    {
        private readonly AppDbContext _context;

        public ReceiptModel(AppDbContext context)
        {
            _context = context;
        }

        public Payment Payment { get; set; }
        public Booking Booking { get; set; }



        public string Name { get; set; }
        public string Contact { get; set; }
        public string Method { get; set; }
        public IActionResult OnGet(int paymentId, string name, string contact, string method)
        {
            if (HttpContext.Session.GetString("UserEmail") == null)
            {
                return RedirectToPage("/Login");
            }

            Payment = _context.Payments
                .FirstOrDefault(p => p.PaymentID == paymentId);

            if (Payment == null)
            {
                return RedirectToPage("/Index");
            }

            Booking = _context.Bookings
                .FirstOrDefault(b => b.BookingID == Payment.BookingID);

            // ✅ ASSIGN VALUES
            Name = name;
            Contact = contact;
            Method = method;

            return Page();
        }
    }
}
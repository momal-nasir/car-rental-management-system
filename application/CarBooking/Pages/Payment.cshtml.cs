using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using CarBooking.Data;
using CarBooking.Models;
using System;
using System.Linq;

namespace CarBooking.Pages
{
    public class PaymentModel : PageModel
    {
        private readonly AppDbContext _context;

        public PaymentModel(AppDbContext context)
        {
            _context = context;
        }

        public Booking Booking { get; set; }

        public decimal SecurityFee { get; set; }
        public decimal RentAmount { get; set; }
        public decimal TotalAmount { get; set; }

        [BindProperty]
        public string CustomerName { get; set; }

        [BindProperty]
        public string ContactNumber { get; set; }

        [BindProperty]
        public string PaymentMethod { get; set; }

        [BindProperty]
        public string AccountNumber { get; set; }

        // 🔹 GET METHOD
        public IActionResult OnGet(int bookingId)
        {
            if (HttpContext.Session.GetString("UserEmail") == null)
            {
                return RedirectToPage("/Login"); // ✅ correct redirect
            }

            Booking = _context.Bookings.FirstOrDefault(b => b.BookingID == bookingId);

            if (Booking == null)
            {
                return RedirectToPage("/Index");
            }

            RentAmount = Booking.TotalAmount;
            SecurityFee = 5000; // fixed fee
            TotalAmount = RentAmount + SecurityFee;

            return Page();
        }

        // 🔹 POST METHOD
        public IActionResult OnPost(int bookingId)
        {
            var booking = _context.Bookings.FirstOrDefault(b => b.BookingID == bookingId);

            if (booking == null)
            {
                return RedirectToPage("/Index");
            }

            decimal securityFee = 5000;

            if (securityFee < 0)
            {
                securityFee = 0;
            }

            decimal totalPaid = booking.TotalAmount + securityFee;

            var payment = new Payment
            {
                BookingID = bookingId,
                RentAmount = booking.TotalAmount,
                SecurityFee = securityFee,
                TotalPaid = totalPaid,
                PaymentDate = DateTime.Now
            };

            _context.Payments.Add(payment);
            _context.SaveChanges();

            // ✅ REDIRECT TO RECEIPT (CORRECT PLACE)
            return RedirectToPage("/Receipt", new
            {
                paymentId = payment.PaymentID,
                name = CustomerName,
                contact = ContactNumber,
                method = PaymentMethod
            });
        }
    }
}
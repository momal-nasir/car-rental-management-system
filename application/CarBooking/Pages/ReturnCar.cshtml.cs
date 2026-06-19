using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using CarBooking.Data;
using CarBooking.Models;
using System;
using System.Linq;

namespace CarBooking.Pages
{
    public class ReturnCarModel : PageModel
    {
        private readonly AppDbContext _context;

        public ReturnCarModel(AppDbContext context)
        {
            _context = context;
        }

        [BindProperty]
        public int BookingID { get; set; }

        [BindProperty]
        public bool DamageStatus { get; set; }

        public string Message { get; set; }

        public IActionResult OnGet()
        {
            if (HttpContext.Session.GetString("UserRole") != "Admin")
            {
                return RedirectToPage("/Login");
            }

            return Page();
        }

        public IActionResult OnPost()
        {

            if (BookingID <= 0)
            {
                Message = "Invalid Booking ID!";
                return Page();
            }
            if (HttpContext.Session.GetString("UserRole") != "Admin")
            {
                return RedirectToPage("/Login");
            }

            var booking = _context.Bookings.FirstOrDefault(b => b.BookingID == BookingID);

            if (booking == null)
            {
                Message = "Booking not found!";
                return Page();
            }

            var payment = _context.Payments.FirstOrDefault(p => p.BookingID == BookingID);

            if (payment == null)
            {
                Message = "Payment not found!";
                return Page();
            }

            decimal securityFee = payment.SecurityFee;

            if (securityFee < 0)
            {
                securityFee = 0;
            }

            decimal refundAmount;

            if (DamageStatus == false)
            {
                refundAmount = securityFee;
            }
            else
            {
                refundAmount = securityFee / 2;
            }

            // ✅ REFUND LOGIC
            if (DamageStatus == false)
            {
                refundAmount = payment.SecurityFee; // full
            }
            else
            {
                refundAmount = payment.SecurityFee / 2; // half
            }

            // 💾 Save return record
            var returnRecord = new Return
            {
                BookingID = BookingID,
                ReturnDate = DateTime.Now,
                DamageStatus = DamageStatus,
                RefundAmount = refundAmount,
                Remarks = DamageStatus ? "Damage detected - half refund" : "No damage - full refund"
            };

            _context.Returns.Add(returnRecord);

            // 🔁 Update booking status
            booking.Status = "Completed";

            _context.SaveChanges();

            Message = $"Return processed! Refund = {refundAmount}";

            return Page();
        }
    }
}
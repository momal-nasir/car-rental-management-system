using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using CarBooking.Data;
using CarBooking.Models;
using System.Collections.Generic;
using System.Linq;

namespace CarBooking.Pages
{
    public class ViewPaymentsModel : PageModel
    {
        private readonly AppDbContext _context;

        public ViewPaymentsModel(AppDbContext context)
        {
            _context = context;
        }

        public List<Payment> PaymentsList { get; set; }

        public IActionResult OnGet()
        {
            // 🔐 Admin check
            if (HttpContext.Session.GetString("UserRole") != "Admin")
            {
                return RedirectToPage("/Login");
            }

            PaymentsList = _context.Payments.ToList();

            return Page();
        }
    }
}
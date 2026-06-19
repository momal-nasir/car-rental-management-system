using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using CarBooking.Data;
using CarBooking.Models;
using System.Collections.Generic;
using System.Linq;

namespace CarBooking.Pages
{
    public class CarsModel : PageModel
    {
        private readonly AppDbContext _context;

        public CarsModel(AppDbContext context)
        {
            _context = context;
        }

        public List<Car> CarsList { get; set; }

        public IActionResult OnGet()
        {
            // 🔐 Protect page
            if (HttpContext.Session.GetString("UserEmail") == null)
            {
                return RedirectToPage("/Login");
            }

            // 📥 Fetch only available cars
            CarsList = _context.Cars
                .Where(c => c.Availability == true)
                .ToList();

            return Page();
        }
    }
}
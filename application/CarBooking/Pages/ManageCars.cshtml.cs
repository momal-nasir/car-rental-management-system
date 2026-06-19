using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using CarBooking.Data;
using CarBooking.Models;
using System.Collections.Generic;
using System.Linq;

namespace CarBooking.Pages
{
    public class ManageCarsModel : PageModel
    {
        private readonly AppDbContext _context;

        public ManageCarsModel(AppDbContext context)
        {
            _context = context;
        }

        public List<Car> CarsList { get; set; }

        public IActionResult OnGet(int? maintenanceId, int? availableId)
        {
            // 🔐 Admin check
            if (HttpContext.Session.GetString("UserRole") != "Admin")
            {
                return RedirectToPage("/Login");
            }

            // 🔧 Set Maintenance
            if (maintenanceId != null)
            {
                var car = _context.Cars.FirstOrDefault(c => c.CarID == maintenanceId);
                if (car != null)
                {
                    car.Availability = false;
                    _context.SaveChanges();
                }
            }

            // ✅ Set Available
            if (availableId != null)
            {
                var car = _context.Cars.FirstOrDefault(c => c.CarID == availableId);
                if (car != null)
                {
                    car.Availability = true;
                    _context.SaveChanges();
                }
            }

            CarsList = _context.Cars.ToList();

            return Page();
        }
    }
}
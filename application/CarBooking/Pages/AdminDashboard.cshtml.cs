using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CarBooking.Pages
{
    public class AdminDashboardModel : PageModel
    {
        public IActionResult OnGet()
        {
            if (HttpContext.Session.GetString("UserRole") != "Admin")
            {
                return RedirectToPage("/Login");
            }

            return Page();
        }
    }
}
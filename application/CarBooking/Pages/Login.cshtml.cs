using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using CarBooking.Data;
using System.Linq;

namespace CarBooking.Pages
{
    public class LoginModel : PageModel
    {
        private readonly AppDbContext _context;

        public LoginModel(AppDbContext context)
        {
            _context = context;
        }

        [BindProperty]
        public string Email { get; set; }

        [BindProperty]
        public string Password { get; set; }

        public string Message { get; set; }

        public void OnGet()
        {
        }

        public IActionResult OnPost()
        {
            var user = _context.Users
                .FirstOrDefault(u => u.Email == Email && u.Password == Password);

            if (user != null)
            {
                HttpContext.Session.SetString("UserEmail", user.Email);
                HttpContext.Session.SetString("UserRole", user.Role);

                if (user.Role == "Admin")
                {
                    return RedirectToPage("/AdminDashboard");
                }
                else
                {
                    return RedirectToPage("/Cars"); // customer flow
                }
            }
            else
            {
                Message = "Invalid Email or Password";
                return Page();
            }
        }
    }
}
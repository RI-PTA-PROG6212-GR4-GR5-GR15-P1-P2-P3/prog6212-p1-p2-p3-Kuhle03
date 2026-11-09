using Microsoft.AspNetCore.Mvc;

namespace RaceDayMvc.Controllers;

public class HomeController : Controller
{
    public IActionResult Index()
    {
        // Logged-in users go straight to their own home.
        var cookie = HttpContext.Session.GetString(RaceDayMvc.Infrastructure.SessionKeys.ApiCookie);
        if (!string.IsNullOrWhiteSpace(cookie))
            return RedirectToAction("Index", "Dashboard");

        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error() => View();
}

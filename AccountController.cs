using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc;
using RaceDayMvc.Infrastructure;
using RaceDayMvc.Models;

namespace RaceDayMvc.Controllers;

public class AccountController : ApiControllerBase
{
    private const string ApiSessionCookieName = ".RaceDay.Session";

    public AccountController(IHttpClientFactory factory) : base(factory) { }

    // ---------- Login ----------
    [HttpGet]
    public IActionResult Login()
    {
        if (!string.IsNullOrWhiteSpace(HttpContext.Session.GetString(SessionKeys.ApiCookie)))
            return RedirectToAction("Index", "Dashboard");
        return View(new LoginViewModel());
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Login(LoginViewModel model)
    {
        if (!ModelState.IsValid) return View(model);

        try
        {
            var request = new { email = model.Email, password = model.Password };
            var response = await Api().PostAsJsonAsync(ApiRoutes.Login, request);

            if (!response.IsSuccessStatusCode)
            {
                ModelState.AddModelError("", "Invalid email or password.");
                return View(model);
            }

            var user = await response.Content.ReadFromJsonAsync<AuthResponse>();
            var apiCookie = ExtractApiCookie(response);

            if (user == null || apiCookie == null)
            {
                ModelState.AddModelError("", "Login failed. Please try again.");
                return View(model);
            }

            // Fresh MVC session, then remember only what MVC needs. The password is never stored.
            HttpContext.Session.Clear();
            HttpContext.Session.SetString(SessionKeys.ApiCookie, apiCookie);
            HttpContext.Session.SetInt32(SessionKeys.UserId, user.UserId);
            HttpContext.Session.SetString(SessionKeys.Role, user.Role);
            HttpContext.Session.SetString(SessionKeys.Name, user.FullName);

            return RedirectToAction("Index", "Dashboard");
        }
        catch (HttpRequestException)
        {
            ModelState.AddModelError("", Unavailable);
            return View(model);
        }
        catch (TaskCanceledException)
        {
            ModelState.AddModelError("", Unavailable);
            return View(model);
        }
    }

    // ---------- Register ----------
    [HttpGet]
    public IActionResult Register() => View(new RegisterViewModel());

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Register(RegisterViewModel model)
    {
        if (!ModelState.IsValid) return View(model);

        var request = new
        {
            fullName = model.FullName,
            email = model.Email,
            password = model.Password,
            contactNumber = model.ContactNumber,
            role = model.Role
        };

        var result = await SendAsync<object>(HttpMethod.Post, ApiRoutes.Register, request);
        if (!result.Ok)
        {
            ModelState.AddModelError("", result.Error!);
            return View(model);
        }

        TempData["Success"] = "Account created. Please log in.";
        return RedirectToAction(nameof(Login));
    }

    // ---------- Logout ----------
    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Logout()
    {
        // End the API session too, then clear MVC's session. A failed API call must not block logging out.
        if (!string.IsNullOrWhiteSpace(HttpContext.Session.GetString(SessionKeys.ApiCookie)))
            await SendAsync<object>(HttpMethod.Post, ApiRoutes.Logout);

        HttpContext.Session.Clear();
        return RedirectToAction(nameof(Login));
    }

    public IActionResult AccessDenied() => View();

    /// <summary>Reads ".RaceDay.Session=value" from the API's Set-Cookie header.</summary>
    private static string? ExtractApiCookie(HttpResponseMessage response)
    {
        if (!response.Headers.TryGetValues("Set-Cookie", out var values)) return null;

        var header = values.FirstOrDefault(v => v.StartsWith(ApiSessionCookieName + "=", StringComparison.Ordinal));
        if (header == null) return null;

        var end = header.IndexOf(';');
        return end > 0 ? header[..end] : header;
    }
}

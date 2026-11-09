using Microsoft.AspNetCore.Mvc;
using RaceDayMvc.Infrastructure;
using RaceDayMvc.Models;

namespace RaceDayMvc.Controllers;

/// <summary>Organiser-only: add age / distance categories to an event.</summary>
[SessionAuthorize(Roles = Roles.Organiser)]
public class CategoriesController : ApiControllerBase
{
    public CategoriesController(IHttpClientFactory factory) : base(factory) { }

    public async Task<IActionResult> Index(int eventId)
    {
        var vm = await BuildAsync(eventId);
        if (vm == null)
        {
            TempData["Error"] = "That event could not be found.";
            return RedirectToAction("Index", "ManageEvents");
        }
        return View(vm);
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(CategoryFormModel form)
    {
        if (!ModelState.IsValid)
        {
            var vm = await BuildAsync(form.EventID);
            if (vm == null) return RedirectToAction("Index", "ManageEvents");
            vm.Form = form;
            return View("Index", vm);
        }

        var dto = new { name = form.Name, distance = form.Distance, maxParticipants = form.MaxParticipants };
        var result = await SendAsync<object>(HttpMethod.Post, ApiRoutes.EventCategories(form.EventID), dto);

        if (result.Ok) TempData["Success"] = "Category added.";
        else TempData["Error"] = result.Error;

        return RedirectToAction(nameof(Index), new { eventId = form.EventID });
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id, int eventId)
    {
        var result = await SendAsync<object>(HttpMethod.Delete, ApiRoutes.CategoryById(id));
        if (result.Ok) TempData["Success"] = "Category removed.";
        else TempData["Error"] = result.Error;

        return RedirectToAction(nameof(Index), new { eventId });
    }

    private async Task<CategoriesPageViewModel?> BuildAsync(int eventId)
    {
        var ev = await GetAsync<EventDto>(ApiRoutes.EventById(eventId));
        if (!ev.Ok || ev.Data == null) return null;
        if (ev.Data.OrganiserID != CurrentUserId) return null;   // not your event

        var cats = await GetAsync<List<CategoryDto>>(ApiRoutes.EventCategories(eventId));
        return new CategoriesPageViewModel
        {
            Event = ev.Data,
            Categories = cats.Data ?? new List<CategoryDto>(),
            Form = new CategoryFormModel { EventID = eventId }
        };
    }
}

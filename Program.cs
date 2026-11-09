var builder = WebApplication.CreateBuilder(args);

// MVC
builder.Services.AddControllersWithViews(options =>
{
    // Non-nullable strings in view models are not automatically "required"
    options.SuppressImplicitRequiredAttributeForNonNullableReferenceTypes = true;
});

// Session: remembers the logged-in user's API session cookie, role and name
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.Cookie.Name = ".RaceDay.Mvc.Session";
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

//Configure the MVC application and services
builder.Services.AddHttpClient("Api", client =>
{
    var url = builder.Configuration["ApiSettings:BaseUrl"]
              ?? throw new Exception("API URL missing");
    client.BaseAddress = new Uri(url);
    client.Timeout = TimeSpan.FromSeconds(30);
})
.ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler { UseCookies = false });

var app = builder.Build();

app.UseExceptionHandler("/Home/Error");
app.UseStatusCodePagesWithReExecute("/Home/Error");
app.UseStaticFiles();
app.UseRouting();
app.UseSession();          // must run before controllers
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();

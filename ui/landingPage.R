landingPageUI <- fluidPage(
 
   # Head with Tailwind + Flowbite CDN
  tags$head(
    tags$script(src = "https://cdn.tailwindcss.com"),
    tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/flowbite@4.0.1/dist/flowbite.min.css"),
    tags$script(src = "https://cdn.jsdelivr.net/npm/flowbite@4.0.1/dist/flowbite.min.js"),
    tags$style(HTML("
      body, .container-fluid, .shiny-html-output {
        margin: 0;
        padding: 0;
      }
    "))
  ),
  
  # Navbar and Banner
  navbarUI("mainNavbar", currentPage = "landingPage"),
  bannerUI("bannerUI"),
  
  # Anime cards (example)
  tags$div(class = "overflow-x-auto whitespace-nowrap",
           uiOutput("animeCategorieswithSearch"),
           uiOutput("animeCards")
  ),
  
  uiOutput("animeModals"),  
  
  tags$div(class = "flex mt-6 mb-6 justify-center",
  uiOutput("animePagination")
  ),
  
  
  tags$script(HTML("
  let animeModalInstance = null;

  Shiny.addCustomMessageHandler('showModal', function(message) {
    setTimeout(function() {
      const modalEl = document.getElementById(message.id);
      if (modalEl) {
        animeModalInstance = new Modal(modalEl, {
          placement: 'center',
          backdrop: 'dynamic'
        });
        animeModalInstance.show();
      }
    }, 100);
  });

  Shiny.addCustomMessageHandler('closeModal', function(message) {
    if (animeModalInstance) {
      animeModalInstance.hide();
    }
  });
"))
  
  
)
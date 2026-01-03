landingPageUI <- tagList(

  # Navbar and Banner
  navbarUI("mainNavbar", currentPage = "landingPage"),
  bannerUI("bannerUI"),
  
  # Anime cards 
  animeCardsUI("anime"), 
  
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
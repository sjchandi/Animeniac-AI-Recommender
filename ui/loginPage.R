loginPage <- function(id) {
  ns <- NS(id)
  
  tagList(
    # Container
    div(class = "flex min-h-screen items-center justify-center bg-gray-100 px-6 py-12",
        div(class = "w-full max-w-lg bg-white rounded-xl shadow-lg p-16 space-y-8",
            div(class = "text-center",
                tags$img(
                  src = "LogoNav.png",
                  alt = "Animeniac",
                  class = "mx-auto h-20 w-auto"
                ),
                tags$h2(
                  class = "mt-6 text-center text-4xl font-bold tracking-tight text-gray-900",
                  "Sign in to your account"
                )
            ),
            
            # Login form
            div(
              # Username
              div(
                tags$label(`for` = ns("username"), class = "block text-lg font-medium text-gray-900", "Username"),
                div(class = "mt-2",
                    div(class = "block w-full rounded-md text-xl text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-orange-600 mb-4",
                        textInput(
                          ns("username"),
                          label = NULL,
                          placeholder = "Enter your email",
                          width = "100%"
                        )
                    )
                )
              ),
              
              # Password
              div(
                div(class = "items-center justify-between",
                    tags$label(`for` = ns("password"), class = "block text-lg font-medium text-gray-900", "Password")
                ),
                div(class = "mt-2",
                    div(class = "block w-full rounded-md text-xl text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-orange-600 mb-4",
                        passwordInput(
                          ns("password"),
                          label = NULL,
                          placeholder = "Enter your password",
                          width = "100%"
                        )
                    )
                )
              ),
              
              # Login button
              div(
                actionButton(
                  ns("loginBtn"),
                  label = "Sign in",
                  class = "flex w-full justify-center rounded-md bg-orange-600 px-6 py-4 text-xl font-semibold text-white shadow-md hover:bg-orange-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-orange-600"
                )
              )
            )
        )
    )
  )
}

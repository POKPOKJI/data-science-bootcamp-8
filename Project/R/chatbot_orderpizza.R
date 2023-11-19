
order_pizza <- function(){
  while (TRUE){
    readline("Hello sir what would you like to order\n Today we have papperoni and hawaiian")
    name <- tolower(readLines("stdin",n=1))
    if (name == "papperoni"){
      price <- 1000
    } else if (name == "hawaiian"){
      price <- 1500
    } else {
      print(paste("Today we don't have",name,"sorry sir"))
      break 
    }
    readline("Would you like a thin or regular crust sir? ")
    size <- readLines("stdin",n=1)
    if (size == "thin"){
      price <- price + 100
      } else {
        price <- price 
      }
    readline("And would you like to add some extra cheese?")
    extra <- readLines("stdin",n=1)
    if (extra == "yes"){
      price <- price + 100
    } else {
      price <- price
    }
    readline("Excellent Sir")
    print(paste("A total price is",price,"Bath sir"))
    readline("Enjoy a meal")
    break
    }
}

order_pizza()

ma_dee <- function(){
  com <- c("rock","paper","scissor")
  round <- 0
  draw  <- 0
  win   <- 0
  lose  <- 0
  while(TRUE){
    round <- round + 1
    readline(paste("ROUND",round,"Your turn"))
    readline("ROCK | PAPER | SCISSOR")
    player <- tolower(readLines("stdin",n =1))
    com_choose <- sample(com,1)
    if (player == "quit"){
      readline(paste("Total round is :",round,"
      Win is  :",win,"
      Draw is :",draw,"
      Lose is :",lose,"
      Thanks for playing"))
      break
    }
    readline(paste("COM :",com_choose))
    if (player == com_choose){
      readline("Draw")
      draw <- draw +1
    } else if (player == "rock" & com_choose == "scissor"){
      readline("Win")
      win <- win + 1 
    } else if (player == "paper" & com_choose == "rock"){
      readline("Win")
      win <- win + 1
    } else if (player == "scissor" & com_choose == "paper"){
      readline("Win")
      win <- win + 1
    } else {
      readline("Lose")
      lose <- lose + 1
    }
  }
}

ma_dee()

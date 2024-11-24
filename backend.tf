terraform { 
  cloud { 
    
    organization = "MTCITF-NOV24" 

    workspaces { 
      name = "pht-dev" 
    } 
  } 
}
#include <amxmodx>

public made_hs(id){ 
  // Get Killer information:
  new killer = read_data(1) 

  new nameK[32]
  get_user_name(killer, nameK ,31 )

  new authidK[32]
  get_user_authid(killer, authidK , 31 )
  
  new teamK[11]
  get_user_team(killer, teamK, 10)

  // Get Victim information:
  new victim = read_data(2) 

  new nameV[32]
  get_user_name(victim, nameV ,31 )

  new authidV[32]
  get_user_authid(victim, authidV , 31 )

  new teamV[11]
  get_user_team(victim, teamV, 10)

  // Log head shot event with all corresponding information
  // TODO: Log waepon
  log_message("^"%s<%d><%s><%s>^" made a HS on ^"%s<%d><%s><%s>^"",nameK,killer,authidK,teamK,nameV,victim,authidV,teamV)

  return PLUGIN_CONTINUE 
} 

public plugin_init(){    
   register_plugin("Headshot logger","0.0.1","MeMeK") 
   register_event   ("DeathMsg","made_hs","ade", "3=1", "5=0" ) 
   return PLUGIN_CONTINUE 
}


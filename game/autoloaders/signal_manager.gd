extends Node

signal toaster_action_enter
signal toaster_action_exit

signal toilet_action_enter
signal toilet_action_exit

signal tv_action_enter
signal tv_action_exit

signal lamp_action_enter
signal lamp_action_exit

signal heater_action_enter
signal heater_action_exit

signal baby_enter
signal baby_exit

#HUD Only
signal laser_fired
signal dash_dashed
signal action_actioned

signal risk_item_lasered(collidedThing)
signal risk_item_dashed(collidedThing)
signal baby_saved
signal win_condition_achieved
signal current_risk_item(current_risk)

signal chair_enter
signal chair_exit

signal update_score(score: int)

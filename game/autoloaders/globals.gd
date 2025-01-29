extends Node

var action_ready: bool = false
var chair_ready: bool = false
var in_the_chair: bool = false
var target_chair: StaticBody2D = null
var heartbeat_pulse_ready: bool = true
var toaster_action_ready: bool = false
var toilet_action_ready: bool = false
var tv_action_ready: bool = false
var lamp_action_ready: bool = false
var heater_action_ready: bool = false
var dashing: bool = false
var risk_group = ["RiskItems"]
var move_cooldown: bool = true
var current_risk:StaticBody2D = null
const game_timer: int = 40

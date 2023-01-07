extends Node2D

onready var PortalParticles = $CPUParticles2D

func _on_ParticleEffectArea_area_entered(_area):
	PortalParticles.emitting = true


func _on_ParticleEffectArea_area_exited(_area):
	PortalParticles.emitting = false

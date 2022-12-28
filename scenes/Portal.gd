extends Node2D

onready var PortalParticles = $CPUParticles2D

func _on_ParticleEffectArea_area_entered(area):
	PortalParticles.emitting = true


func _on_ParticleEffectArea_area_exited(area):
	PortalParticles.emitting = false

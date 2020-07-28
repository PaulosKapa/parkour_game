extends RigidBody

func explode():
	print("boom")
	$Area6/Particles.set_emitting(true)

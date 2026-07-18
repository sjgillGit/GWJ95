extends CharacterBody3D



signal coffin_interacted(coffin)

func interacted():
	coffin_interacted.emit(self)

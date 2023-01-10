extends Node

enum Sprites {
	WIZARD,
	MAN,
	WOMAN,
	BLACKSMITH,
	VIKING,
	BARBARIAN,
	KNIGHT,
	GHOST,
	CYCLOPS,
	CRAB,
	WARLOCK,
	RANGER,
	BAT,
	SPIDER,
	RAT,
	MIMIC
}

const SPRITE_LOCATIONS := {
	Sprites.WIZARD: 		Rect2(0,   112, 16, 16),
	Sprites.MAN: 			Rect2(16,  112, 16, 16),
	Sprites.WOMAN: 			Rect2(48,  128, 16, 16),
	Sprites.BLACKSMITH: 	Rect2(32,  112, 16, 16),
	Sprites.VIKING: 		Rect2(48,  112, 16, 16),
	Sprites.BARBARIAN: 		Rect2(64,  112, 16, 16),
	Sprites.KNIGHT: 		Rect2(32,  128, 16, 16),
	Sprites.GHOST: 			Rect2(16,  160, 16, 16),
	Sprites.CYCLOPS: 		Rect2(16,  144, 16, 16),
	Sprites.CRAB: 			Rect2(32,  144, 16, 16),
	Sprites.WARLOCK: 		Rect2(48,  144, 16, 16),
	Sprites.RANGER: 		Rect2(64,  144, 16, 16),
	Sprites.BAT: 			Rect2(0,   160, 16, 16),
	Sprites.SPIDER: 		Rect2(32,  160, 16, 16),
	Sprites.RAT: 			Rect2(64,  160, 16, 16),
	Sprites.MIMIC: 			Rect2(128, 112, 16, 16)
}

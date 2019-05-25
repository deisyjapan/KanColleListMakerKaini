
#module

#deffunc MakeBackgroundImage int drawImageId, int tempImageId

	baseColR = 238
	baseColG = 229
	baseColB = 216

	buffer drawImageId, BASE_SIZE_W, BASE_SIZE_H

	redraw 0
	repeat (BASE_SIZE_W/4)*(BASE_SIZE_H/4)
		color baseColR-5+rnd(11), baseColG-5+rnd(11), baseColB-5+rnd(11)
		pset cnt\(BASE_SIZE_W/4), cnt/(BASE_SIZE_W/4)
	loop
	redraw 1

	buffer tempImageId, BASE_SIZE_W, BASE_SIZE_H
	gzoom BASE_SIZE_W, BASE_SIZE_H, drawImageId, 0, 0, BASE_SIZE_W/4, BASE_SIZE_H/4, 10

	gsel drawImageId
	color baseColR, baseColG, baseColB
	boxf
	gmode 3, BASE_SIZE_W, BASE_SIZE_H, 130
	gcopy tempImageId, 0, 0, BASE_SIZE_W, BASE_SIZE_H
	gmode

	buffer tempImageId, 1, 1
return

#global

#if 0
	makeBackgroundImage 1, 2
	screen 0, BASE_SIZE_W, BASE_SIZE_H
	gcopy 1, 0, 0, BASE_SIZE_W, BASE_SIZE_H
#endif

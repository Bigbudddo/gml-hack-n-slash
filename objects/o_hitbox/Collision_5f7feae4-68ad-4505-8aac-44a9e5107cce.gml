if (creator == noone || creator == other || ds_list_find_index(hit_objects, other) >= 0) {
	exit;
}

ds_list_add(hit_objects, other);

other.hp -= damage;
audio_play_sound(a_medium_hit, 4, false);
repeat (10) {
	instance_create_layer(other.x, other.y - 12, "Effects", o_hit_effect);	
}

if (instance_exists(o_skeleton)) {
	// we hit the player
	if (other.object_index == o_skeleton) {
		add_screenshake(6, 10);
		
		if (other.hp <= 0) {
			var number = sprite_get_number(s_skeleton_bones);
			for (var i = 0; i < number; i++) {
				var bx = other.x + random_range(-8, 8);
				var by = other.y + random_range(-24, 8);
				var bone = instance_create_layer(bx, by, "Instances", o_skeleton_bone);	
			
				bone.direction = 90 - (image_xscale * random_range(30, 60));
				bone.speed = random_range(3, 10);
				bone.image_index = i;
			
				if (i == 5) {
					bone.image_angle = 130;	
				}
			}
			
			ini_open("save.ini");
			ini_write_real("Scores", "Kills", other.kills);
			var highscore = ini_read_real("Scores", "Highscore", 0);
			if (other.kills > highscore) {
				ini_write_real("Scores", "Highscore", other.kills);	
			}
			ini_close();
		}
	}
	else {
		// it's an enemy
		other.alarm[0] = 120;
		add_screenshake(2, 5);
		
		if (creator.object_index == o_skeleton && other.hp <= 0 && other.state != "death") {
			o_skeleton.kills += 1;
		}
	}
}

if (other.state != "death" && other.object_index != o_boss) {
	other.state = "knockback";
}

other.image_xscale = -image_xscale;
other.knockback_speed = knockback * image_xscale;

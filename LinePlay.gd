extends Node2D

var audio = AudioStreamPlayer.new() #adds new audio player
var audio_file = "res://Henry5.mp3"
var audio_length
var wait_time = .35 #how many seconds to wait before creating a line/object

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	clear_all()
	audioload()
	genart()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		genart()

#adds audiofile
func audioload():
	audio.stream = load(audio_file)
	audio.volume_db = 0
	add_child(audio)
	audio_length = audio.stream.get_length()

#plays a short amount of the audiosteam
func audioflick():
	var random_start
	random_start = rand_range(0, audio_length)
	audio.play(random_start)

	#very inefficiently creating a timer to play a short bit
	var timer = Timer.new()
	timer.set_wait_time(wait_time)
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	audio.stop()

func genart():
	background() #create new background
	circle()
	
	#then, generate X lines
	for i in rand_range(2,7):
		audioflick()
		#waits a short while before creating lines
		yield (get_tree().create_timer(wait_time), "timeout")
		sololine()

func background():
	var dark = .05
	var color_rect = ColorRect.new()
	var random_color = Color(rand_range(0,dark), rand_range(0,dark), rand_range(0,dark), 1)
	color_rect.set_modulate(random_color)
	color_rect.rect_min_size = Vector2(720, 960)
	add_child(color_rect)

func sololine():
	#creates a new line object
	var line = Line2D.new()
	add_child(line)
	
#	line.antialiased = true
	
	#creating two random points on canvas	
	line.add_point(Vector2(rand_range(0,720),rand_range(0,960)))
	line.add_point(Vector2(rand_range(0,720),rand_range(0,960)))
	
	# Randomize color
	var random_color = Color(randf(), randf(), randf(), 1.0)  # Generates a random color with alpha = 1
	line.set_default_color(random_color)
	
	# Randomize width
	var random_width = rand_range(5,150)
	line.set_width(random_width)
	
	update()

func circle():
	# Create a new Polygon2D node
	var circle = Polygon2D.new()

	# Define the number of sides for the polygon (more sides for a smoother circle)
	var sides = rand_range(3,32)

	# Define the radius of the circle
	var radius = rand_range(1,900)

	# Create the points for the circle
	var points = []
	for i in range(sides):
		var angle = i * (2 * PI / sides)  # Calculate the angle for each point
		var x = cos(angle) * radius  # Calculate x-coordinate
		var y = sin(angle) * radius  # Calculate y-coordinate
		points.append(Vector2(x, y))  # Add the point to the list
		
	circle.polygon = points
	
	var light = .5
	
	circle.color = Color(rand_range(light,1), rand_range(light,1), rand_range(light,1), 1)
	circle.position = Vector2(rand_range(0,720),rand_range(0,960))
	add_child(circle)
	

func clear_all():
	# Iterate through nodes and deletes all children
	for child in get_children():
		child.queue_free()

extends Node

## List of global signals
## Declare with signal signal_name_here(parameters_here: type_here)
## Emit signal with Global.signal_name_here.emit(parameters_here)
## Connect signal in _ready() with Global.signal_name_here.connect(_function_name_here)
## Receive signal with func _function_name_here(parameters_here: type_here)

signal open_book()
signal close_book()

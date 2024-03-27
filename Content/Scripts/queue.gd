class_name Queue
extends RefCounted

#Queue의 데이터 구조 기술 
class QueueNode:
	var data
	var next
	
	func _init(new_data) -> void:
		data = new_data
		next = null
		
var _head: QueueNode #맨 앞 노드
var _tail: QueueNode #맨 뒤 노드
var _length: int
var _max_length: int

func _init(max_length: int = 50) -> void:
	_head = null
	_tail = null
	_length = 0
	_max_length = max_length
	
func enqueue(data) -> void:
	assert(_length < _max_length, "Unable to enqueue data - Queue is full")
	var new_node = QueueNode.new(data)
	if _head == null:
		_head = new_node
		_tail = new_node
	else:
		_tail.next = new_node
		_tail = new_node
	_length += 1
	
func dequeue():
	assert(_length > 0, "Unable to dequeue data - Queue is empty")
	var data = _head.data
	var free_data = _head #원래 헤드를 free 하기 위한 자료 저장 
	_head = _head.next
	_length -= 1
	if _length == 0:
		_tail = null
	return data
	
func peek():
	return _head.data

func is_empty() -> bool:
	return _length == 0

func is_full() -> bool:
	return _length == _max_length

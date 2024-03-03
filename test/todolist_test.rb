require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

# Since lib and test are both inside the main project directory, we tell require_relative to move up one level (the ..), 
# then down inside lib, and finally to load todolist_project.rb.
require_relative '../lib/todolist_project'

class TodoListTest < Minitest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  # Your tests go here. Remember they must start with "test_"
  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    assert_equal(@todo1, @list.shift)
    # assert_equal(2, @list.size) # tests the length of the list after shift happens
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    assert_equal(@todo3, @list.pop)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done_question
    assert_equal(false, @list.done?)
  end

  def test_add_raise_error
    assert_raises(TypeError) { @list.add(1) }
    assert_raises(TypeError) { @list.add('hi') }
  end

  def test_shovel
    todo4 = Todo.new("Clean car")
    @list << todo4
    @todos << todo4
    assert_equal(@todos, @list.to_a)
  end

  def test_add
    todo4 = Todo.new("Clean car")
    @todos << todo4
    @list.add(todo4)
    assert_equal(@todos, @list.to_a)
  end

  def test_item_at
    assert_equal(@todos[1], @list.item_at(1))
    assert_raises(IndexError) { @list.item_at(4) }
  end

  def mark_done_at
    @todos[1].done!
    assert_equal(@todos[1].done?, @list.mark_done_at(1))
    assert_raises(IndexError) { @list.mark_done_at(5) }
    #assert_equal(false, @todo1.done?)
    #assert_equal(true, @todo2.done?)
    #assert_equal(false, @todo3.done?)
  end

  def mark_undone_at
    @todo1.done!
    @todo2.done!
    @todo3.done!
    @list.mark_undone_at(1)
    assert_equal(false, @todo2.done?)
    assert_raises(IndexError) { @list.mark_undone_at(5) }
  end

  def test_done!
    @list.done!
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_equal(true, @list.done?)
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
  
    assert_equal(output, @list.to_s)
  end

  def test_to_s_2
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
    @list.mark_done_at(0)
    assert_equal(output, @list.to_s)
  end

  def test_to_s_all_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
    @list.mark_all_done
    assert_equal(output, @list.to_s)
  end

  def test_each
    new_arr = []
    @list.each { |elem| new_arr << elem}
    assert_equal(new_arr, @list.to_a)
  end

  def test_each_return
    new_list = @list.each { |elem| puts "elem" }
    assert_equal(new_list, @list)
  end

  def test_select
    @todo1.done!
    list = TodoList.new(@list.title)
    list.add(@todo1)
    assert_equal(list.title, @list.title)
    assert_equal(list.to_s, @list.select{ |todo| todo.done? }.to_s)
  end
end

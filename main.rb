require_relative 'lib/tree'

# tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
arr = (Array.new(15) { rand(1..100) })
tree = Tree.new(arr)
puts "\n"
tree.pretty_print
puts "\nBalanced?: #{tree.balanced?}"
puts "\nLevel Order Iterative: #{tree.level_order_it}"
puts "\nLevel Order Recursive: #{tree.level_order_rec}"
puts "\nPreorder: #{tree.preorder}"
puts "\nPostorder: #{tree.postorder}"
puts "\nInorder: #{tree.inorder}\n\n"
tree.insert(123)
tree.insert(5432)
tree.insert(2211)
tree.insert(212)
tree.insert(799)
tree.pretty_print
puts "\nBalanced?: #{tree.balanced?}"
tree.rebalance
puts "\nBalancing tree...\n\n"
tree.pretty_print
puts "\nBalanced?: #{tree.balanced?}"
puts "\nPreorder: #{tree.preorder}"
puts "\nPostorder: #{tree.postorder}"
puts "\nInorder: #{tree.inorder}\n\n"
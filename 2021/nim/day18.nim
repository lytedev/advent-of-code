import ./common, std/[sequtils, algorithm, sugar, sets, strformat, strutils, tables, options]

type
  BinaryTreeNodePathSegment = enum left, right
  BinaryTreeNodePath = seq[BinaryTreeNodePathSegment]
  BinaryTreeNodeKind = enum
    leaf
    branch
  BinaryTreeNode = ref BinaryTreeNodeObj
  BinaryTreeNodeObj = object
    case kind: BinaryTreeNodeKind
    of leaf: value: uint64
    of branch: left, right: BinaryTreeNode
  BinaryTreeNodeParseResult = object
    node: BinaryTreeNodeObj
    parsed_length: uint64

proc parseBinaryTree(s: string): (BinaryTreeNode, uint64) =
  case s[0]:
    of '0'..'9': result = (BinaryTreeNode(kind: leaf, value: uint8(s[0]) - uint8('0')), 1'u64)
    of '[':
      let (left, leftLen) = parseBinaryTree(s[1..^1])
      let (right, righLen) = parseBinaryTree(s[2+leftLen..^1])
      result = (BinaryTreeNode(kind: branch, left: left, right: right), 3'u64 + leftLen + righLen)
    else:
      echo "unexpected string"

proc nodeAt(node: BinaryTreeNode, path: BinaryTreeNodePath): Option[BinaryTreeNode] =
  var curNode = node
  for p in path:
    if curNode.kind == leaf: return none(BinaryTreeNode)
    case p:
      of left: curNode = node.left
      of right: curNode = node.left
  return some(curNode)

proc crawlFor(node: BinaryTreeNode, predicate: (node: BinaryTreeNode, path: BinaryTreeNodePath) -> bool, path: BinaryTreeNodePath = @[], preferredSide: BinaryTreeNodePathSegment = left): Option[BinaryTreeNodePath] =
  if node.predicate(path): return some(path)
  elif node.kind == branch:
    if preferredSide == left:
      let lp = path & @[left]
      let ln = node.left.crawlFor(predicate, lp, preferredSide)
      if ln.isSome: return some(lp)
      let rp = path & @[right]
      let rn = node.right.crawlFor(predicate, rp, preferredSide)
      if rn.isSome: return some(rp)
    else:
      let rp = path & @[right]
      let rn = node.right.crawlFor(predicate, rp, preferredSide)
      if rn.isSome: return some(rp)
      let lp = path & @[left]
      let ln = node.left.crawlFor(predicate, lp, preferredSide)
      if ln.isSome: return some(lp)
  return none(BinaryTreeNodePath)

when not defined(release):
  block:
    let (bt, n) = parseBinaryTree("[[1,2],3]")
    assert bt.right.value == 3'u64
    assert bt.left.left.value == 1'u64
    assert bt.left.right.value == 2'u64
    assert n == 9

proc valueLeftOf(node: BinaryTreeNode, path: BinaryTreeNodePath): Option[BinaryTreeNodePath] =
  var walker = path
  while walker.len > 0:
    if walker.pop == right:
      let subPath = walker & @[left]
      echo subPath
      let subNode = node.nodeAt(subPath)
      if subNode.isSome:
        echo subPath, path
        echo subNode.get.kind
        let candidatePath = subNode.get.crawlFor((n, _) => n.kind == leaf, @[], right)
        if candidatePath.isSome: return some(subPath & candidatePath.get)
  return none(BinaryTreeNodePath)

when not defined(release):
  block:
    let (bt, _) = parseBinaryTree("[[1,2],3]")
    assert bt.valueLeftOf(@[right]) == some(@[left, right])
    assert bt.valueLeftOf(@[left, left]) == none(BinaryTreeNodePath)
    assert bt.valueLeftOf(@[left, right]) == some(@[left, left])
    let (bt2, _) = parseBinaryTree("[1,[2,3]]")
    assert bt2.valueLeftOf(@[right, right]) == some(@[right, left])
    assert bt2.valueLeftOf(@[right, left]) == some(@[left])

proc explodeAt(node: var BinaryTreeNode, path: BinaryTreeNodePath) =
  return
  # TODO: implement exploding

proc splitAt(node: var BinaryTreeNode, path: BinaryTreeNodePath) =
  return
  # TODO: implement exploding

proc p1(input: Lines): uint64 =
  var (bt, _) = input[0].parseBinaryTree()
  # TODO: iterate over the input, parsing into binary trees
  # fold over the binary trees, creating a new btree with each child btree as children
  # reduce that btree via explode/split rules
  # calculate magnitude
  let explodePath = bt.crawlFor((_, p) => p.len() > 4)
  let splitPath = bt.crawlFor((n, _) => n.kind == leaf and n.value >= 10)

const input = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
""".strip().split('\n').mapIt(it.strip)
doDayX 18, (n: int) => n.loadInput, p1, p1, (input, 4140'u64, 0'u64)
